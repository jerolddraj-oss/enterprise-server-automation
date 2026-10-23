"""Validate server request JSON against the repository schema.

This utility validates data only; it does not provision infrastructure.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator, FormatChecker


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SCHEMA = ROOT / "policies" / "server-request.schema.json"


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def validate_request(request: Any, schema: dict[str, Any]) -> list[str]:
    validator = Draft202012Validator(schema, format_checker=FormatChecker())
    errors = sorted(validator.iter_errors(request), key=lambda e: list(map(str, e.path)))
    return [
        f"{'.'.join(map(str, error.path)) or '<root>'}: {error.message}"
        for error in errors
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("request", type=Path, help="Path to request JSON")
    parser.add_argument("--schema", type=Path, default=DEFAULT_SCHEMA)
    args = parser.parse_args()

    request = load_json(args.request)
    schema = load_json(args.schema)
    errors = validate_request(request, schema)
    if errors:
        print("Request is INVALID:")
        for error in errors:
            print(f"- {error}")
        return 1

    if request.get("approval_status") != "approved":
        print("Request schema is valid, but approval_status is not 'approved'.")
        return 2

    print(f"Request {request['request_id']} is valid and marked approved.")
    print("This validator does not provision or modify infrastructure.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
