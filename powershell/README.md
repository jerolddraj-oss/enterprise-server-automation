# PowerShell adapters

PowerShell scripts in this directory should implement platform-specific adapters and follow these rules:

- Accept a request ID or validated request object, not arbitrary shell code.
- Check approval, idempotency, naming rules, capacity and allowed templates before mutation.
- Retrieve secrets from Jenkins credentials or an approved vault. Never log secrets.
- Use ErrorAction Stop, structured output, and meaningful non-zero exit codes.
- Record resource identifiers so retries do not create duplicate VMs.
- Validate postconditions and do not treat a successful API call as proof of readiness.
- Keep destructive cleanup disabled unless an explicit, reviewed policy allows it.
- Never grant a general-purpose Jenkins controller unrestricted host administrator access.

## Hyper-V lab scripts

### New-LabVM.ps1

Guarded lab-only VM creation on the local Hyper-V host. Requires elevated PowerShell and the Hyper-V module. It checks the selected switch, VM name, VHD path, optional ISO, and available host memory. It creates a VM and empty VHDX, optionally attaches an ISO, configures dynamic memory, and leaves the VM powered off.

It does not install an operating system, configure IP addressing, join a domain, or automatically delete partial resources after a failure. The VHD parent directory must already exist. Review the host-specific instructions in docs/hyperv-lab.md before use.

Preview example:

    .\powershell\New-LabVM.ps1 -VMName 'LAB-UBUNTU01' -SwitchName 'Hyper-V' -VhdPath 'D:\Hyper-V\LAB-UBUNTU01\LAB-UBUNTU01.vhdx' -StartupMemoryGB 2 -VhdSizeGB 40 -ProcessorCount 2 -ConfirmLabProvisioning -WhatIf

The script has an additional explicit confirmation flag and a free-memory reserve. It is expected to refuse creation when host memory is insufficient.

### Get-LabVMStatus.ps1

Read-only inventory report for VM state, generation, startup memory, dynamic memory, vCPU count, connected switch names and virtual disk paths:

    .\powershell\Get-LabVMStatus.ps1
    .\powershell\Get-LabVMStatus.ps1 -VMName 'LAB-UBUNTU01'

## Implementation rules

Implement platform adapters only after confirming module/API versions and lab access. No production credentials or environment-specific values belong in this repository. The current scripts are for manual lab validation and are not wired into the Jenkins provisioning stage.
