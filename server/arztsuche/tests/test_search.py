def test_suche_per_plz_sortiert_nach_entfernung(client):
    r = client.get("/api/v1/doctors", params={"plz": "10115", "radius_km": 10})
    assert r.status_code == 200
    body = r.json()
    assert body["center"]["precision"] == "postcode"
    names = [p["name"] for p in body["items"]]
    assert "Psychotherapie Domblick" not in names  # Köln liegt außerhalb
    assert names[0] in ("Hausarztpraxis Alex Beispiel", "Praxis Widerspruch")
    dists = [p["distance_km"] for p in body["items"]]
    assert dists == sorted(dists)
    assert "OpenStreetMap" in body["attribution"]


def test_felder_einer_praxis(client):
    items = client.get("/api/v1/doctors", params={"plz": "10115", "q": "Alex"}).json()["items"]
    assert len(items) == 1
    p = items[0]
    assert p["id"] == "node-501"
    assert [s["key"] for s in p["specialties"]] == ["general", "internal"]
    assert p["specialties"][0]["de"] == "Allgemeinmedizin"
    assert p["address"] == {"street": "Musterstraße", "housenumber": "5", "postcode": "10115", "city": "Berlin"}
    assert p["phone"] == "+49 30 1234567"
    assert p["website"] == "https://praxis-beispiel.example"
    assert p["insurance"] == {"public": True, "private": True}
    assert p["source"]["url"] == "https://www.openstreetmap.org/node/501"


def test_suche_per_adresse_und_filter(client):
    r = client.get("/api/v1/doctors", params={"address": "Musterstr. 3, Berlin", "specialty": "ophthalmology"})
    body = r.json()
    assert body["center"]["precision"] == "street"
    assert [p["name"] for p in body["items"]] == ["Augenarztpraxis am Beispielweg"]
    priv = client.get("/api/v1/doctors", params={"plz": "10115", "insurance": "public"}).json()
    assert [p["name"] for p in priv["items"]] == ["Hausarztpraxis Alex Beispiel"]
    dent = client.get("/api/v1/doctors", params={"plz": "10115", "kind": "dentist"}).json()
    assert [p["name"] for p in dent["items"]] == ["Zahnarzt Sam Muster"]


def test_suche_per_ort_und_koordinaten(client):
    body = client.get("/api/v1/doctors", params={"address": "Köln"}).json()
    assert body["center"]["precision"] == "city"
    assert [p["name"] for p in body["items"]] == ["Psychotherapie Domblick"]
    body = client.get("/api/v1/doctors", params={"lat": 50.94, "lon": 6.96, "radius_km": 1}).json()
    assert body["total"] == 1


def test_fehlerfaelle(client):
    assert client.get("/api/v1/doctors").status_code == 422
    assert client.get("/api/v1/doctors", params={"plz": "99999"}).status_code == 404
    assert client.get("/api/v1/doctors", params={"plz": "1234"}).status_code == 422
    assert client.get("/api/v1/doctors", params={"plz": "10115", "radius_km": 500}).status_code == 422
    # FTS-Sonderzeichen von außen dürfen nicht durchschlagen
    assert client.get("/api/v1/doctors", params={"plz": "10115", "q": 'Alex" OR *'}).status_code == 200


def test_detail_meta_specialties(client):
    assert client.get("/api/v1/doctors/way-600").json()["name"] == "Augenarztpraxis am Beispielweg"
    assert client.get("/api/v1/doctors/node-999").status_code == 404
    assert client.get("/api/v1/doctors/foo").status_code == 404
    meta = client.get("/api/v1/meta").json()
    assert meta["practices"] == "5" and meta["community"] is True
    assert any(s["key"] == "dentistry" for s in client.get("/api/v1/specialties").json())
    assert client.get("/api/health").json() == {"status": "ok"}


def test_optout_wirkt_sofort(client, settings):
    settings.optout_path.write_text("node/505\n")
    names = [p["name"] for p in client.get("/api/v1/doctors", params={"plz": "10115"}).json()["items"]]
    assert "Praxis Widerspruch" not in names
    assert client.get("/api/v1/doctors/node-505").status_code == 404


def test_keine_cookies_und_no_store(client):
    r = client.get("/api/v1/doctors", params={"plz": "10115"})
    assert "set-cookie" not in r.headers
    assert r.headers["cache-control"] == "no-store"


def test_ohne_datenbank_503(tmp_path, monkeypatch):
    from fastapi.testclient import TestClient

    from arztsuche.api import Settings, create_app
    monkeypatch.setenv("ARZTSUCHE_DATA", str(tmp_path))
    c = TestClient(create_app(Settings()))
    assert c.get("/api/health").status_code == 503
    assert c.get("/api/v1/doctors", params={"plz": "10115"}).status_code == 503
