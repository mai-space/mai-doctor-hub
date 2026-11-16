"""Moderation auf dem Server (bewusst keine Admin-Endpunkte im Netz).

    docker compose exec api python -m arztsuche.admin pending
    docker compose exec api python -m arztsuche.admin approve 12
    docker compose exec api python -m arztsuche.admin reject 12
    docker compose exec api python -m arztsuche.admin reports
    docker compose exec api python -m arztsuche.admin hide-review 34
    docker compose exec api python -m arztsuche.admin restore-review 34
    docker compose exec api python -m arztsuche.admin remove-review 34
    docker compose exec api python -m arztsuche.admin optout node/123   # Praxis aus der Suche nehmen
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

from .community import Community


def _ts(v: int) -> str:
    return datetime.fromtimestamp(v, timezone.utc).strftime("%Y-%m-%d %H:%M")


def main(argv: list[str] | None = None) -> int:
    data = Path(os.environ.get("ARZTSUCHE_DATA", "/data"))
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--db", type=Path, default=Path(os.environ.get("ARZTSUCHE_COMMUNITY_DB", data / "community.sqlite")))
    ap.add_argument("--optout-file", type=Path, default=Path(os.environ.get("ARZTSUCHE_OPTOUT", data / "optout.txt")))
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("pending")
    sub.add_parser("reports")
    for name in ("approve", "reject", "hide-review", "restore-review", "remove-review"):
        sub.add_parser(name).add_argument("id", type=int)
    sub.add_parser("optout").add_argument("osm", help="z. B. node/123")
    a = ap.parse_args(argv)

    if a.cmd == "optout":
        with a.optout_file.open("a", encoding="utf-8") as f:
            f.write(f"{a.osm}  # {datetime.now(timezone.utc):%Y-%m-%d}\n")
        print(f"{a.osm} wird ab sofort nicht mehr ausgeliefert.")
        return 0

    c = Community(a.db)
    with c.connect() as con:
        if a.cmd == "pending":
            for r in con.execute("SELECT * FROM submitted_practices WHERE status='pending' ORDER BY id"):
                d = dict(r)
                d.pop("account_id")
                d["created_at"] = _ts(d["created_at"])
                print(json.dumps(d, ensure_ascii=False))
        elif a.cmd == "reports":
            for r in con.execute(
                """SELECT rp.id, rp.review_id, rp.practice_id, rp.reason, rp.message, rp.created_at,
                          rv.text, rv.rating, rv.status FROM reports rp
                   LEFT JOIN reviews rv ON rv.id = rp.review_id WHERE rp.resolved = 0 ORDER BY rp.id"""):
                d = dict(r)
                d["created_at"] = _ts(d["created_at"])
                print(json.dumps(d, ensure_ascii=False))
        elif a.cmd in ("approve", "reject"):
            st = "approved" if a.cmd == "approve" else "rejected"
            n = con.execute("UPDATE submitted_practices SET status=? WHERE id=?", (st, a.id)).rowcount
            print(f"Praxis {a.id}: {st}" if n else "nicht gefunden")
        else:
            st = {"hide-review": "hidden", "restore-review": "visible", "remove-review": "removed"}[a.cmd]
            n = con.execute("UPDATE reviews SET status=? WHERE id=?", (st, a.id)).rowcount
            con.execute("UPDATE reports SET resolved=1 WHERE review_id=?", (a.id,))
            print(f"Bewertung {a.id}: {st}" if n else "nicht gefunden")
    return 0


if __name__ == "__main__":
    sys.exit(main())
