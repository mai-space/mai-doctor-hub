"""Normalisierung von Straßen-/Ortsnamen und Zerlegen freier Adresseingaben."""

from __future__ import annotations

import re
import unicodedata
from dataclasses import dataclass

_UMLAUTE = str.maketrans({"ä": "ae", "ö": "oe", "ü": "ue", "ß": "ss"})
_STR_SUFFIX = re.compile(r"(str|strasse|straße)\.?$")
_PLZ = re.compile(r"(?<!\d)(\d{5})(?!\d)")
_STRASSEN_ENDUNGEN = ("strasse", "weg", "platz", "allee", "gasse", "ring", "damm", "ufer", "chaussee", "markt")
_HAUSNUMMER = re.compile(r"\s+\d+\s*[a-zA-Z]?(\s*[-/]\s*\d+\s*[a-zA-Z]?)?$")


def norm_key(text: str | None) -> str:
    """Vergleichsschlüssel: klein, Umlaute ausgeschrieben, „Str.“ = „Straße“,
    nur Buchstaben/Ziffern. „Hauptstr.“ und „Haupt-Straße“ ergeben denselben
    Schlüssel."""
    if not text:
        return ""
    s = text.strip().lower().translate(_UMLAUTE)
    s = unicodedata.normalize("NFKD", s)
    s = "".join(ch for ch in s if not unicodedata.combining(ch))
    s = re.sub(r"[^a-z0-9]+", "", s)
    s = _STR_SUFFIX.sub("strasse", s)
    return s


def city_key(text: str | None) -> str:
    """Ortsschlüssel; Zusätze wie „Berlin-Mitte“ oder „Frankfurt am Main“
    bleiben erhalten, nur Schreibweise wird vereinheitlicht."""
    return norm_key(text)


@dataclass(frozen=True)
class ParsedAddress:
    postcode: str | None
    street: str | None
    city: str | None


def parse_address(raw: str) -> ParsedAddress:
    """Zerlegt z. B. „Hauptstr. 5, 10115 Berlin“, „10115“, „Berlin“ oder
    „Hauptstraße 5 Köln“. Bewusst einfach: genau genug für eine Umkreissuche."""
    text = " ".join(raw.replace(";", ",").split())
    postcode = None
    m = _PLZ.search(text)
    if m:
        postcode = m.group(1)
        text = (text[: m.start()] + " " + text[m.end():]).strip(" ,")
    parts = [p.strip() for p in text.split(",") if p.strip()]
    street = city = None
    if len(parts) >= 2:
        street, city = parts[0], parts[-1]
    elif len(parts) == 1:
        one = parts[0]
        # „Hauptstraße 5 Köln“ (ohne Komma): Hausnummer trennt Straße und Ort
        m2 = re.match(r"^(.*?\s\d+\s*[a-zA-Z]?)\s+([^\d].*)$", one)
        if m2:
            street, city = m2.group(1), m2.group(2)
        elif _HAUSNUMMER.search(one) or norm_key(one).endswith(_STRASSEN_ENDUNGEN):
            street = one
        else:
            city = one
    if street:
        street = _HAUSNUMMER.sub("", street).strip() or None
    return ParsedAddress(postcode=postcode, street=street, city=city or None)
