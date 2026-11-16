#!/bin/sh
# Lädt den OSM-Extrakt (Standard: Deutschland von Geofabrik, ~4,5 GB) und baut
# die Datenbank neu. Die laufende API liest danach sofort die neuen Daten.
set -eu
URL="${ARZTSUCHE_PBF_URL:-https://download.geofabrik.de/europe/germany-latest.osm.pbf}"
DATA="${ARZTSUCHE_DATA:-/data}"
PBF="$DATA/source.osm.pbf"

echo "Lade $URL …"
python -m arztsuche.download "$URL" "$PBF"
python -m arztsuche.importer --pbf "$PBF" --out "$DATA/arztsuche.sqlite" --optout "$DATA/optout.txt"
