"""Import aus einem OSM-Extrakt (z. B. Geofabrik `germany-latest.osm.pbf`).

Liest Arztpraxen (amenity=doctors/dentist, healthcare=doctor/dentist/
psychotherapist) und Hausadressen (für PLZ-/Adresssuche) und baut daraus eine
neue SQLite-Datei, die erst am Ende atomar die alte ersetzt.

    python -m arztsuche.importer --pbf germany-latest.osm.pbf --out /data/arztsuche.sqlite
"""

from __future__ import annotations

import argparse
import logging
import os
import sys
import time
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

import osmium

from . import db
from .optout import load_optout
from .specialties import parse_specialties
from .text import city_key, norm_key

log = logging.getLogger("arztsuche.import")

_PRAXIS_AMENITY = {"doctors": "doctor", "dentist": "dentist"}
_PRAXIS_HEALTHCARE = {"doctor": "doctor", "dentist": "dentist", "psychotherapist": "psychotherapist"}


def _kind(tags) -> str | None:
    hc = tags.get("healthcare")
    if hc in _PRAXIS_HEALTHCARE:
        return _PRAXIS_HEALTHCARE[hc]
    return _PRAXIS_AMENITY.get(tags.get("amenity"))


def _first(tags, *keys) -> str | None:
    for k in keys:
        v = tags.get(k)
        if v and v.strip():
            return v.strip()
    return None


def _website(tags) -> str | None:
    url = _first(tags, "website", "contact:website", "url")
    if not url:
        return None
    url = url.split(";")[0].strip()
    if not url.lower().startswith(("http://", "https://")):
        url = "https://" + url
    return url


def _insurance(tags) -> tuple[int | None, int | None]:
    """Kassen-/Privatstatus aus `insurance:health` (in DE z. B. „public“,
    „private“, „public;private“, „no“). Fehlt der Tag: unbekannt (NULL)."""
    raw = (tags.get("insurance:health") or "").lower()
    if not raw:
        return None, None
    vals = {v.strip() for v in raw.split(";")}
    if vals & {"no", "none"}:
        return 0, 0
    pub = 1 if vals & {"public", "statutory", "yes"} else 0
    priv = 1 if vals & {"private", "yes"} else 0
    if not (pub or priv):
        return None, None
    return pub, priv


def _centroid(obj) -> tuple[float, float] | None:
    if obj.is_node():
        loc = obj.location
        return (loc.lat, loc.lon) if loc.valid() else None
    pts = [(n.lat, n.lon) for n in obj.nodes if n.location.valid()]
    if len(pts) > 1 and pts[0] == pts[-1]:
        pts = pts[:-1]  # geschlossener Weg: Endpunkt nicht doppelt zählen
    if not pts:
        return None
    return sum(p[0] for p in pts) / len(pts), sum(p[1] for p in pts) / len(pts)


class _Acc:
    """Laufender Mittelwert von Koordinaten plus häufigste Schreibweise."""

    __slots__ = ("lat", "lon", "n", "names")

    def __init__(self) -> None:
        self.lat = self.lon = 0.0
        self.n = 0
        self.names: dict[str, int] = {}

    def add(self, lat: float, lon: float, name: str | None) -> None:
        self.lat += lat
        self.lon += lon
        self.n += 1
        if name:
            self.names[name] = self.names.get(name, 0) + 1

    def best_name(self) -> str | None:
        return max(self.names, key=self.names.get) if self.names else None


def build(pbf: Path, out: Path, *, storage: str | None = None, optout: Path | None = None) -> dict:
    """Baut die Datenbank `out` aus `pbf`. Gibt Zählwerte zurück."""
    started = time.monotonic()
    excluded = load_optout(optout) if optout else set()
    tmp = out.with_name(out.name + ".building")
    tmp.unlink(missing_ok=True)
    con = db.create(tmp)

    streets: dict[tuple[str, str, str], _Acc] = defaultdict(_Acc)
    postcodes: dict[str, _Acc] = defaultdict(_Acc)
    cities: dict[str, _Acc] = defaultdict(_Acc)
    practices: list[tuple] = []
    skipped_optout = 0

    if storage is None:
        # Kleine Extrakte im Speicher, große (Deutschland ~4 GB) auf Platte.
        big = pbf.stat().st_size > 300 * 1024 * 1024
        storage = f"sparse_file_array,{out.with_name('nodes.cache')}" if big else "flex_mem"

    fp = (
        osmium.FileProcessor(str(pbf), osmium.osm.NODE | osmium.osm.WAY)
        .with_locations(storage)
        .with_filter(osmium.filter.EmptyTagFilter())
        .with_filter(osmium.filter.KeyFilter("addr:housenumber", "amenity", "healthcare"))
    )
    data_ts = fp.header.get("osmosis_replication_timestamp") or ""

    for obj in fp:
        tags = obj.tags
        kind = _kind(tags)
        hn = tags.get("addr:housenumber")
        if not kind and not hn:
            continue
        c = _centroid(obj)
        if c is None:
            continue
        lat, lon = c
        pc = tags.get("addr:postcode")
        city = tags.get("addr:city")
        street = tags.get("addr:street") or tags.get("addr:place")

        if hn and street:
            sk = norm_key(street)
            if sk:
                streets[(pc or "", city_key(city), sk)].add(lat, lon, street)
        if hn and pc and len(pc) == 5 and pc.isdigit():
            postcodes[pc].add(lat, lon, city)
        if hn and city:
            cities[city_key(city)].add(lat, lon, city)

        if kind:
            name = _first(tags, "name", "official_name", "operator")
            if not name:
                continue
            otype = "node" if obj.is_node() else "way"
            if f"{otype}/{obj.id}" in excluded:
                skipped_optout += 1
                continue
            pub, priv = _insurance(tags)
            practices.append((
                otype, obj.id, name, kind, ";".join(parse_specialties(tags)),
                tags.get("addr:street"), hn, pc, city,
                _first(tags, "phone", "contact:phone"),
                _website(tags),
                _first(tags, "email", "contact:email"),
                tags.get("opening_hours"), tags.get("wheelchair"),
                pub, priv, lat, lon,
            ))

    log.info("gelesen: %d Praxen, %d Straßen, %d PLZ", len(practices), len(streets), len(postcodes))

    with con:
        con.executemany(
            """INSERT OR IGNORE INTO practices (osm_type, osm_id, name, kind, specialties,
               street, housenumber, postcode, city, phone, website, email,
               opening_hours, wheelchair, insurance_public, insurance_private, lat, lon)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            practices,
        )
        con.execute(
            "INSERT INTO practices_geo SELECT id, lat, lat, lon, lon FROM practices"
        )
        con.execute(
            "INSERT INTO practices_fts (rowid, name, specialties) "
            "SELECT id, name, replace(specialties, ';', ' ') FROM practices"
        )
        con.executemany(
            "INSERT INTO streets VALUES (?,?,?,?,?,?,?,?)",
            (
                (pc or None, ck or None, sk, a.best_name() or sk, None,
                 a.lat / a.n, a.lon / a.n, a.n)
                for (pc, ck, sk), a in streets.items()
            ),
        )
        con.executemany(
            "INSERT INTO postcodes VALUES (?,?,?,?,?)",
            ((pc, a.best_name(), a.lat / a.n, a.lon / a.n, a.n) for pc, a in postcodes.items()),
        )
        con.executemany(
            "INSERT INTO cities VALUES (?,?,?,?,?)",
            ((ck, a.best_name() or ck, a.lat / a.n, a.lon / a.n, a.n)
             for ck, a in cities.items() if ck),
        )
        # Ortsname zur Straße (für die Anzeige des gefundenen Mittelpunkts)
        con.execute(
            "UPDATE streets SET city = (SELECT city FROM cities c WHERE c.city_key = streets.city_key)"
        )
        count = con.execute("SELECT count(*) FROM practices").fetchone()[0]
        meta = {
            "schema_version": str(db.SCHEMA_VERSION),
            "data_timestamp": data_ts,
            "imported_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "source": pbf.name,
            "practices": str(count),
            "postcodes": str(len(postcodes)),
        }
        con.executemany("INSERT INTO meta VALUES (?,?)", meta.items())
    con.execute("ANALYZE")
    con.execute("VACUUM")
    con.close()

    if count == 0:
        tmp.unlink(missing_ok=True)
        raise RuntimeError("Import ergab keine Praxen – alte Datenbank bleibt bestehen.")
    os.replace(tmp, out)  # atomar: laufende API liest sofort die neue Datei
    cache = out.with_name("nodes.cache")
    cache.unlink(missing_ok=True)
    log.info("fertig in %.0f s: %d Praxen (%d per Opt-out ausgelassen)",
             time.monotonic() - started, count, skipped_optout)
    return {"practices": count, "postcodes": len(postcodes), "streets": len(streets),
            "optout_skipped": skipped_optout}


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--pbf", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--optout", type=Path, default=None, help="Liste ausgeschlossener Einträge (node/123)")
    ap.add_argument("--storage", default=None, help="osmium-Location-Index, z. B. flex_mem")
    args = ap.parse_args(argv)
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")
    try:
        build(args.pbf, args.out, storage=args.storage, optout=args.optout)
    except Exception as e:  # noqa: BLE001
        log.error("Import fehlgeschlagen: %s", e)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
