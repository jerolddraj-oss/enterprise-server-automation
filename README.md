# Enterprise Server Automation

A reusable framework for governed, end-to-end server provisioning with Jenkins, Ansible, PowerShell, Python, Git, and optional ServiceNow / virtualization / cloud integrations.

## Scope

- Request validation and provisioning workflow scaffolding
- Jenkins pipeline orchestration
- Windows and Linux configuration with Ansible
- PowerShell/Python helper scripts
- Input validation, compliance checks, and CI validation
- ServiceNow and operations integrations through explicit adapters
- Documentation for secure environment-specific configuration

## Safety first

This repository is a starter framework, not a turnkey production deployment. Platform adapters and integrations must be configured and tested against your environment before use. No production infrastructure is changed automatically by the CI validation workflow.

**Never commit credentials, tokens, private keys, production inventory data, or real server secrets.** Store credentials in Jenkins Credentials or an approved secret manager. Use least privilege, approvals, audit logging, and environment-specific controls.

## Repository layout

```text
.github/workflows/       GitHub Actions validation only
jenkins/                 Jenkins orchestration pipeline and shared guidance
ansible/                 Windows/Linux playbooks and reusable roles
powershell/              Windows and virtualization adapter scaffolding
python/                  Request schema validation and integration helpers
terraform/               Cloud infrastructure module scaffolding
policies/                Example request and build policy
tests/                   Lightweight automated tests
docs/                    Architecture, setup, security, operations
```

## Getting started

1. Read [Architecture](docs/architecture.md) and [Setup](docs/setup.md).
2. Review `policies/server-request.schema.json` and sample request data.
3. Run the repository validation workflow by pushing changes.
4. Configure Jenkins agents, credentials, network access, and platform adapters in a lab.
5. Run unit/syntax checks and UAT before enabling any provisioning stages.

## CI/CD distinction

GitHub Actions validates code and configuration in this repository. Jenkins is the intended orchestrator for infrastructure workflows. Actual VM provisioning stays disabled until required environment-specific adapter settings and approvals are supplied.

## License

Choose and add an appropriate license before distributing this repository.