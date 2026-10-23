# UAT acceptance checklist

Test in an isolated lab with synthetic request data.

## Positive cases
- [ ] Valid approved request passes schema and authorization checks.
- [ ] VM is created from an approved template in the correct cluster/network/storage.
- [ ] OS configuration and hostname are applied.
- [ ] Domain join occurs only when requested and with a scoped credential.
- [ ] IPAM/DNS entries are verified.
- [ ] Patching, monitoring, backup and security agents are registered and healthy.
- [ ] Compliance checks and CMDB reconciliation pass.
- [ ] Completion details reference the request and change ID.

## Negative and resilience cases
- [ ] Pending/rejected request is blocked before any mutation.
- [ ] Malformed request and unknown fields are rejected.
- [ ] Duplicate request does not create a second resource.
- [ ] Insufficient cluster, IP, datastore or quota capacity fails safely.
- [ ] API timeout/throttling follows bounded retry rules.
- [ ] Failure after VM creation records resource identity and follows recovery workflow.
- [ ] Reboot/disconnection does not cause a duplicate build.
- [ ] Missing monitoring/backup/EDR registration blocks handover when required.
- [ ] Secrets are absent from Git, build logs, test reports and error messages.
- [ ] Validation-only pipeline cannot provision or change infrastructure.
