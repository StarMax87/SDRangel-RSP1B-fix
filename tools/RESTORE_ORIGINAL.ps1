param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFolder,
    [string]$SDRangelPath = "C:\Program Files\SDRangel"
)

$ErrorActionPreference = "Stop"
$pluginDir = Join-Path $SDRangelPath "plugins"
$backupDll = Join-Path $BackupFolder "inputsdrplayv3.dll"
if (-not (Test-Path $backupDll)) { throw "Backup DLL not found: $backupDll" }

$proc = Get-Process -Name "SDRangel","SDRconnect" -ErrorAction SilentlyContinue
if ($proc) { throw "Close SDRangel and SDRconnect first." }

Copy-Item $backupDll (Join-Path $pluginDir "inputsdrplayv3.dll") -Force
$backupPdb = Join-Path $BackupFolder "inputsdrplayv3.pdb"
if (Test-Path $backupPdb) {
    Copy-Item $backupPdb (Join-Path $pluginDir "inputsdrplayv3.pdb") -Force
}
Write-Host "Original plugin restored." -ForegroundColor Green
