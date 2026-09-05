param(
    [Parameter(Mandatory=$true)]
    [string]$PatchedDll,
    [string]$SDRangelPath = "C:\Program Files\SDRangel"
)

$ErrorActionPreference = "Stop"
$pluginDir = Join-Path $SDRangelPath "plugins"
$target = Join-Path $pluginDir "inputsdrplayv3.dll"

if (-not (Test-Path $PatchedDll)) { throw "Patched DLL not found: $PatchedDll" }
if (-not (Test-Path $target)) { throw "Original SDRangel plugin not found: $target" }

$proc = Get-Process -Name "SDRangel","SDRconnect" -ErrorAction SilentlyContinue
if ($proc) {
    Write-Host "Close SDRangel and SDRconnect before installing." -ForegroundColor Yellow
    throw "SDR software is still running."
}

$originalHash = (Get-FileHash $target -Algorithm SHA256).Hash.ToLower()
$expected = "c67b925562b2882dead2b553402122f740aa72b803aeb80fc62a7c8d89f2fca6"
Write-Host "Current plugin SHA256: $originalHash"
if ($originalHash -ne $expected) {
    Write-Warning "Your current DLL does not match the SDRangel 7.27.2 DLL that was reviewed. Installation can continue, but backup is especially important."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = Join-Path $pluginDir "RSP1B_backup_$stamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item $target (Join-Path $backupDir "inputsdrplayv3.dll") -Force

$pdbTarget = Join-Path $pluginDir "inputsdrplayv3.pdb"
if (Test-Path $pdbTarget) {
    Copy-Item $pdbTarget (Join-Path $backupDir "inputsdrplayv3.pdb") -Force
}

Copy-Item $PatchedDll $target -Force

$patchedPdb = Join-Path (Split-Path $PatchedDll -Parent) "inputsdrplayv3.pdb"
if (Test-Path $patchedPdb) {
    Copy-Item $patchedPdb $pdbTarget -Force
}

$newHash = (Get-FileHash $target -Algorithm SHA256).Hash
Write-Host ""
Write-Host "Installed patched inputsdrplayv3.dll successfully." -ForegroundColor Green
Write-Host "Backup: $backupDir"
Write-Host "New SHA256: $newHash"
Write-Host ""
Write-Host "Start SDRangel and test RSP1B. Keep SDRconnect closed during the test."
