$ErrorActionPreference = "Stop"
$root = "C:\Program Files\SDRangel"
$dll = Join-Path $root "plugins\inputsdrplayv3.dll"
$api = Join-Path $root "sdrplay_api.dll"

if (Test-Path $dll) {
    Write-Host "inputsdrplayv3.dll"
    Get-Item $dll | Select-Object FullName,Length,LastWriteTime
    Get-FileHash $dll -Algorithm SHA256
} else {
    Write-Warning "inputsdrplayv3.dll not found at $dll"
}

if (Test-Path $api) {
    Write-Host "`nsdrplay_api.dll"
    Get-Item $api | Select-Object FullName,Length,LastWriteTime
    Get-FileHash $api -Algorithm SHA256
} else {
    Write-Warning "sdrplay_api.dll not found at $api"
}

Write-Host "`nSDRplay API Service:"
Get-Service SDRplayAPIService -ErrorAction SilentlyContinue | Format-List Name,Status,StartType
