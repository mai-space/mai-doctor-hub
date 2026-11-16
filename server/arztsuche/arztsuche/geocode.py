"""Ort einer Suche bestimmen – ausschließlich aus der eigenen Datenbank.

Es wird kein externer Geocoder (Nominatim, Google …) gefragt: Die eingegebene
Adresse eines Nutzers verlässt den Server nie."""

from __future__ import annotations

import sqlite3
from dataclasses import dataclass

from .text import city_key, norm_key, parse_address


@dataclass(frozen=True)
class Center:
    lat: float
    lon: float
    precision: str  # street | postcode | city | coordinates
    label: str


def _weighted(rows: list[sqlite3.Row]) -> tuple[float, float] | None:
    n = sum(r["n"] for r in rows)
    if not n:
        return None
    return (sum(r["lat"] * r["n"] for r in rows) / n, sum(r["lon"] * r["n"] for r in rows) / n)


def by_postcode(con: sqlite3.Connection, plz: str) -> Center | None:
    r = con.execute("SELECT * FROM postcodes WHERE postcode = ?", (plz,)).fetchone()
    if not r:
        return None
    return Center(r["lat"], r["lon"], "postcode", f"{plz} {r['city'] or ''}".strip())


def by_address(con: sqlite3.Connection, raw: str) -> Center | None:
    a = parse_address(raw)
    sk = norm_key(a.street) if a.street else ""
    ck = city_key(a.city) if a.city else ""
    if sk:
        rows: list[sqlite3.Row] = []
        if a.postcode:
            rows = con.execute(
                "SELECT * FROM streets WHERE street_key = ? AND postcode = ?", (sk, a.postcode)
            ).fetchall()
        if not rows and ck:
            rows = con.execute(
                "SELECT * FROM streets WHERE street_key = ? AND city_key = ?", (sk, ck)
            ).fetchall()
        if rows:
            # Gleiche Straße in mehreren PLZ-Gebieten: Mittelpunkt aller Teile
            lat, lon = _weighted(rows)  # type: ignore[misc]
            city = rows[0]["city"] or a.city or ""
            pc = a.postcode or (rows[0]["postcode"] if len(rows) == 1 else "")
            return Center(lat, lon, "street", f"{rows[0]['street']}, {pc or ''} {city}".replace("  ", " ").strip(" ,"))
    if a.postcode:
        c = by_postcode(con, a.postcode)
        if c:
            return c
    if ck:
        r = con.execute("SELECT * FROM cities WHERE city_key = ?", (ck,)).fetchone()
        if r:
            return Center(r["lat"], r["lon"], "city", r["city"])
    return None
