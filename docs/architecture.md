# Reference architecture

## Flow

1. ServiceNow stores the service request and approval state.
2. A secured webhook or scheduled poll passes a request identifier to Jenkins.
3. Jenkins fetches authoritative request data and validates it against the schema and policy.
4. A platform adapter provisions a VM or initiates a bare-metal imaging workflow.
5. Ansible and PowerShell apply the OS baseline and platform-specific configuration.
6. Integrations register DNS/IPAM, domain identity, patching, monitoring, backup and security controls.
7. Post-build tests validate the required state.
8. The integration updates the CMDB and records evidence against the request/change.

## Separation of concerns

- ServiceNow: approvals, workflow, change records and CMDB.
- Jenkins: orchestrates stages, credentials binding, gates and audit trail.
- Git: reviewed/version-controlled automation artifacts.
- Terraform / hypervisor APIs: resource provisioning.
- Ansible / PowerShell: operating-system and configuration management.
- Operations APIs: registration and lifecycle integration.

## Safe rollout

The repository validation workflow validates source artifacts only. The Jenkins pipeline defaults to validation-only; the provisioning path is deliberately blocked pending platform adapter implementation and review. Test in an isolated lab first.
