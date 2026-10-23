# Operations runbook

## Before a provisioning run

- Confirm request approval and change window.
- Confirm request schema, naming, quota, IPAM, DNS, storage and target capacity.
- Confirm approved image/template and OS lifecycle support.
- Verify credentials are valid and scoped to the requested environment.
- Confirm the selected adapter has passed lab/UAT tests.

## Failure handling

1. Stop dependent stages after a non-recoverable error.
2. Preserve build logs and non-sensitive evidence.
3. Record the request ID, stage, platform correlation ID and error summary in the request/change.
4. Retry only known transient failures and ensure retries cannot create duplicates.
5. Do not delete resources automatically; inspect the recorded resource IDs and follow the approved recovery procedure.
6. Correct the defect, run regression tests, and re-run only after checking current resource state.

## Handover acceptance

- OS and hostname match request.
- Approved network and storage configuration are present.
- Domain membership and identity policy are correct when requested.
- Required patching, monitoring, backup and endpoint-security integrations are healthy.
- Compliance validation passes or has an approved exception.
- CMDB CI is reconciled and linked to the request/change.
- Application owner and operations team receive the completion summary.
