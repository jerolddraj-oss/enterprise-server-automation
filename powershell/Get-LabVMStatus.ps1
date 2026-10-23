#requires -RunAsAdministrator
#requires -Modules Hyper-V
[CmdletBinding()]
param([string]$VMName)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$vms = if ($VMName) { Get-VM -Name $VMName } else { Get-VM }
$report = foreach ($vm in $vms) {
    $memory = Get-VMMemory -VMName $vm.Name
    $processor = Get-VMProcessor -VMName $vm.Name
    $adapters = @(Get-VMNetworkAdapter -VMName $vm.Name)
    $disks = @(Get-VMHardDiskDrive -VMName $vm.Name)
    [PSCustomObject]@{
        Name            = $vm.Name
        State           = $vm.State
        Generation      = $vm.Generation
        StartupMemoryGB = [math]::Round($memory.Startup / 1GB, 2)
        DynamicMemory   = $memory.DynamicMemoryEnabled
        vCPU            = $processor.Count
        Switches        = (($adapters | ForEach-Object { if ($_.SwitchName) { $_.SwitchName } else { '(not connected)' } }) -join ', ')
        VHDs            = (($disks | ForEach-Object { $_.Path }) -join '; ')
    }
}
$report | Format-Table -AutoSize
