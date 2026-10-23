# PowerShell adapters

PowerShell scripts in this directory should implement platform-specific adapters and follow these rules:

- Accept a request ID or validated request object, not arbitrary shell code.
- Check approval, idempotency, naming rules, capacity and allowed templates before mutation.
- Retrieve secrets from Jenkins credentials or an approved vault. Never log secrets.
- Use `-ErrorAction Stop`, structured output, and meaningful non-zero exit codes.
- Record resource identifiers so retries do not create duplicate VMs.
- Validate postconditions and do not treat a successful API call as proof of readiness.
- Keep destructive cleanup disabled unless an explicit, reviewed policy allows it.

Implement platform adapters only after confirming module/API versions and lab access. No production credentials or environment-specific values belong in this repository.
