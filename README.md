# Enterprise Server Automation

A reusable framework for governed, end-to-end server provisioning with Jenkins, Ansible, PowerShell, Python, Git, and optional ServiceNow / virtualization / cloud integrations.

**Current status:** starter framework committed to main. Repository CI validates source artifacts and sample requests. Platform-specific VM provisioning and vendor integrations are deliberately gated until environment details, permissions, security controls and lab tests are complete.

## Scope

- Request schema and fail-closed approval validation
- Jenkins orchestration pipeline with validation-only default
- Reusable Ansible role scaffolding for Linux and Windows
- Guarded Hyper-V lab VM creation and read-only status reporting
- PowerShell and Python helpers/adapters
- Integration contracts for VMware, SCVMM/Hyper-V, HPE OneView, IPAM/DNS, patching, monitoring, backup and endpoint security
- ServiceNow API client scaffold
- CI checks, UAT checklist and operational runbook

## Quick links

- [Reference architecture](docs/architecture.md)
- [Setup guide](docs/setup.md)
- [Hyper-V laptop lab guide](docs/hyperv-lab.md)
- [Reported Hyper-V lab baseline](docs/hyperv-lab-status.md)
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

The example is intentionally marked pending; schema validation succeeds, but the CLI exits with status 2 because it is not authorized to provision.

## Hyper-V lab quick start

Run these scripts from an elevated PowerShell session on the Hyper-V host. Read [docs/hyperv-lab.md](docs/hyperv-lab.md) first. The creation script requires an explicit safety flag, checks host memory and existing resources, and leaves the VM powered off. It creates an empty VHDX; it does not install the operating system.

Preview only:

```powershell
.powershellNew-LabVM.ps1 -VMName 'LAB-UBUNTU01' -SwitchName 'Hyper-V' -VhdPath 'D:\Hyper-V\LAB-UBUNTU01\LAB-UBUNTU01.vhdx' -StartupMemoryGB 2 -VhdSizeGB 40 -ProcessorCount 2 -ConfirmLabProvisioning -WhatIf
```

The parent directory for the VHD must already exist. With approximately 3 GB free on a 16 GB host, the default guard will block creation until there is enough free memory for the VM plus a host reserve. Do not change existing switches, VPN routes, or existing workloads just to run this test.

Read-only status report:

```powershell
.powershell\Get-LabVMStatus.ps1
```

## Safety

- Do not commit credentials, tokens, private keys, production inventory data or real server secrets.
- Use Jenkins Credentials or an approved secrets manager.
- Retrieve approvals from the authoritative request system; do not trust a caller-supplied approval flag in production.
- Keep production execution behind reviews, protected environments, change controls and explicit validation gates.
- Test all adapters in an isolated lab before enabling infrastructure mutations.
- Do not grant a general-purpose Jenkins controller unrestricted administrator access to the Hyper-V host.

## CI/CD distinction

GitHub Actions checks repository content. Jenkins is the intended infrastructure workflow orchestrator. The Jenkins starter defaults to validation-only; selecting provision-lab still stops safely until a real platform adapter has been implemented and reviewed. The Hyper-V scripts are currently host-run lab utilities and are not yet connected to Jenkins.

## License

Choose and add an appropriate license before distributing this repository.
