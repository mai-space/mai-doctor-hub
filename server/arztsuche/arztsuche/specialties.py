"""Fachrichtungen (OSM `healthcare:speciality`) mit deutschen/englischen Namen.

Unbekannte Werte werden nicht verworfen, sondern unverändert ausgeliefert –
die App zeigt dann den Rohwert."""

from __future__ import annotations

# Schlüssel = OSM-Wert. Nur ergänzen, nie umbenennen (Apps filtern danach).
SPECIALTIES: dict[str, tuple[str, str]] = {
    "general": ("Allgemeinmedizin", "General practice"),
    "internal": ("Innere Medizin", "Internal medicine"),
    "dentistry": ("Zahnmedizin", "Dentistry"),
    "orthodontics": ("Kieferorthopädie", "Orthodontics"),
    "oral_surgery": ("Oralchirurgie", "Oral surgery"),
    "paediatrics": ("Kinder- und Jugendmedizin", "Paediatrics"),
    "gynaecology": ("Frauenheilkunde", "Gynaecology"),
    "obstetrics": ("Geburtshilfe", "Obstetrics"),
    "ophthalmology": ("Augenheilkunde", "Ophthalmology"),
    "otolaryngology": ("HNO-Heilkunde", "Ear, nose and throat"),
    "dermatology": ("Dermatologie", "Dermatology"),
    "orthopaedics": ("Orthopädie", "Orthopaedics"),
    "trauma": ("Unfallchirurgie", "Trauma surgery"),
    "surgery": ("Chirurgie", "Surgery"),
    "urology": ("Urologie", "Urology"),
    "neurology": ("Neurologie", "Neurology"),
    "psychiatry": ("Psychiatrie", "Psychiatry"),
    "psychotherapist": ("Psychotherapie", "Psychotherapy"),
    "psychotherapy": ("Psychotherapie", "Psychotherapy"),
    "child_psychiatry": ("Kinder- und Jugendpsychiatrie", "Child psychiatry"),
    "cardiology": ("Kardiologie", "Cardiology"),
    "gastroenterology": ("Gastroenterologie", "Gastroenterology"),
    "pulmonology": ("Pneumologie", "Pulmonology"),
    "nephrology": ("Nephrologie", "Nephrology"),
    "endocrinology": ("Endokrinologie", "Endocrinology"),
    "diabetology": ("Diabetologie", "Diabetology"),
    "rheumatology": ("Rheumatologie", "Rheumatology"),
    "oncology": ("Onkologie", "Oncology"),
    "haematology": ("Hämatologie", "Haematology"),
    "radiology": ("Radiologie", "Radiology"),
    "nuclear": ("Nuklearmedizin", "Nuclear medicine"),
    "radiotherapy": ("Strahlentherapie", "Radiotherapy"),
    "anaesthetics": ("Anästhesiologie", "Anaesthetics"),
    "pain_medicine": ("Schmerzmedizin", "Pain medicine"),
    "physiatry": ("Physikalische Medizin", "Physical medicine"),
    "occupational": ("Arbeitsmedizin", "Occupational medicine"),
    "allergology": ("Allergologie", "Allergology"),
    "angiology": ("Angiologie", "Angiology"),
    "vascular_surgery": ("Gefäßchirurgie", "Vascular surgery"),
    "plastic_surgery": ("Plastische Chirurgie", "Plastic surgery"),
    "neurosurgery": ("Neurochirurgie", "Neurosurgery"),
    "maxillofacial_surgery": ("Mund-Kiefer-Gesichtschirurgie", "Maxillofacial surgery"),
    "geriatrics": ("Geriatrie", "Geriatrics"),
    "sports": ("Sportmedizin", "Sports medicine"),
    "venereology": ("Venerologie", "Venereology"),
    "phlebology": ("Phlebologie", "Phlebology"),
    "proctology": ("Proktologie", "Proctology"),
    "pathology": ("Pathologie", "Pathology"),
    "laboratory_medicine": ("Labormedizin", "Laboratory medicine"),
    "biology": ("Labormedizin", "Laboratory medicine"),
    "homeopathy": ("Homöopathie", "Homeopathy"),
    "naturopathy": ("Naturheilverfahren", "Naturopathy"),
    "acupuncture": ("Akupunktur", "Acupuncture"),
    "osteopathy": ("Osteopathie", "Osteopathy"),
    "occupational_therapy": ("Ergotherapie", "Occupational therapy"),
    "speech_therapy": ("Logopädie", "Speech therapy"),
}


def label(key: str, lang: str = "de") -> str:
    names = SPECIALTIES.get(key)
    if not names:
        return key.replace("_", " ")
    return names[0] if lang == "de" else names[1]


def parse_specialties(tags: dict[str, str]) -> list[str]:
    """Fachrichtungen aus OSM-Tags; Zahnärzte/Psychotherapeuten bekommen ihre
    Fachrichtung auch ohne `healthcare:speciality`."""
    raw = tags.get("healthcare:speciality") or tags.get("healthcare:specialty") or ""
    out: list[str] = []
    for part in raw.replace(",", ";").split(";"):
        key = part.strip().lower().replace(" ", "_")
        if key and key not in out:
            out.append(key)
    kind = tags.get("healthcare") or ""
    if (tags.get("amenity") == "dentist" or kind == "dentist") and not any(
        k in out for k in ("dentistry", "orthodontics", "oral_surgery")
    ):
        out.insert(0, "dentistry")
    if kind == "psychotherapist" and not any(k.startswith("psych") for k in out):
        out.insert(0, "psychotherapist")
    return out
