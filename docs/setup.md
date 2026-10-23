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

The sample request is intentionally marked `pending`; validation checks schema and approval state, so the CLI exits with status 2 until the example is changed to an approved state in a copy. This is expected and prevents pending requests from being treated as authorized.

## Jenkins

1. Create an agent labelled `infra-automation` with Git, Python 3 and required Ansible tools installed.
2. Create a Pipeline job from this repository and point it to `jenkins/Jenkinsfile`.
3. Keep `ACTION=validate-only` initially.
4. Configure approved credentials through Jenkins Credentials or a vault. Never define secrets as parameters or commit them.
5. Implement and test a specific platform adapter in a lab before enabling any provisioning stage.

## Ansible

Install supported Ansible and the Windows collection where needed:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
ansible-playbook --syntax-check ansible/playbooks/configure-linux.yml
ansible-playbook --syntax-check ansible/playbooks/configure-windows.yml
```

Populate inventory only with authorized lab hosts. Do not store passwords in inventory. For Windows, configure secure WinRM/PSRP and certificate validation according to your organization's standard.

## ServiceNow

Set `SERVICENOW_INSTANCE_URL` and `SERVICENOW_TOKEN` at runtime in a secret manager. Grant only the API permissions required for request retrieval and approved status/CMDB updates. Confirm the endpoint/table model with the ServiceNow administrator.
