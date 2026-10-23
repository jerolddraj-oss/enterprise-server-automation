#requires -RunAsAdministrator
#requires -Modules Hyper-V
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]{0,62}$')]
    [string]$VMName,
    [Parameter(Mandatory)]
    [string]$SwitchName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$VhdPath,
    [string]$IsoPath,
    [ValidateRange(2, 8)]
    [int]$StartupMemoryGB = 2,
    [ValidateRange(20, 256)]
    [int]$VhdSizeGB = 40,
    [ValidateSet(1, 2)]
    [int]$Generation = 2,
    [ValidateRange(1, 8)]
    [int]$ProcessorCount = 2,
    [ValidateRange(1, 32)]
    [int]$MinimumFreeHostMemoryGB = 3,
    [switch]$ConfirmLabProvisioning
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host 'Hyper-V lab VM creation - guarded mode' -ForegroundColor Cyan
Write-Host 'This creates a VM and an empty virtual disk; it does not install an operating system.'
Write-Host 'Do not use this script for production workloads.'

if (-not $ConfirmLabProvisioning) {
    throw 'Safety gate: review the parameters and rerun with -ConfirmLabProvisioning when ready.'
}
if (Get-VM -Name $VMName -ErrorAction SilentlyContinue) {
    throw "A VM named '$VMName' already exists. No changes were made."
}
$vmSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue
if (-not $vmSwitch) {
    $available = (Get-VMSwitch | Select-Object -ExpandProperty Name) -join ', '
    throw "Hyper-V switch '$SwitchName' was not found. Available switches: $available. No changes were made."
}
if ($IsoPath -and -not (Test-Path -LiteralPath $IsoPath -PathType Leaf)) {
    throw "ISO file '$IsoPath' does not exist. No changes were made."
}
$resolvedVhdPath = [System.IO.Path]::GetFullPath($VhdPath)
if (Test-Path -LiteralPath $resolvedVhdPath) {
    throw "VHD path '$resolvedVhdPath' already exists. Choose a new path; no changes were made."
}
$parentPath = Split-Path -Parent $resolvedVhdPath
if (-not (Test-Path -LiteralPath $parentPath -PathType Container)) {
    throw "VHD parent directory '$parentPath' does not exist. Create and verify it before running this script."
}

$os = Get-CimInstance -ClassName Win32_OperatingSystem
$freeMemoryGB = [math]::Round(($os.FreePhysicalMemory * 1KB) / 1GB, 2)
$requiredFreeGB = $StartupMemoryGB + $MinimumFreeHostMemoryGB
if ($freeMemoryGB -lt $requiredFreeGB) {
    throw ('Insufficient free host memory: {0} GB available; this configuration requires at least {1} GB free ({2} GB VM startup memory plus {3} GB host reserve). Close unused applications or safely shut down unneeded VMs, then check again.' -f $freeMemoryGB, $requiredFreeGB, $StartupMemoryGB, $MinimumFreeHostMemoryGB)
}

[PSCustomObject]@{
    VMName            = $VMName
    Generation        = $Generation
    Switch            = $vmSwitch.Name
    StartupMemoryGB   = $StartupMemoryGB
    ProcessorCount    = $ProcessorCount
    DynamicMemory     = $true
    VhdPath           = $resolvedVhdPath
    VhdSizeGB         = $VhdSizeGB
    IsoPath           = if ($IsoPath) { [System.IO.Path]::GetFullPath($IsoPath) } else { '(not supplied - no OS installer attached)' }
    HostFreeMemoryGB  = $freeMemoryGB
    MinimumFreeHostGB = $MinimumFreeHostMemoryGB
} | Format-List

if (-not $PSCmdlet.ShouldProcess($VMName, 'Create a new Hyper-V lab VM and empty VHDX')) {
    return
}

$createdVM = $false
try {
    New-VM -Name $VMName -Generation $Generation -MemoryStartupBytes ($StartupMemoryGB * 1GB) -NewVHDPath $resolvedVhdPath -NewVHDSizeBytes ($VhdSizeGB * 1GB) -SwitchName $vmSwitch.Name | Out-Null
    $createdVM = $true
    Set-VM -Name $VMName -DynamicMemory -AutomaticStartAction Nothing -AutomaticStopAction ShutDown
    Set-VMProcessor -VMName $VMName -Count $ProcessorCount

    if ($IsoPath) {
        $dvd = Get-VMDvdDrive -VMName $VMName -ErrorAction SilentlyContinue
        if ($dvd) {
            Set-VMDvdDrive -VMName $VMName -Path ([System.IO.Path]::GetFullPath($IsoPath))
        } else {
            Add-VMDvdDrive -VMName $VMName -Path ([System.IO.Path]::GetFullPath($IsoPath)) | Out-Null
        }
    }

    Write-Host "VM '$VMName' created successfully and remains powered off." -ForegroundColor Green
    Write-Host 'Review firmware and boot settings, then install the operating system manually.'
    Get-VM -Name $VMName |
        Select-Object Name, State, Generation,
            @{Name='StartupMemoryGB';Expression={[math]::Round((Get-VMMemory -VMName $_.Name).Startup / 1GB, 2)}},
            @{Name='DynamicMemory';Expression={(Get-VMMemory -VMName $_.Name).DynamicMemoryEnabled}} |
        Format-List
}
catch {
    Write-Error "VM creation failed: $($_.Exception.Message)"
    if ($createdVM) {
        Write-Warning "A VM may have been partially created. Inspect '$VMName' and '$resolvedVhdPath' manually before retrying. Resources are not deleted automatically."
    }
    throw
}
