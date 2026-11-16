# Arztsuche-API für Mai Doctor Hub – ein Image für API und Import.
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ARZTSUCHE_DATA=/data

# libexpat: von osmium (Import) benötigt
RUN apt-get update \
 && apt-get install -y --no-install-recommends libexpat1 \
 && rm -rf /var/lib/apt/lists/* \
 && useradd --system --uid 10001 --home /app arztsuche \
 && mkdir -p /data && chown arztsuche /data

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY arztsuche ./arztsuche
COPY scripts/import.sh /usr/local/bin/arztsuche-import

USER arztsuche
VOLUME ["/data"]
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD python -c "import urllib.request,sys; urllib.request.urlopen('http://127.0.0.1:8000/api/v1/specialties', timeout=4)" || exit 1

# Kein Access-Log: Suchanfragen (PLZ/Adresse) werden nirgends protokolliert.
# --proxy-headers ist bewusst aus; die API wertet keine Client-IPs aus.
# Ein Worker: PoW-Einmalnutzung und Schreiblimits liegen im Prozessspeicher.
CMD ["uvicorn", "arztsuche.api:create_app", "--factory", "--host", "0.0.0.0", "--port", "8000", \
     "--no-access-log", "--no-server-header"]
