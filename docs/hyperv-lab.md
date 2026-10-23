# Hyper-V laptop lab guide

This guide adapts the server automation starter to a small Windows 10/11 Pro Hyper-V host. The first milestone is guarded VM creation and verification; OS installation, domain join, agents, and end-to-end orchestration come later.

## Resource profile and safety

A 16 GB host with only about 3 GB free should not start additional 4 GB guests. Close unused applications or safely shut down workloads that are not needed, then re-check memory. Do not stop or reconfigure business appliances such as an existing 3CX VM just to make room.

Collect host and VM details in elevated PowerShell:

    Get-CimInstance Win32_ComputerSystem |
        Select-Object @{Name='RAM_GB';Expression={[math]::Round($_.TotalPhysicalMemory / 1GB, 2)}},
                      NumberOfLogicalProcessors, Model

    Get-CimInstance Win32_OperatingSystem |
        Select-Object @{Name='FreeMemory_GB';Expression={[math]::Round($_.FreePhysicalMemory / 1MB, 2)}}

    Get-VM | ForEach-Object {
        $vm = $_
        $memory = Get-VMMemory -VMName $vm.Name
        $processor = Get-VMProcessor -VMName $vm.Name
        $network = Get-VMNetworkAdapter -VMName $vm.Name
        [PSCustomObject]@{
            Name = $vm.Name
            State = $vm.State
            Generation = $vm.Generation
            StartupMemoryGB = [math]::Round($memory.Startup / 1GB, 2)
            DynamicMemory = $memory.DynamicMemoryEnabled
            vCPU = $processor.Count
            Switch = ($network.SwitchName -join ', ')
            VHDs = ((Get-VMHardDiskDrive -VMName $vm.Name).Path -join '; ')
        }
    } | Format-List

    Get-VMSwitch | Format-Table Name, SwitchType, NetAdapterInterfaceDescription -AutoSize

## Network safety

- Preserve existing switches, the physical LAN bridge, VPN interface, and Default Switch until their dependencies are understood.
- An Internal switch allows host-to-guest communication but does not provide internet access by itself.
- Use an isolated lab switch for test workloads where possible. Do not bridge the lab to a corporate network or change VPN routes without a separate reviewed plan.
- The script requires an existing switch by name; it does not create or alter switches.

## Create a test VM

Run from an elevated PowerShell session on the Hyper-V host. The script checks for an explicit confirmation flag, a non-existing VM name and VHD path, an existing switch, optional ISO path validity, and sufficient free RAM. It defaults to 2 GB startup memory and requires 3 GB of additional free host memory as a reserve. Adjust these values only after checking actual host capacity.

First preview the command with WhatIf:

    .\powershell\New-LabVM.ps1 -VMName 'LAB-UBUNTU01' -SwitchName 'Hyper-V' -VhdPath 'D:\Hyper-V\LAB-UBUNTU01\LAB-UBUNTU01.vhdx' -StartupMemoryGB 2 -VhdSizeGB 40 -ProcessorCount 2 -ConfirmLabProvisioning -WhatIf

The parent directory for the VHD must already exist. The script does not automatically create directories, download ISOs, install an operating system, start the VM, configure static IPs, or join a domain.

After reviewing the preview and ensuring adequate free memory, run the same command without WhatIf. If you have a trusted local ISO, add -IsoPath 'D:\ISOs\your-installer.iso'. Verify the ISO source and checksum independently. The VM remains powered off after creation.

## Verify the VM

    .\powershell\Get-LabVMStatus.ps1
    .\powershell\Get-LabVMStatus.ps1 -VMName 'LAB-UBUNTU01'

## Next milestones

1. Verify VM creation and status report.
2. Install a supported guest OS manually from trusted installation media.
3. Confirm guest connectivity on the isolated lab network.
4. Configure an approved host-side execution mechanism for Jenkins; a Jenkins guest cannot manage the Hyper-V host automatically without one.
5. Add tested, least-privilege guest configuration, domain join, monitoring, backup and security adapters.
6. Keep Jenkins in validation-only mode until the Hyper-V adapter has been reviewed and tested.

## Safety boundaries

- These scripts are for a lab, not production provisioning.
- Do not commit passwords, tokens, private keys or real inventory secrets.
- Do not grant a general-purpose Jenkins controller unrestricted local administrator access to the Hyper-V host.
- Never trust a caller-provided approval flag in place of authoritative ServiceNow/change approval.
- The VM creation script intentionally does not delete partial resources automatically after a failure.
