[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$RequestPath
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repoRoot 'python/validate_request.py'
if (-not (Test-Path -LiteralPath $RequestPath)) {
    throw "Request file not found: $RequestPath"
}
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    throw 'Python 3 is required to run the JSON schema validator.'
}
& python $validator $RequestPath
if ($LASTEXITCODE -ne 0) {
    throw "Request validation failed with exit code $LASTEXITCODE."
}
