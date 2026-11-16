import pytest

from arztsuche.admin import main as admin
from arztsuche.community import PowGate


def _token(client) -> str:
    ch = client.get("/api/v1/accounts/challenge").json()
    sol = PowGate.solve(ch["challenge"], ch["difficulty"])
    r = client.post("/api/v1/accounts", json={"challenge": ch["challenge"], "solution": sol})
    assert r.status_code == 201
    return r.json()["token"]


def _auth(t: str) -> dict:
    return {"Authorization": f"Bearer {t}"}


def test_konto_braucht_geloeste_aufgabe(client):
    ch = client.get("/api/v1/accounts/challenge").json()
    bad = client.post("/api/v1/accounts", json={"challenge": ch["challenge"], "solution": "x"})
    assert bad.status_code == 400
    sol = PowGate.solve(ch["challenge"], ch["difficulty"])
    ok = client.post("/api/v1/accounts", json={"challenge": ch["challenge"], "solution": sol})
    assert ok.status_code == 201
    again = client.post("/api/v1/accounts", json={"challenge": ch["challenge"], "solution": sol})
    assert again.status_code == 400  # nur einmal einlösbar
    forged = ch["challenge"].rsplit(".", 1)[0] + ".00000000000000000000000000000000"
    assert client.post("/api/v1/accounts", json={"challenge": forged, "solution": sol}).status_code == 400


def test_schreiben_nur_mit_token(client):
    r = client.put("/api/v1/doctors/node-501/review", json={"rating": 5})
    assert r.status_code == 401
    r = client.put("/api/v1/doctors/node-501/review", json={"rating": 5}, headers=_auth("mdh_falsch"))
    assert r.status_code == 401


def test_bewertung_anlegen_aendern_loeschen(client):
    t = _token(client)
    r = client.put("/api/v1/doctors/node-501/review", json={"rating": 4, "text": "Freundlich, kurze Wartezeit."},
                   headers=_auth(t))
    assert r.status_code == 200
    client.put("/api/v1/doctors/node-501/review", json={"rating": 5}, headers=_auth(t))
    t2 = _token(client)
    client.put("/api/v1/doctors/node-501/review", json={"rating": 2}, headers=_auth(t2))

    page = client.get("/api/v1/doctors/node-501/reviews").json()
    assert page["total"] == 2 and page["rating"] == {"average": 3.5, "count": 2}
    assert all(len(i["month"]) == 7 for i in page["items"])
    hit = client.get("/api/v1/doctors", params={"plz": "10115", "q": "Alex"}).json()["items"][0]
    assert hit["rating"] == {"average": 3.5, "count": 2}

    assert client.delete("/api/v1/doctors/node-501/review", headers=_auth(t)).status_code == 204
    assert client.get("/api/v1/doctors/node-501/reviews").json()["total"] == 1


def test_bewertung_regeln(client):
    t = _token(client)
    assert client.put("/api/v1/doctors/node-999/review", json={"rating": 3}, headers=_auth(t)).status_code == 404
    assert client.put("/api/v1/doctors/node-501/review", json={"rating": 6}, headers=_auth(t)).status_code == 422
    r = client.put("/api/v1/doctors/node-501/review", json={"rating": 1, "text": "siehe www.spam.de"},
                   headers=_auth(t))
    assert r.status_code == 422


def test_meldungen_blenden_aus_und_bearbeiten_hebt_nicht_auf(client):
    author = _token(client)
    rid = client.put("/api/v1/doctors/node-501/review", json={"rating": 1, "text": "Unsinn"},
                     headers=_auth(author)).json()["id"]
    reporter = _token(client)
    for _ in range(3):  # dasselbe Konto zählt nur einmal
        client.post("/api/v1/reports", json={"review_id": rid, "reason": "insult"}, headers=_auth(reporter))
    assert client.get("/api/v1/doctors/node-501/reviews").json()["total"] == 1
    for _ in range(2):
        client.post("/api/v1/reports", json={"review_id": rid, "reason": "insult"}, headers=_auth(_token(client)))
    assert client.get("/api/v1/doctors/node-501/reviews").json()["total"] == 0
    client.put("/api/v1/doctors/node-501/review", json={"rating": 2, "text": "neu"}, headers=_auth(author))
    assert client.get("/api/v1/doctors/node-501/reviews").json()["total"] == 0


def test_neue_praxis_erst_nach_freigabe(client, settings):
    t = _token(client)
    body = {"name": "Praxis Neu", "kind": "doctor", "specialties": ["dermatology"],
            "street": "Musterstraße", "housenumber": "7", "postcode": "10115", "city": "Berlin",
            "phone": "+49 30 555", "website": "https://neu.example"}
    r = client.post("/api/v1/practices", json=body, headers=_auth(t))
    assert r.status_code == 202 and r.json()["status"] == "pending"
    pid = r.json()["id"]
    search = {"plz": "10115", "specialty": "dermatology"}
    assert client.get("/api/v1/doctors", params=search).json()["total"] == 0

    admin(["--db", str(settings.community_db), "approve", pid.split("-")[1]])
    items = client.get("/api/v1/doctors", params=search).json()["items"]
    assert [i["id"] for i in items] == [pid]
    assert items[0]["source"] == {"kind": "community", "osm": None, "url": None}
    assert client.put(f"/api/v1/doctors/{pid}/review", json={"rating": 5}, headers=_auth(t)).status_code == 200
    bad = {**body, "website": "javascript:alert(1)"}
    assert client.post("/api/v1/practices", json=bad, headers=_auth(t)).status_code == 422


def test_auskunft_und_loeschen(client):
    t = _token(client)
    client.put("/api/v1/doctors/node-501/review", json={"rating": 4, "text": "gut"}, headers=_auth(t))
    me = client.get("/api/v1/me", headers=_auth(t)).json()
    assert [r["practice_id"] for r in me["reviews"]] == ["node-501"]
    assert "token_hash" not in str(me)
    assert client.delete("/api/v1/me", headers=_auth(t)).status_code == 204
    assert client.get("/api/v1/me", headers=_auth(t)).status_code == 401
    assert client.get("/api/v1/doctors/node-501/reviews").json()["total"] == 0


def test_schreiblimit(client, settings, monkeypatch):
    from fastapi.testclient import TestClient

    from arztsuche.api import Settings, create_app
    monkeypatch.setenv("ARZTSUCHE_WRITES_PER_HOUR", "2")
    c = TestClient(create_app(Settings()))
    t = _token(c)
    codes = [c.put("/api/v1/doctors/node-501/review", json={"rating": 3}, headers=_auth(t)).status_code
             for _ in range(3)]
    assert codes == [200, 200, 429]


def test_abschaltbar(settings, monkeypatch):
    from fastapi.testclient import TestClient

    from arztsuche.api import Settings, create_app
    monkeypatch.setenv("ARZTSUCHE_COMMUNITY", "0")
    c = TestClient(create_app(Settings()))
    assert c.get("/api/v1/accounts/challenge").status_code == 404
    assert c.get("/api/v1/doctors", params={"plz": "10115"}).status_code == 200


@pytest.mark.parametrize("bits", [0, 4, 8])
def test_pow_referenzloesung(bits):
    g = PowGate(b"k" * 32, bits)
    c = g.issue()
    assert g.verify(c.challenge, PowGate.solve(c.challenge, bits))
