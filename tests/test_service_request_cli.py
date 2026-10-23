import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_pending_request_does_not_pass_approval_gate():
    completed = subprocess.run(
        [
            sys.executable, "-m", "python.validate_request",
            str(ROOT / "policies" / "server-request.example.json"),
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    assert completed.returncode == 2
    assert "not 'approved'" in completed.stdout


def test_approved_request_passes_schema_and_approval_gate(tmp_path):
    request_path = ROOT / "policies" / "server-request.example.json"
    request = json.loads(request_path.read_text(encoding="utf-8"))
    request["approval_status"] = "approved"
    target = tmp_path / "approved-request.json"
    target.write_text(json.dumps(request), encoding="utf-8")
    completed = subprocess.run(
        [sys.executable, "-m", "python.validate_request", str(target)],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    assert completed.returncode == 0, completed.stdout + completed.stderr
