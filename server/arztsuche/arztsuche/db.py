"""SQLite-Schema der Arztsuche. Die Datei wird vom Import komplett neu
gebaut und atomar ersetzt; die API öffnet sie nur lesend."""

from __future__ import annotations

import sqlite3
from pathlib import Path

# Bei inkompatiblen Änderungen erhöhen; die API meldet die Version in /meta.
SCHEMA_VERSION = 1

SCHEMA = """
CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT NOT NULL);

CREATE TABLE practices (
  id INTEGER PRIMARY KEY,
  osm_type TEXT NOT NULL,          -- node | way
  osm_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  kind TEXT NOT NULL,              -- doctor | dentist | psychotherapist
  specialties TEXT NOT NULL,       -- OSM-Werte, durch ';' getrennt
  street TEXT, housenumber TEXT, postcode TEXT, city TEXT,
  phone TEXT, website TEXT, email TEXT,
  opening_hours TEXT, wheelchair TEXT,
  insurance_public INTEGER,        -- 1/0/NULL (NULL = unbekannt)
  insurance_private INTEGER,
  lat REAL NOT NULL, lon REAL NOT NULL,
  UNIQUE (osm_type, osm_id)
);
CREATE INDEX practices_postcode ON practices (postcode);

CREATE VIRTUAL TABLE practices_geo USING rtree (
  id, min_lat, max_lat, min_lon, max_lon
);

CREATE VIRTUAL TABLE practices_fts USING fts5 (
  name, specialties, content='', tokenize='unicode61 remove_diacritics 2'
);

-- Geocoder aus OSM-Hausadressen: Mittelpunkt je Straße (pro PLZ/Ort)
CREATE TABLE streets (
  postcode TEXT, city_key TEXT, street_key TEXT NOT NULL,
  street TEXT NOT NULL, city TEXT,
  lat REAL NOT NULL, lon REAL NOT NULL, n INTEGER NOT NULL
);
CREATE INDEX streets_pc ON streets (street_key, postcode);
CREATE INDEX streets_city ON streets (street_key, city_key);

CREATE TABLE postcodes (
  postcode TEXT PRIMARY KEY, city TEXT,
  lat REAL NOT NULL, lon REAL NOT NULL, n INTEGER NOT NULL
);

CREATE TABLE cities (
  city_key TEXT PRIMARY KEY, city TEXT NOT NULL,
  lat REAL NOT NULL, lon REAL NOT NULL, n INTEGER NOT NULL
);
"""


def create(path: Path) -> sqlite3.Connection:
    con = sqlite3.connect(path)
    con.execute("PRAGMA journal_mode=OFF")
    con.execute("PRAGMA synchronous=OFF")
    con.executescript(SCHEMA)
    return con


def open_readonly(path: Path) -> sqlite3.Connection:
    con = sqlite3.connect(f"file:{path}?mode=ro", uri=True, check_same_thread=False)
    con.row_factory = sqlite3.Row
    return con
