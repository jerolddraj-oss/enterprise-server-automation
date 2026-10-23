# Security and change controls

- Deny by default; only allow supported OS, platform, sizing and network-zone combinations.
- Retrieve approvals from the authoritative request system; never trust an input parameter claiming approval.
- Use least-privilege, short-lived identities where supported.
- Store secrets outside Git. Mask secrets and avoid logging request payloads that may contain sensitive data.
- Pin dependencies and review updates; scan for leaked credentials and vulnerable dependencies.
- Require pull-request review for production automation.
- Use protected environments and explicit approval for production changes.
- Restrict Jenkins agents' network egress and access to administrative APIs.
- Make create/update operations idempotent and use request IDs as correlation keys.
- Log request ID, change ID, Git revision, build number, resource IDs, stage results and validation evidence.
- Define timeouts, bounded retries, rollback/cleanup behavior and manual recovery paths.
- Never automatically delete a provisioned server on failure without a separate, reviewed cleanup policy.
- Apply organization-approved security baselines; examples in this repository are not a compliance certification.
