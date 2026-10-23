import json
from pathlib import Path

from python.validate_request import DEFAULT_SCHEMA, load_json, validate_request

ROOT = Path(__file__).resolve().parents[1]


def test_example_request_matches_schema():
    schema = load_json(DEFAULT_SCHEMA)
    request = load_json(ROOT / "policies" / "server-request.example.json")
    assert validate_request(request, schema) == []


def test_unknown_fields_are_rejected():
    schema = load_json(DEFAULT_SCHEMA)
    request = load_json(ROOT / "policies" / "server-request.example.json")
    request["administrator_password"] = "must-never-be-in-request-data"
    errors = validate_request(request, schema)
    assert any("Additional properties are not allowed" in error for error in errors)


def test_domain_join_requires_ou():
    schema = load_json(DEFAULT_SCHEMA)
    request = load_json(ROOT / "policies" / "server-request.example.json")
    request["domain_join"] = True
    errors = validate_request(request, schema)
    assert any("domain_ou" in error for error in errors)
