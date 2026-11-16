"""Lädt den OSM-Extrakt nur, wenn er neuer ist (If-Modified-Since)."""

from __future__ import annotations

import email.utils
import os
import shutil
import sys
import urllib.request
from pathlib import Path


def fetch(url: str, dest: Path) -> bool:
    """True, wenn eine neue Datei geladen wurde."""
    req = urllib.request.Request(url, headers={"User-Agent": "mai-arztsuche-import/1"})
    if dest.exists():
        req.add_header("If-Modified-Since", email.utils.formatdate(dest.stat().st_mtime, usegmt=True))
    part = dest.with_name(dest.name + ".part")
    try:
        with urllib.request.urlopen(req, timeout=60) as resp, part.open("wb") as f:
            shutil.copyfileobj(resp, f, length=1 << 20)
            lm = resp.headers.get("Last-Modified")
    except urllib.error.HTTPError as e:
        part.unlink(missing_ok=True)
        if e.code == 304:
            return False
        raise
    os.replace(part, dest)
    if lm:
        ts = email.utils.parsedate_to_datetime(lm).timestamp()
        os.utime(dest, (ts, ts))
    return True


if __name__ == "__main__":
    url, dest = sys.argv[1], Path(sys.argv[2])
    print("neu geladen" if fetch(url, dest) else "unverändert, kein Download")
