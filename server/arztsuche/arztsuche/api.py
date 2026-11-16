"""HTTP-API (FastAPI). Alle Routen liegen unter /api, damit der
Reverse-Proxy den Pfad unverändert durchreichen kann.

Datenschutz: keine Zugriffsprotokolle, keine Cookies, keine Kennungen.
Suchanfragen werden nicht gespeichert.

Start: `uvicorn arztsuche.api:create_app --factory`"""

from __future__ import annotations

import math
import os
import sqlite3
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator, Literal

from fastapi import Depends, FastAPI, Header, HTTPException, Query, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from . import __version__, community, db, geocode
from .optout import OptOut
from .specialties import SPECIALTIES, label
from .text import norm_key

ATTRIBUTION = "© OpenStreetMap-Mitwirkende, Daten unter ODbL 1.0 – https://www.openstreetmap.org/copyright"
MAX_RADIUS_KM = 50.0


class Settings:
    def __init__(self) -> None:
        data = Path(os.environ.get("ARZTSUCHE_DATA", "/data"))
        self.db_path = Path(os.environ.get("ARZTSUCHE_DB", data / "arztsuche.sqlite"))
        self.optout_path = Path(os.environ.get("ARZTSUCHE_OPTOUT", data / "optout.txt"))
        self.cors_origins = [o for o in os.environ.get("ARZTSUCHE_CORS", "").split(",") if o]
        self.docs = os.environ.get("ARZTSUCHE_DOCS", "1") == "1"
        # Nutzerbeiträge (Konten, Bewertungen, neue Praxen); 0 schaltet sie ab
        self.community = os.environ.get("ARZTSUCHE_COMMUNITY", "1") == "1"
        self.community_db = Path(os.environ.get("ARZTSUCHE_COMMUNITY_DB", data / "community.sqlite"))
        self.pow_difficulty = int(os.environ.get("ARZTSUCHE_POW_BITS", "20"))
        self.writes_per_hour = int(os.environ.get("ARZTSUCHE_WRITES_PER_HOUR", "30"))


# ---------- Antwortmodelle (Feldnamen nur ergänzen, nie umbenennen) ----------

class Address(BaseModel):
    street: str | None
    housenumber: str | None
    postcode: str | None
    city: str | None


class Specialty(BaseModel):
    key: str
    de: str
    en: str


class Insurance(BaseModel):
    # None = unbekannt. Quelle: OSM-Tag insurance:health
    public: bool | None
    private: bool | None


class Source(BaseModel):
    kind: Literal["osm", "community"]
    osm: str | None  # z. B. node/123
    url: str | None  # Link zum Korrigieren auf openstreetmap.org


class Rating(BaseModel):
    average: float
    count: int


class Practice(BaseModel):
    id: str
    name: str
    kind: Literal["doctor", "dentist", "psychotherapist"]
    specialties: list[Specialty]
    address: Address
    phone: str | None
    website: str | None
    email: str | None
    opening_hours: str | None
    wheelchair: str | None
    insurance: Insurance
    lat: float
    lon: float
    distance_km: float | None = None
    rating: Rating | None = None  # nur aus Bewertungen in dieser App
    source: Source


class Center(BaseModel):
    lat: float
    lon: float
    precision: str
    label: str


class SearchResult(BaseModel):
    center: Center
    radius_km: float
    total: int
    items: list[Practice]
    attribution: str = ATTRIBUTION


# ---------- Hilfsfunktionen ----------

def _haversine_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    r = 6371.0088
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp, dl = p2 - p1, math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * r * math.asin(math.sqrt(a))


def _bool(v: int | None) -> bool | None:
    return None if v is None else bool(v)


def _pid(row: sqlite3.Row) -> str:
    """Öffentliche ID: node-123 / way-456 (OSM) oder user-7 (Nutzerbeitrag)."""
    if "osm_type" in row.keys():
        return f"{row['osm_type']}-{row['osm_id']}"
    return f"user-{row['id']}"


def _practice(row: sqlite3.Row, distance: float | None = None,
              rating: tuple[float, int] | None = None) -> Practice:
    keys = [k for k in row["specialties"].split(";") if k]
    pid = _pid(row)
    is_osm = not pid.startswith("user-")
    osm = pid.replace("-", "/") if is_osm else None
    cols = row.keys()

    def get(k: str):
        return row[k] if k in cols else None
    return Practice(
        id=pid,
        name=row["name"],
        kind=row["kind"],
        specialties=[Specialty(key=k, de=label(k, "de"), en=label(k, "en")) for k in keys],
        address=Address(street=row["street"], housenumber=row["housenumber"],
                        postcode=row["postcode"], city=row["city"]),
        phone=row["phone"], website=row["website"], email=get("email"),
        opening_hours=get("opening_hours"), wheelchair=get("wheelchair"),
        insurance=Insurance(public=_bool(row["insurance_public"]), private=_bool(row["insurance_private"])),
        lat=round(row["lat"], 6), lon=round(row["lon"], 6),
        distance_km=None if distance is None else round(distance, 2),
        rating=Rating(average=rating[0], count=rating[1]) if rating else None,
        source=Source(kind="osm" if is_osm else "community", osm=osm,
                      url=f"https://www.openstreetmap.org/{osm}" if osm else None),
    )


def _fts_query(q: str) -> str | None:
    # Jedes Wort als Präfix; Sonderzeichen entfernen (keine FTS-Syntax von außen)
    words = ["".join(ch for ch in w if ch.isalnum()) for w in q.split()]
    words = [w for w in words if w]
    return " ".join(f'"{w}"*' for w in words[:8]) or None


# ---------- Modelle für Nutzerbeiträge ----------

class ChallengeOut(BaseModel):
    challenge: str
    difficulty: int = Field(description="Benötigte führende Null-Bits von sha256(challenge + ':' + solution)")
    expires: int


class AccountIn(BaseModel):
    challenge: str = Field(max_length=200)
    solution: str = Field(max_length=20)


class AccountOut(BaseModel):
    token: str = Field(description="Nur jetzt sichtbar. Auf dem Gerät verschlüsselt speichern.")


class ReviewIn(BaseModel):
    rating: int = Field(ge=1, le=5)
    text: str | None = Field(None, max_length=2000)


class ReviewOut(BaseModel):
    id: int
    rating: int
    text: str | None
    month: str  # nur Monat (datensparsam), z. B. 2026-11
    edited: bool


class ReviewPage(BaseModel):
    practice_id: str
    rating: Rating | None
    total: int
    items: list[ReviewOut]
    notice: str = ("Subjektive Erfahrungen von Nutzern der App. Keine Tatsachenbehauptung "
                   "des Betreibers; Meldung über /api/v1/reports.")


class ReportIn(BaseModel):
    review_id: int | None = None
    practice_id: str | None = Field(None, max_length=40)
    reason: Literal["false_facts", "insult", "not_a_patient", "privacy", "spam", "wrong_data", "other"]
    message: str | None = Field(None, max_length=1000)


class PracticeIn(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    kind: Literal["doctor", "dentist", "psychotherapist"] = "doctor"
    specialties: list[str] = Field(default_factory=list, max_length=5)
    street: str = Field(min_length=2, max_length=120)
    housenumber: str = Field(min_length=1, max_length=10)
    postcode: str = Field(pattern=r"^\d{5}$")
    city: str = Field(min_length=2, max_length=80)
    phone: str | None = Field(None, max_length=40, pattern=r"^[+0-9 ()/-]{4,40}$")
    website: str | None = Field(None, max_length=200, pattern=r"^https://[^\s]+$")
    insurance_public: bool | None = None
    insurance_private: bool | None = None
    lat: float | None = Field(None, ge=47.0, le=55.5)
    lon: float | None = Field(None, ge=5.5, le=15.5)


class Submitted(BaseModel):
    id: str
    status: str
    message: str


def _month(ts: int) -> str:
    from datetime import datetime, timezone
    return datetime.fromtimestamp(ts, timezone.utc).strftime("%Y-%m")


def create_app(settings: Settings | None = None) -> FastAPI:
    s = settings or Settings()
    optout = OptOut(s.optout_path)
    comm = community.Community(s.community_db) if s.community else None
    pow_gate = community.PowGate(comm.secret(), s.pow_difficulty) if comm else None
    limiter = community.RateLimiter(s.writes_per_hour)
    app = FastAPI(
        title="Mai Doctor Hub – Arztsuche",
        version=__version__,
        docs_url="/api/docs" if s.docs else None,
        redoc_url=None,
        openapi_url="/api/openapi.json" if s.docs else None,
    )
    if s.cors_origins:
        app.add_middleware(CORSMiddleware, allow_origins=s.cors_origins,
                           allow_methods=["GET", "POST", "PUT", "DELETE"],
                           allow_headers=["Authorization", "Content-Type"])

    @app.middleware("http")
    async def _headers(request: Request, call_next):
        resp = await call_next(request)
        resp.headers.setdefault("Cache-Control", "no-store")
        resp.headers["X-Content-Type-Options"] = "nosniff"
        resp.headers["Referrer-Policy"] = "no-referrer"
        return resp

    @contextmanager
    def conn() -> Iterator[sqlite3.Connection]:
        if not s.db_path.exists():
            raise HTTPException(503, "Datenbank noch nicht importiert")
        # Pro Anfrage öffnen: nach einem Import wird so sofort die neue Datei gelesen
        con = db.open_readonly(s.db_path)
        try:
            yield con
        finally:
            con.close()

    def need_comm() -> community.Community:
        if comm is None:
            raise HTTPException(404, "Nutzerbeiträge sind auf diesem Server abgeschaltet")
        return comm

    def account(authorization: str | None = Header(None)) -> int:
        c = need_comm()
        if not authorization or not authorization.startswith("Bearer "):
            raise HTTPException(401, "Anmeldung nötig", headers={"WWW-Authenticate": "Bearer"})
        aid = c.account_for(authorization[7:].strip())
        if aid is None:
            raise HTTPException(401, "Unbekanntes Token", headers={"WWW-Authenticate": "Bearer"})
        return aid

    def writer(aid: int = Depends(account)) -> int:
        if not limiter.allow(aid):
            raise HTTPException(429, "Zu viele Änderungen – bitte später erneut versuchen")
        return aid

    def find_practice(pid: str) -> sqlite3.Row | None:
        """OSM-Praxis oder freigegebene Nutzer-Praxis; Opt-out beachtet."""
        kind, _, num = pid.partition("-")
        if not num.isdigit():
            return None
        if kind in ("node", "way"):
            if f"{kind}/{num}" in optout.ids():
                return None
            with conn() as con:
                return con.execute("SELECT * FROM practices WHERE osm_type = ? AND osm_id = ?",
                                   (kind, int(num))).fetchone()
        if kind == "user" and comm is not None:
            return comm.approved(int(num))
        return None

    def ratings_for(ids: list[str]) -> dict[str, tuple[float, int]]:
        return comm.ratings(ids) if comm else {}

    # ---------- Suche ----------

    @app.get("/api/health")
    def health():
        ok = s.db_path.exists()
        return JSONResponse({"status": "ok" if ok else "no-data"}, status_code=200 if ok else 503)

    @app.get("/api/v1/meta")
    def meta():
        with conn() as con:
            m = dict(con.execute("SELECT key, value FROM meta").fetchall())
        return {"api_version": __version__, **m, "community": comm is not None, "attribution": ATTRIBUTION}

    @app.get("/api/v1/specialties", response_model=list[Specialty])
    def specialties():
        return [Specialty(key=k, de=v[0], en=v[1]) for k, v in SPECIALTIES.items()]

    @app.get("/api/v1/doctors", response_model=SearchResult)
    def search(
        plz: str | None = Query(None, pattern=r"^\d{5}$", description="Postleitzahl"),
        address: str | None = Query(None, min_length=2, max_length=200,
                                    description="Freie Adresse, z. B. „Hauptstr. 5, 10115 Berlin“"),
        lat: float | None = Query(None, ge=47.0, le=55.5),
        lon: float | None = Query(None, ge=5.5, le=15.5),
        radius_km: float = Query(5.0, gt=0, le=MAX_RADIUS_KM),
        specialty: str | None = Query(None, max_length=40, description="OSM-Schlüssel, siehe /specialties"),
        kind: Literal["doctor", "dentist", "psychotherapist"] | None = None,
        q: str | None = Query(None, max_length=80, description="Name der Praxis/des Arztes"),
        insurance: Literal["public", "private"] | None = Query(
            None, description="Nur Praxen, die diese Versicherung ausdrücklich annehmen"),
        limit: int = Query(20, ge=1, le=100),
        offset: int = Query(0, ge=0, le=1000),
    ):
        with conn() as con:
            if lat is not None and lon is not None:
                center = geocode.Center(lat, lon, "coordinates", f"{lat:.4f}, {lon:.4f}")
            elif plz:
                center = geocode.by_postcode(con, plz)
            elif address:
                center = geocode.by_address(con, address)
            else:
                raise HTTPException(422, "plz, address oder lat/lon angeben")
            if center is None:
                raise HTTPException(404, "Ort nicht gefunden")

            dlat = radius_km / 111.32
            dlon = radius_km / (111.32 * max(math.cos(math.radians(center.lat)), 0.01))
            box = (center.lat - dlat, center.lat + dlat, center.lon - dlon, center.lon + dlon)
            sql = ["SELECT p.* FROM practices_geo g JOIN practices p ON p.id = g.id",
                   "WHERE g.min_lat >= ? AND g.max_lat <= ? AND g.min_lon >= ? AND g.max_lon <= ?"]
            args: list = list(box)
            if specialty:
                sql.append("AND (';' || p.specialties || ';') LIKE ?")
                args.append(f"%;{specialty.lower()};%")
            if kind:
                sql.append("AND p.kind = ?")
                args.append(kind)
            if insurance == "public":
                sql.append("AND p.insurance_public = 1")
            elif insurance == "private":
                sql.append("AND p.insurance_private = 1")
            fts = _fts_query(q) if q else None
            if fts:
                sql.append("AND p.id IN (SELECT rowid FROM practices_fts WHERE practices_fts MATCH ?)")
                args.append(fts)
            rows = list(con.execute(" ".join(sql), args).fetchall())

        # Freigegebene Praxen aus der App (wenige – Filter direkt in Python)
        if comm is not None:
            words = [norm_key(w) for w in (q or "").split() if norm_key(w)]
            for r in comm.approved_near(*box):
                if specialty and specialty.lower() not in r["specialties"].split(";"):
                    continue
                if kind and r["kind"] != kind:
                    continue
                if insurance and r[f"insurance_{insurance}"] != 1:
                    continue
                if words and not all(w in norm_key(r["name"]) for w in words):
                    continue
                rows.append(r)

        hidden = optout.ids()
        hits = []
        for r in rows:
            if hidden and _pid(r).replace("-", "/") in hidden:
                continue
            d = _haversine_km(center.lat, center.lon, r["lat"], r["lon"])
            if d <= radius_km:
                hits.append((d, r["name"], r))
        hits.sort(key=lambda h: (h[0], h[1]))
        page = hits[offset: offset + limit]
        rated = ratings_for([_pid(r) for _, _, r in page])
        return SearchResult(
            center=Center(lat=round(center.lat, 5), lon=round(center.lon, 5),
                          precision=center.precision, label=center.label),
            radius_km=radius_km,
            total=len(hits),
            items=[_practice(r, d, rated.get(_pid(r))) for d, _, r in page],
        )

    @app.get("/api/v1/doctors/{practice_id}", response_model=Practice)
    def detail(practice_id: str):
        r = find_practice(practice_id)
        if not r:
            raise HTTPException(404, "Unbekannte ID")
        return _practice(r, rating=ratings_for([practice_id]).get(practice_id))

    # ---------- Nutzerbeiträge (nur mit Konto, nur wenn der Nutzer will) ----------

    @app.get("/api/v1/accounts/challenge", response_model=ChallengeOut)
    def challenge():
        need_comm()
        c = pow_gate.issue()  # type: ignore[union-attr]
        return ChallengeOut(challenge=c.challenge, difficulty=c.difficulty, expires=c.expires)

    @app.post("/api/v1/accounts", response_model=AccountOut, status_code=201)
    def create_account(body: AccountIn):
        c = need_comm()
        if not pow_gate.verify(body.challenge, body.solution):  # type: ignore[union-attr]
            raise HTTPException(400, "Aufgabe ungültig, abgelaufen oder schon benutzt")
        _, token = c.create_account()
        return AccountOut(token=token)

    @app.get("/api/v1/me")
    def my_data(aid: int = Depends(account)):
        """Auskunft/Export (Art. 15, 20 DSGVO): alles, was zu diesem Konto gespeichert ist."""
        return need_comm().export(aid)

    @app.delete("/api/v1/me", status_code=204)
    def delete_me(aid: int = Depends(account)):
        """Konto mit allen Bewertungen und offenen Praxis-Vorschlägen löschen."""
        need_comm().delete_account(aid)
        return Response(status_code=204)

    @app.get("/api/v1/doctors/{practice_id}/reviews", response_model=ReviewPage)
    def list_reviews(practice_id: str, limit: int = Query(20, ge=1, le=50), offset: int = Query(0, ge=0)):
        if not find_practice(practice_id):
            raise HTTPException(404, "Unbekannte ID")
        items, total = need_comm().reviews(practice_id, limit, offset)
        rated = ratings_for([practice_id]).get(practice_id)
        return ReviewPage(
            practice_id=practice_id,
            rating=Rating(average=rated[0], count=rated[1]) if rated else None,
            total=total,
            items=[ReviewOut(id=r["id"], rating=r["rating"], text=r["text"], month=_month(r["created_at"]),
                             edited=r["updated_at"] != r["created_at"]) for r in items],
        )

    @app.put("/api/v1/doctors/{practice_id}/review")
    def put_review(practice_id: str, body: ReviewIn, aid: int = Depends(writer)):
        """Eigene Bewertung anlegen oder ändern (eine je Konto und Praxis)."""
        if not find_practice(practice_id):
            raise HTTPException(404, "Unbekannte ID")
        try:
            text = community.clean_text(body.text, 2000)
        except community.ContentError as e:
            raise HTTPException(422, str(e)) from e
        r = need_comm().upsert_review(aid, practice_id, body.rating, text)
        return {"id": r["id"], "rating": r["rating"], "text": r["text"], "status": r["status"]}

    @app.delete("/api/v1/doctors/{practice_id}/review", status_code=204)
    def delete_review(practice_id: str, aid: int = Depends(account)):
        if not need_comm().delete_review(aid, practice_id):
            raise HTTPException(404, "Keine eigene Bewertung vorhanden")
        return Response(status_code=204)

    @app.post("/api/v1/reports", status_code=202)
    def report(body: ReportIn, aid: int = Depends(writer)):
        """Bewertung oder Praxisdaten melden (Notice-and-Action, Art. 16 DSA)."""
        if body.review_id is None and not body.practice_id:
            raise HTTPException(422, "review_id oder practice_id angeben")
        try:
            msg = community.clean_text(body.message, 1000) if body.message else None
        except community.ContentError:
            msg = (body.message or "")[:1000]  # Meldungen dürfen Links enthalten (Belege)
        if not need_comm().report(aid, body.review_id, body.practice_id, body.reason, msg):
            raise HTTPException(404, "Bewertung nicht gefunden")
        return {"status": "received"}

    @app.post("/api/v1/practices", response_model=Submitted, status_code=202)
    def submit_practice(body: PracticeIn, aid: int = Depends(writer)):
        """Neue Praxis vorschlagen. Erscheint erst nach Prüfung in der Suche."""
        if body.lat is not None and body.lon is not None:
            lat, lon = body.lat, body.lon
        else:
            with conn() as con:
                c = geocode.by_address(con, f"{body.street} {body.housenumber}, {body.postcode} {body.city}")
            if c is None or c.precision not in ("street", "postcode"):
                raise HTTPException(422, "Adresse nicht gefunden – bitte lat/lon mitsenden")
            lat, lon = c.lat, c.lon
        specs = [k.strip().lower() for k in body.specialties if k.strip()][:5]
        sid = need_comm().submit_practice(aid, {
            "name": body.name.strip(), "kind": body.kind, "specialties": ";".join(specs),
            "street": body.street.strip(), "housenumber": body.housenumber.strip(),
            "postcode": body.postcode, "city": body.city.strip(),
            "phone": body.phone, "website": body.website,
            "insurance_public": None if body.insurance_public is None else int(body.insurance_public),
            "insurance_private": None if body.insurance_private is None else int(body.insurance_private),
            "lat": lat, "lon": lon,
        })
        return Submitted(id=f"user-{sid}", status="pending", message="Danke! Wird nach Prüfung sichtbar.")

    return app

