"""Automated tests for the service information page (app.py)."""
import importlib

import pytest

import app as app_module


@pytest.fixture
def client():
    app_module.app.config["TESTING"] = True
    return app_module.app.test_client()


def test_index_shows_service_information(client):
    """Normal output: the page shows name, contact, hours and version."""
    response = client.get("/")
    assert response.status_code == 200
    page = response.get_data(as_text=True)
    assert "Campus Print Service" in page
    assert "print-support@example.com" in page
    assert "08:00 - 16:00" in page
    assert app_module.VERSION in page


def test_index_shows_location_and_status(client):
    """v1.1.0 fields: the page shows the service location and status."""
    page = client.get("/").get_data(as_text=True)
    assert "Main Library, Ground Floor" in page
    assert "Operational" in page


def test_health_returns_ok(client):
    """The /health endpoint returns HTTP 200 and status ok."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"


def test_unknown_page_returns_404(client):
    """Error case: an unknown path returns 404, not a crash (500)."""
    response = client.get("/does-not-exist")
    assert response.status_code == 404


def test_version_comes_from_environment(monkeypatch):
    """Edge case: the version shown is the one set at build/deploy time."""
    monkeypatch.setenv("APP_VERSION", "9.9.9-test")
    reloaded = importlib.reload(app_module)
    client = reloaded.app.test_client()
    assert "9.9.9-test" in client.get("/").get_data(as_text=True)
    assert client.get("/health").get_json()["version"] == "9.9.9-test"
    monkeypatch.delenv("APP_VERSION")
    importlib.reload(app_module)
