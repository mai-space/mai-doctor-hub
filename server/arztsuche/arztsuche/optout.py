"""Opt-out-Liste: Praxen, die nicht (mehr) ausgeliefert werden sollen –
z. B. nach einem Widerspruch nach Art. 21 DSGVO. Eine Zeile je Eintrag im
Format `node/123` oder `way/456`; `#` leitet Kommentare ein. Wird beim Import
und zusätzlich bei jeder Antwort der API berücksichtigt (wirkt also sofort,
ohne neuen Import)."""

from __future__ import annotations

import re
from pathlib import Path

_LINE = re.compile(r"^(node|way)/(\d+)$")


def load_optout(path: Path) -> set[str]:
    try:
        text = path.read_text(encoding="utf-8")
    except FileNotFoundError:
        return set()
    out: set[str] = set()
    for line in text.splitlines():
        line = line.split("#", 1)[0].strip()
        if _LINE.match(line):
            out.add(line)
    return out


class OptOut:
    """Liest die Datei neu, sobald sie sich ändert."""

    def __init__(self, path: Path | None) -> None:
        self.path = path
        self._mtime: float | None = None
        self._ids: set[str] = set()

    def ids(self) -> set[str]:
        if self.path is None:
            return set()
        try:
            mtime = self.path.stat().st_mtime
        except FileNotFoundError:
            self._mtime, self._ids = None, set()
            return self._ids
        if mtime != self._mtime:
            self._ids = load_optout(self.path)
            self._mtime = mtime
        return self._ids
