# Arztsuche-API (`doctorhub.maispace.de/api`)

Eigene, schlanke API, mit der Mai Doctor Hub Arztpraxen in ganz Deutschland
per PLZ, Adresse oder Standort findet. Daten aus **OpenStreetMap** (ODbL),
dazu optional **Bewertungen und neue Praxen von Nutzern** – nur wer das in
der App ausdrücklich will, legt dafür ein pseudonymes Konto an.

## Warum dieser Stack

| Entscheidung | Begründung |
|---|---|
| **Python + FastAPI** | `pyosmium` ist der Standard-Weg, OSM-PBF schnell zu lesen; FastAPI liefert OpenAPI (`/api/docs`) für den Dart-Client gratis. |
| **SQLite (R*Tree + FTS5)** statt Postgres/PostGIS | Die Daten sind klein (~100–150 k Praxen, ~1 Mio. Straßen) und fast nur lesend. Eine Datei, kein DB-Server, kein Tuning. Der Import baut eine neue Datei und ersetzt die alte atomar – keine Ausfallzeit. |
| **Eigener Geocoder** aus OSM-Hausadressen | PLZ-/Straßen-/Ortsmittelpunkte stehen in derselben Datei. Eingegebene Adressen verlassen den Server nie (kein Nominatim/Google). |
| **Nutzerbeiträge in eigener Datei** (`community.sqlite`, WAL) | Ein OSM-Import kann sie nie überschreiben; Sicherung = eine Datei kopieren. |
| **Ein Image für API und Import** | `docker compose run --rm importer` nutzt denselben Code wie die API. |

## Endpunkte (alle unter `/api`)

| Methode | Pfad | Zweck |
|---|---|---|
| GET | `/api/v1/doctors?plz=10115` | Suche um PLZ-Mittelpunkt |
| GET | `/api/v1/doctors?address=Hauptstr. 5, 10115 Berlin` | Suche um Straße/PLZ/Ort |
| GET | `/api/v1/doctors?lat=52.52&lon=13.40` | Suche um Standort (GPS bleibt auf Wunsch in der App) |
| | weitere Filter: `radius_km` (≤ 50, Std. 5), `specialty`, `kind` (`doctor`/`dentist`/`psychotherapist`), `q` (Name), `insurance` (`public`/`private`), `limit`, `offset` | |
| GET | `/api/v1/doctors/{id}` | eine Praxis (`node-123`, `way-456`, `user-7`) |
| GET | `/api/v1/specialties` | Fachrichtungen mit deutschem/englischem Namen |
| GET | `/api/v1/meta` | Datenstand, Anzahl, Attribution |
| GET | `/api/v1/doctors/{id}/reviews` | Bewertungen (Monat statt genauem Datum) |
| GET/POST | `/api/v1/accounts/challenge`, `/api/v1/accounts` | pseudonymes Konto (Proof-of-Work) |
| PUT/DELETE | `/api/v1/doctors/{id}/review` | eigene Bewertung (1–5, Text ≤ 2000, keine Links) |
| POST | `/api/v1/practices` | neue Praxis vorschlagen (sichtbar nach Freigabe) |
| POST | `/api/v1/reports` | Bewertung/Daten melden |
| GET/DELETE | `/api/v1/me` | Auskunft/Export bzw. Konto mit allen Beiträgen löschen |
| GET | `/api/health` | Healthcheck |

Jede Praxis liefert: Name, Art, Fachrichtungen (Schlüssel + DE/EN), Adresse,
Telefon, Website, E-Mail, Öffnungszeiten, Rollstuhl, `insurance.public` /
`insurance.private` (`null` = unbekannt), Koordinaten, Entfernung,
`rating` (nur App-Bewertungen) und `source.url` zum Korrigieren auf OSM.

**Antwortfelder nur ergänzen, nie umbenennen** – ältere App-Versionen lesen
dieselbe API.

## Konten, Bewertungen, Missbrauchsschutz

- **Konto ohne Daten:** Die App holt eine Aufgabe (`/accounts/challenge`),
  sucht `n` mit `sha256(challenge + ":" + n)` ≥ `difficulty` führenden
  Null-Bits (Std. 20 ≈ 1–2 s auf dem Handy) und bekommt ein zufälliges Token.
  Gespeichert wird nur dessen SHA-256 und der Anlagezeitpunkt – keine E-Mail,
  kein Name, keine IP, keine Geräte-ID. Token in der App verschlüsselt
  speichern; geht es verloren, ist das Konto verwaist (Löschen über die
  Opt-out-/Moderationswege).
- **Limits:** `ARZTSUCHE_WRITES_PER_HOUR` Schreibzugriffe je Konto (nur im
  Speicher), dazu `limit_req` im nginx-Beispiel.
- **Bewertungen:** eine je Konto und Praxis, sofort sichtbar. Ab 3 Meldungen
  verschiedener Konten automatisch ausgeblendet, bis die Moderation
  entscheidet; Bearbeiten hebt das nicht auf.
- **Neue Praxen:** erst nach Freigabe sichtbar.
- **Moderation** nur auf dem Server, ohne Admin-Endpunkte im Netz:

  ```bash
  docker compose exec api python -m arztsuche.admin pending
  docker compose exec api python -m arztsuche.admin approve 12
  docker compose exec api python -m arztsuche.admin reports
  docker compose exec api python -m arztsuche.admin hide-review 34
  docker compose exec api python -m arztsuche.admin optout node/123   # Praxis sofort ausblenden
  ```

Mit `ARZTSUCHE_COMMUNITY=0` läuft die API als reine Suche.

## Betrieb

Voraussetzungen: Linux-Server mit Docker + Compose, DNS
`doctorhub.maispace.de` → Server. Für den Deutschland-Import (Schätzung,
nicht auf echter Hardware gemessen): ~15 GB freie Platte (4,5 GB PBF +
Knoten-Cache), 2–4 GB RAM, 20–60 min. Die fertige Datenbank ist deutlich
kleiner (geschätzt < 300 MB). Für Tests lieber erst ein Bundesland:
`ARZTSUCHE_PBF_URL=https://download.geofabrik.de/europe/germany/bremen-latest.osm.pbf`.

```bash
cd server/arztsuche
docker compose build
docker compose run --rm importer          # lädt Geofabrik-Deutschland, baut /data/arztsuche.sqlite
docker compose up -d api                  # lauscht nur auf 127.0.0.1:8000
curl 'http://127.0.0.1:8000/api/v1/doctors?plz=10115'
```

**Aktualisieren** (Geofabrik aktualisiert täglich; monatlich reicht), z. B. per Cron:

```cron
15 3 1 * * cd /opt/mai-doctor-hub/server/arztsuche && docker compose run --rm importer >> /var/log/arztsuche-import.log 2>&1
```

Der Import lädt nur, wenn die Datei neuer ist, und ersetzt die Datenbank
erst nach Erfolg. Schlägt er fehl, läuft die API mit dem alten Stand weiter.

**Sicherung:** nur `community.sqlite` ist unersetzlich
(`docker compose exec api python -c "import sqlite3; sqlite3.connect('/data/community.sqlite').backup(sqlite3.connect('/data/community.bak'))"`
oder das Volume `arztsuche-data` sichern). `arztsuche.sqlite` lässt sich
jederzeit neu importieren.

### HTTPS und Pfad `/api`

Die API hängt ihre Routen selbst unter `/api` – der Proxy reicht den Pfad
**unverändert** durch (kein Strip-Prefix).

- **Kein Webserver auf dem Server?** `docker compose --profile caddy up -d`
  startet Caddy mit automatischem Let's-Encrypt-Zertifikat
  ([`deploy/Caddyfile`](deploy/Caddyfile)); Caddy erreicht die API im
  Compose-Netz als `api:8000`.
- **Schon nginx da?** [`deploy/nginx.conf.example`](deploy/nginx.conf.example)
  einbinden und `certbot --nginx -d doctorhub.maispace.de` ausführen. Enthält
  HSTS, Ratenlimits und `access_log off`.

## Datenschutz

- Keine Cookies, keine Zugriffsprotokolle (`--no-access-log`, Proxy-Logs aus),
  keine Analytics, `Cache-Control: no-store`. Suchanfragen werden nicht
  gespeichert. Die API sieht keine Client-IPs (Caddy entfernt
  `X-Forwarded-For`; nginx-Ratenlimit hält IPs nur im Speicher).
- Container läuft als Nicht-root, `read_only`, ohne Capabilities.
- **Löschweg Praxen** (Widerspruch Art. 21 DSGVO): Eintrag in
  `/data/optout.txt` (z. B. per `admin optout node/123`) wirkt sofort und bei
  jedem weiteren Import. Zusätzlich auf OSM korrigieren lassen
  (`source.url`).
- **Löschweg Nutzer:** `DELETE /api/v1/me` löscht Konto, Bewertungen und
  offene Vorschläge; `GET /api/v1/me` liefert alle gespeicherten Daten.

## Pflichten beim Ausliefern

- **ODbL-Attribution:** „© OpenStreetMap-Mitwirkende“ mit Link zu
  <https://www.openstreetmap.org/copyright> sichtbar in der App (z. B. unter
  der Trefferliste). Das Feld `attribution` liefert den Text. Die Datenbank
  ist eine abgeleitete Datenbank: Wer sie *weitergibt*, muss sie unter ODbL
  anbieten – über die API ausgelieferte Einzelergebnisse sind ein
  „Produced Work“, Attribution genügt.
- Kassen-/Privatstatus stammt nur aus dem OSM-Tag `insurance:health` und ist
  meist `null` – in der App als „unbekannt“ anzeigen, nicht als „nein“.

## Entwicklung

```bash
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements-dev.txt
pytest -q
python -m arztsuche.importer --pbf tests/fixtures/sample.osm --out /tmp/a.sqlite
ARZTSUCHE_DATA=/tmp uvicorn arztsuche.api:create_app --factory --reload
```

Testdaten (`tests/fixtures/sample.osm`) sind frei erfunden.
