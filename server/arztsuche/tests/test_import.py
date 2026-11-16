import sqlite3

from arztsuche.importer import build
from tests.conftest import FIXTURE


def test_import_liest_praxen_und_adressen(data_dir):
    con = sqlite3.connect(data_dir / "arztsuche.sqlite")
    names = {r[0] for r in con.execute("SELECT name FROM practices")}
    assert names == {
        "Hausarztpraxis Alex Beispiel", "Zahnarzt Sam Muster",
        "Augenarztpraxis am Beispielweg", "Psychotherapie Domblick", "Praxis Widerspruch",
    }
    # Weg-Praxis bekommt den Mittelpunkt der Gebäudeknoten
    lat, lon = con.execute("SELECT lat, lon FROM practices WHERE osm_type='way'").fetchone()
    assert abs(lat - 52.5205) < 1e-6 and abs(lon - 13.4005) < 1e-6
    specs = dict(con.execute("SELECT name, specialties FROM practices"))
    assert specs["Zahnarzt Sam Muster"] == "dentistry"
    assert specs["Psychotherapie Domblick"] == "psychotherapist"
    assert con.execute("SELECT count(*) FROM postcodes").fetchone()[0] == 3
    meta = dict(con.execute("SELECT key, value FROM meta"))
    assert meta["practices"] == "5" and meta["schema_version"] == "1"


def test_optout_beim_import(tmp_path):
    opt = tmp_path / "optout.txt"
    opt.write_text("# Widerspruch\nnode/505\n")
    stats = build(FIXTURE, tmp_path / "db.sqlite", storage="flex_mem", optout=opt)
    assert stats["practices"] == 4 and stats["optout_skipped"] == 1


def test_import_ersetzt_atomar(tmp_path):
    out = tmp_path / "db.sqlite"
    build(FIXTURE, out, storage="flex_mem")
    build(FIXTURE, out, storage="flex_mem")
    assert out.exists() and not (tmp_path / "db.sqlite.building").exists()
