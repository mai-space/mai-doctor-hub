from __future__ import annotations

from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from arztsuche.api import Settings, create_app
from arztsuche.importer import build

FIXTURE = Path(__file__).parent / "fixtures" / "sample.osm"


@pytest.fixture()
def data_dir(tmp_path: Path) -> Path:
    build(FIXTURE, tmp_path / "arztsuche.sqlite", storage="flex_mem")
    return tmp_path


@pytest.fixture()
def settings(data_dir: Path, monkeypatch) -> Settings:
    monkeypatch.setenv("ARZTSUCHE_DATA", str(data_dir))
    monkeypatch.setenv("ARZTSUCHE_POW_BITS", "8")  # schnell im Test
    monkeypatch.setenv("ARZTSUCHE_WRITES_PER_HOUR", "100")
    return Settings()


@pytest.fixture()
def client(settings: Settings) -> TestClient:
    return TestClient(create_app(settings))
