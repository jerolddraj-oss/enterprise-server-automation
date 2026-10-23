# Infrastructure integration contracts

Implement each integration as a small adapter with clear input/output types and bounded retries.

| Integration | Suggested implementation | Completion gate |
|---|---|---|
| VMware | PowerCLI / vSphere API | VM identity, template, network and guest readiness verified |
| SCVMM / Hyper-V | SCVMM and Hyper-V PowerShell cmdlets | VM state, virtual switch and guest reachability verified |
| HPE OneView / bare metal | Supported OneView API/module plus imaging platform | Hardware profile and OS deployment state verified |
| IPAM / DNS | Vendor API, DNS API or supported PowerShell cmdlets | Reserved address and forward/reverse lookup verified |
| Domain identity | Ansible / PowerShell with vault-provided credential | Domain and expected OU verified |
| SCCM / Satellite | Supported product APIs and agent deployment methods | Client registration and policy assignment healthy |
| Patching | SCCM / Satellite / enterprise patch system | Required baseline compliance checked |
| Monitoring / backup / EDR | Platform APIs or approved agent installation workflow | Agent registration plus healthy check-in verified |
| ServiceNow | REST APIs with least-privilege OAuth identity | Request, change and CMDB records reconciled |

## Adapter result contract

Each adapter should emit machine-readable, non-secret fields:
- `request_id`
- `platform`
- `resource_id`
- `hostname`
- `ip_address` (when allocated)
- `operation_status`
- `correlation_id`
- `error_code` and sanitized `error_summary` on failure

Do not return credentials, tokens, raw authorization headers, private configuration data, or full sensitive request bodies. Use a stable request ID as an idempotency key where the target platform supports it.
