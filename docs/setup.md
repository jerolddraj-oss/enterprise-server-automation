# Setup guide

## Local validation

Requires Python 3.10+.

```bash
python -m venv .venv
# Linux/macOS:
source .venv/bin/activate
# Windows PowerShell:
# .venv\Scripts\Activate.ps1
python -m pip install -r requirements-dev.txt
python -m pytest -q
python -m python.validate_request policies/server-request.example.json
```

The sample request is intentionally marked pending. Schema validation succeeds, but the validator exits with status 2 because it is not authorized to provision. For local positive-path testing, copy the example to a temporary file, set approval_status to approved, and validate that copy. Do not use locally edited approval fields to bypass an authoritative ServiceNow approval in production.

## Hyper-V laptop lab

For a resource-conscious Windows 10/11 Pro lab, read [the Hyper-V laptop lab guide](hyperv-lab.md) and [the reported lab baseline](hyperv-lab-status.md) before creating VMs. The PowerShell scripts are currently manual, host-side lab utilities. They do not install a guest OS or connect Jenkins to the Hyper-V host.

## Jenkins

1. Create an agent labelled infra-automation with Git, Python 3 and the needed Ansible tools.
2. Create a Pipeline job from this repository and point it to jenkins/Jenkinsfile.
3. Keep ACTION=validate-only initially.
4. Configure credentials through Jenkins Credentials or an approved vault.
5. Implement and test a platform adapter in a lab before enabling provisioning.

## Ansible

Install the pinned collection:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
ansible-playbook --syntax-check ansible/playbooks/configure-linux.yml
ansible-playbook --syntax-check ansible/playbooks/configure-windows.yml
```

Populate inventory only with authorized lab hosts. Do not store passwords in inventory. For Windows, configure secure WinRM/PSRP and certificate validation according to your organization's standard.

## ServiceNow

Set SERVICENOW_INSTANCE_URL and SERVICENOW_TOKEN at runtime in a secret manager. Grant only the API permissions required for request retrieval and approved status/CMDB updates. Confirm the endpoint and table model with the ServiceNow administrator.
