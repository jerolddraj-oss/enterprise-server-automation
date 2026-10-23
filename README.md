# Enterprise Server Automation

A reusable framework for governed, end-to-end server provisioning with Jenkins, Ansible, PowerShell, Python, Git, and optional ServiceNow / virtualization / cloud integrations.

**Current status:** starter framework committed to `main`. Repository CI validates source artifacts and sample requests. Platform-specific VM provisioning and vendor integrations are deliberately gated until environment details, permissions, security controls and lab tests are complete.

## Scope

- Request schema and fail-closed approval validation
- Jenkins orchestration pipeline with validation-only default
- Reusable Ansible role scaffolding for Linux and Windows
- PowerShell and Python helpers/adapters
- Integration contracts for VMware, SCVMM/Hyper-V, HPE OneView, IPAM/DNS, patching, monitoring, backup and endpoint security
- ServiceNow API client scaffold
- CI checks, UAT checklist and operational runbook

## Quick links

- [Reference architecture](docs/architecture.md)
- [Setup guide](docs/setup.md)
- [Security controls](docs/security.md)
- [Integration contracts](docs/integrations.md)
- [Jenkins credential guide](docs/jenkins-credentials.md)
- [Operations runbook](docs/operations-runbook.md)
- [UAT checklist](docs/uat-checklist.md)

## Local validation

```bash
python -m pip install -r requirements-dev.txt
python -m pytest -q
python -m python.validate_request policies/server-request.example.json
```

The example is intentionally marked `pending`; schema validation succeeds, but the CLI exits with status 2 because it is not authorized to provision.

## Safety

- Do not commit credentials, tokens, private keys, production inventory data or real server secrets.
- Use Jenkins Credentials or an approved secrets manager.
- Retrieve approvals from the authoritative request system; do not trust a caller-supplied approval flag in production.
- Keep production execution behind reviews, protected environments, change controls and explicit validation gates.
- Test all adapters in an isolated lab before enabling infrastructure mutations.

## CI/CD distinction

GitHub Actions checks repository content. Jenkins is the intended infrastructure workflow orchestrator. The Jenkins starter defaults to `validate-only`; selecting `provision-lab` still stops safely until a real platform adapter has been implemented and reviewed.

## License

Choose and add an appropriate license before distributing this repository.
