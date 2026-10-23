# Terraform integration

Use this directory for environment-specific cloud provisioning modules once the target cloud, subscription/account, region, networking and state backend are agreed.

Before enabling a module:

1. Pin the Terraform CLI and provider versions.
2. Use a remote state backend with encryption, access control, locking and recovery.
3. Never commit state files, plan files, credentials or real environment secrets.
4. Separate development and production state and identity.
5. Validate with `terraform fmt -check` and `terraform validate`.
6. Require plan review and approval before applying to shared or production environments.

No deployable infrastructure module is included until the target environment and safe defaults are defined.
