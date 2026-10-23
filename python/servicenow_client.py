"""Minimal ServiceNow Table API client scaffold.

This module is opt-in and is not called by CI. Configure a least-privilege
integration user and store credentials in an external secret manager.
"""
from __future__ import annotations

import os
from typing import Any
from urllib.parse import quote

import requests


class ServiceNowClient:
    def __init__(self, instance_url: str, token: str, timeout: int = 20) -> None:
        if not instance_url.startswith("https://"):
            raise ValueError("ServiceNow instance URL must use HTTPS")
        self.base_url = instance_url.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {token}",
            "Accept": "application/json",
            "Content-Type": "application/json",
        })

    @classmethod
    def from_environment(cls) -> "ServiceNowClient":
        url = os.environ["SERVICENOW_INSTANCE_URL"]
        token = os.environ["SERVICENOW_TOKEN"]
        return cls(url, token)

    def get_record(self, table: str, sys_id: str) -> dict[str, Any]:
        # Table is restricted to an identifier to prevent path injection.
        if not table.replace("_", "").isalnum():
            raise ValueError("Invalid ServiceNow table name")
        url = f"{self.base_url}/api/now/table/{quote(table, safe='')}/{quote(sys_id, safe='')}"
        response = self.session.get(url, timeout=self.timeout)
        response.raise_for_status()
        payload = response.json()
        result = payload.get("result")
        if not isinstance(result, dict):
            raise ValueError("Unexpected ServiceNow API response shape")
        return result
