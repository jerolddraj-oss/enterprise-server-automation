# Jenkins credentials and agent setup

Use the Jenkins Credentials store or an approved external secret manager. Naming examples below are conventions only; create only the credentials needed by the chosen adapter.

- `servicenow-api-token`: scoped API token if using the ServiceNow adapter.
- `vmware-service-account`: service identity stored as a username/password or vault reference.
- `domain-join-credential`: delegated account restricted to the required OU.
- `ipam-api-token`, `monitoring-api-token`, `backup-api-token`: individual narrowly scoped credentials.

Do not use one administrator credential for all integrations. Avoid exposing secrets in command-line arguments, environment dumps, debug logging or artifacts. Prefer short-lived identities, service principals, OAuth, certificates, or vault-issued credentials where supported.

The Jenkins agent labelled `infra-automation` should have only the tools required by its workloads. Separate untrusted validation jobs from privileged deployment agents. Production environments should have protected approvals and network access restrictions.
