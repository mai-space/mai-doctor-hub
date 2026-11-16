"""Beiträge von Nutzern: pseudonyme Konten, Bewertungen, neue Praxen.

Liegt in einer eigenen, beschreibbaren Datei (`community.sqlite`), damit ein
OSM-Import sie nie überschreibt. Grundsätze:

- Konten ohne E-Mail, Name oder Telefonnummer. Der Server kennt nur den
  SHA-256-Hash eines zufälligen Tokens, das die App einmalig erhält.
- Keine IP-Adressen, keine Geräte-IDs. Missbrauchsschutz über
  Proof-of-Work beim Anlegen eines Kontos und Schreiblimits je Konto.
- Alles, was ein Konto beigetragen hat, lässt sich exportieren und mit dem
  Konto löschen (Art. 15, 17, 20 DSGVO).
- Neue Praxen erscheinen erst nach Freigabe; Bewertungen sofort, werden aber
  nach Meldungen automatisch ausgeblendet, bis jemand sie prüft.
"""

from __future__ import annotations

import hashlib
import hmac
import re
import secrets
import sqlite3
import threading
import time
from collections import deque
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
from typing import Iterator

SCHEMA = """
CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY,
  token_hash TEXT NOT NULL UNIQUE,
  created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS reviews (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  practice_id TEXT NOT NULL,           -- node-123 | way-456 | user-7
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  text TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'visible',  -- visible | hidden | removed
  UNIQUE (account_id, practice_id)
);
CREATE INDEX IF NOT EXISTS reviews_practice ON reviews (practice_id, status);
CREATE TABLE IF NOT EXISTS reports (
  id INTEGER PRIMARY KEY,
  account_id INTEGER REFERENCES accounts(id) ON DELETE SET NULL,
  review_id INTEGER REFERENCES reviews(id) ON DELETE CASCADE,
  practice_id TEXT,
  reason TEXT NOT NULL,
  message TEXT,
  created_at INTEGER NOT NULL,
  resolved INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS submitted_practices (
  id INTEGER PRIMARY KEY,
  account_id INTEGER REFERENCES accounts(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  kind TEXT NOT NULL,
  specialties TEXT NOT NULL,
  street TEXT, housenumber TEXT, postcode TEXT, city TEXT,
  phone TEXT, website TEXT,
  insurance_public INTEGER, insurance_private INTEGER,
  lat REAL NOT NULL, lon REAL NOT NULL,
  created_at INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending'   -- pending | approved | rejected
);
CREATE INDEX IF NOT EXISTS submitted_geo ON submitted_practices (status, lat, lon);
CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);
"""

# Gemeldete Bewertungen werden ab so vielen Meldungen verschiedener Konten
# ausgeblendet, bis die Moderation entscheidet.
AUTO_HIDE_REPORTS = 3
_LINK = re.compile(r"(https?://|www\.|\b[\w-]+\.(de|com|net|org|info|io)\b)", re.I)
_CTRL = re.compile(r"[\x00-\x08\x0b-\x1f\x7f]")


class ContentError(ValueError):
    """Eingabe abgelehnt (Text für den Nutzer)."""


def clean_text(text: str | None, max_len: int) -> str | None:
    if text is None:
        return None
    t = _CTRL.sub("", text).strip()
    if not t:
        return None
    if len(t) > max_len:
        raise ContentError(f"Text zu lang (höchstens {max_len} Zeichen)")
    if _LINK.search(t):
        raise ContentError("Links sind in Bewertungen nicht erlaubt")
    return t


def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()


# ---------- Proof-of-Work (zustandslos, HMAC-signiert) ----------

@dataclass(frozen=True)
class Challenge:
    challenge: str
    difficulty: int
    expires: int


class PowGate:
    """Ein Konto kostet ein paar Sekunden Rechenzeit auf dem Handy – für
    Menschen unbemerkt, für Massen-Konten teuer. Kein Captcha-Dienst nötig."""

    def __init__(self, secret: bytes, difficulty: int, ttl: int = 600) -> None:
        self.secret, self.difficulty, self.ttl = secret, difficulty, ttl
        self._used: dict[str, int] = {}
        self._lock = threading.Lock()

    def issue(self) -> Challenge:
        exp = int(time.time()) + self.ttl
        nonce = secrets.token_hex(12)
        body = f"{nonce}.{exp}.{self.difficulty}"
        sig = hmac.new(self.secret, body.encode(), hashlib.sha256).hexdigest()[:32]
        return Challenge(f"{body}.{sig}", self.difficulty, exp)

    @staticmethod
    def leading_zero_bits(digest: bytes) -> int:
        bits = 0
        for b in digest:
            if b == 0:
                bits += 8
                continue
            return bits + (8 - b.bit_length())
        return bits

    @staticmethod
    def solve(challenge: str, difficulty: int) -> str:
        """Referenzlösung (für Tests/Clients): sha256(challenge + ":" + n)."""
        n = 0
        while True:
            d = hashlib.sha256(f"{challenge}:{n}".encode()).digest()
            if PowGate.leading_zero_bits(d) >= difficulty:
                return str(n)
            n += 1

    def verify(self, challenge: str, solution: str) -> bool:
        try:
            nonce, exp_s, diff_s, sig = challenge.split(".")
            exp, diff = int(exp_s), int(diff_s)
        except ValueError:
            return False
        body = f"{nonce}.{exp_s}.{diff_s}"
        good = hmac.new(self.secret, body.encode(), hashlib.sha256).hexdigest()[:32]
        now = int(time.time())
        if not hmac.compare_digest(sig, good) or exp < now or diff < self.difficulty:
            return False
        if len(solution) > 20:
            return False
        d = hashlib.sha256(f"{challenge}:{solution}".encode()).digest()
        if self.leading_zero_bits(d) < diff:
            return False
        with self._lock:  # jede Aufgabe nur einmal einlösbar
            self._used = {k: v for k, v in self._used.items() if v >= now}
            if nonce in self._used:
                return False
            self._used[nonce] = exp
        return True


# ---------- Schreiblimits je Konto (nur im Speicher) ----------

class RateLimiter:
    def __init__(self, per_hour: int) -> None:
        self.per_hour = per_hour
        self._hits: dict[int, deque[float]] = {}
        self._lock = threading.Lock()

    def allow(self, account_id: int) -> bool:
        now = time.monotonic()
        with self._lock:
            q = self._hits.setdefault(account_id, deque())
            while q and q[0] < now - 3600:
                q.popleft()
            if len(q) >= self.per_hour:
                return False
            q.append(now)
            return True


# ---------- Datenbank ----------

class Community:
    def __init__(self, path: Path) -> None:
        self.path = path
        path.parent.mkdir(parents=True, exist_ok=True)
        with self.connect() as con:
            con.executescript(SCHEMA)

    @contextmanager
    def connect(self) -> Iterator[sqlite3.Connection]:
        con = sqlite3.connect(self.path, timeout=10, isolation_level=None, check_same_thread=False)
        try:
            con.row_factory = sqlite3.Row
            con.execute("PRAGMA journal_mode=WAL")
            con.execute("PRAGMA foreign_keys=ON")
            yield con
        finally:
            con.close()

    def secret(self) -> bytes:
        """Server-Geheimnis für signierte PoW-Aufgaben (einmalig erzeugt)."""
        with self.connect() as con:
            r = con.execute("SELECT value FROM settings WHERE key='secret'").fetchone()
            if r:
                return bytes.fromhex(r["value"])
            val = secrets.token_hex(32)
            con.execute("INSERT OR IGNORE INTO settings VALUES ('secret', ?)", (val,))
            r = con.execute("SELECT value FROM settings WHERE key='secret'").fetchone()
            return bytes.fromhex(r["value"])

    # Konten
    def create_account(self) -> tuple[int, str]:
        token = "mdh_" + secrets.token_urlsafe(32)
        with self.connect() as con:
            cur = con.execute("INSERT INTO accounts (token_hash, created_at) VALUES (?, ?)",
                              (hash_token(token), int(time.time())))
            return cur.lastrowid, token

    def account_for(self, token: str) -> int | None:
        with self.connect() as con:
            r = con.execute("SELECT id FROM accounts WHERE token_hash = ?", (hash_token(token),)).fetchone()
            return r["id"] if r else None

    def delete_account(self, account_id: int) -> None:
        """Löscht Konto, Bewertungen und noch nicht freigegebene Praxen.
        Freigegebene Praxen bleiben als Sachinformation, aber ohne Kontobezug."""
        with self.connect() as con:
            con.execute("DELETE FROM submitted_practices WHERE account_id = ? AND status != 'approved'", (account_id,))
            con.execute("DELETE FROM accounts WHERE id = ?", (account_id,))

    def export(self, account_id: int) -> dict:
        with self.connect() as con:
            acc = con.execute("SELECT id, created_at FROM accounts WHERE id = ?", (account_id,)).fetchone()
            reviews = [dict(r) for r in con.execute(
                "SELECT id, practice_id, rating, text, created_at, updated_at, status FROM reviews WHERE account_id = ?",
                (account_id,))]
            practices = [dict(r) for r in con.execute(
                "SELECT * FROM submitted_practices WHERE account_id = ?", (account_id,))]
        for p in practices:
            p.pop("account_id", None)
        return {"account": dict(acc) if acc else None, "reviews": reviews, "practices": practices}

    # Bewertungen
    def upsert_review(self, account_id: int, practice_id: str, rating: int, text: str | None) -> dict:
        now = int(time.time())
        with self.connect() as con:
            con.execute(
                """INSERT INTO reviews (account_id, practice_id, rating, text, created_at, updated_at)
                   VALUES (?,?,?,?,?,?)
                   ON CONFLICT (account_id, practice_id) DO UPDATE SET
                     rating = excluded.rating, text = excluded.text, updated_at = excluded.updated_at,
                     status = reviews.status  -- ausgeblendete bleiben es bis zur Moderation""",
                (account_id, practice_id, rating, text, now, now))
            r = con.execute("SELECT * FROM reviews WHERE account_id = ? AND practice_id = ?",
                            (account_id, practice_id)).fetchone()
            return dict(r)

    def delete_review(self, account_id: int, practice_id: str) -> bool:
        with self.connect() as con:
            cur = con.execute("DELETE FROM reviews WHERE account_id = ? AND practice_id = ?",
                              (account_id, practice_id))
            return cur.rowcount > 0

    def reviews(self, practice_id: str, limit: int, offset: int) -> tuple[list[dict], int]:
        with self.connect() as con:
            total = con.execute("SELECT count(*) FROM reviews WHERE practice_id = ? AND status = 'visible'",
                                (practice_id,)).fetchone()[0]
            rows = con.execute(
                """SELECT id, rating, text, created_at, updated_at FROM reviews
                   WHERE practice_id = ? AND status = 'visible'
                   ORDER BY updated_at DESC LIMIT ? OFFSET ?""", (practice_id, limit, offset)).fetchall()
            return [dict(r) for r in rows], total

    def ratings(self, practice_ids: list[str]) -> dict[str, tuple[float, int]]:
        if not practice_ids:
            return {}
        with self.connect() as con:
            marks = ",".join("?" * len(practice_ids))
            rows = con.execute(
                f"""SELECT practice_id, avg(rating) AS a, count(*) AS n FROM reviews
                    WHERE status = 'visible' AND practice_id IN ({marks}) GROUP BY practice_id""",
                practice_ids).fetchall()
            return {r["practice_id"]: (round(r["a"], 2), r["n"]) for r in rows}

    def report(self, account_id: int, review_id: int | None, practice_id: str | None,
               reason: str, message: str | None) -> bool:
        with self.connect() as con:
            if review_id is not None:
                if not con.execute("SELECT 1 FROM reviews WHERE id = ?", (review_id,)).fetchone():
                    return False
            con.execute(
                "INSERT INTO reports (account_id, review_id, practice_id, reason, message, created_at) "
                "VALUES (?,?,?,?,?,?)", (account_id, review_id, practice_id, reason, message, int(time.time())))
            if review_id is not None:
                open_reports = con.execute(
                    "SELECT count(DISTINCT account_id) FROM reports WHERE review_id = ? AND resolved = 0",
                    (review_id,)).fetchone()[0]
                if open_reports >= AUTO_HIDE_REPORTS:
                    con.execute("UPDATE reviews SET status = 'hidden' WHERE id = ? AND status = 'visible'", (review_id,))
            return True

    # Neue Praxen
    def submit_practice(self, account_id: int, p: dict) -> int:
        with self.connect() as con:
            cur = con.execute(
                """INSERT INTO submitted_practices (account_id, name, kind, specialties, street, housenumber,
                   postcode, city, phone, website, insurance_public, insurance_private, lat, lon, created_at)
                   VALUES (:account_id,:name,:kind,:specialties,:street,:housenumber,:postcode,:city,:phone,
                           :website,:insurance_public,:insurance_private,:lat,:lon,:created_at)""",
                {**p, "account_id": account_id, "created_at": int(time.time())})
            return cur.lastrowid

    def approved_near(self, lat0: float, lat1: float, lon0: float, lon1: float) -> list[sqlite3.Row]:
        with self.connect() as con:
            return con.execute(
                """SELECT * FROM submitted_practices WHERE status = 'approved'
                   AND lat BETWEEN ? AND ? AND lon BETWEEN ? AND ?""", (lat0, lat1, lon0, lon1)).fetchall()

    def approved(self, sid: int) -> sqlite3.Row | None:
        with self.connect() as con:
            return con.execute("SELECT * FROM submitted_practices WHERE id = ? AND status = 'approved'",
                               (sid,)).fetchone()
