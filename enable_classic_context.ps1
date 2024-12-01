# PowerShell script to toggle classic context menu on Windows 11

function Toggle-ClassicContextMenu {
    param (
        [switch]$Enable
    )

    $regPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
    $subKey = "InprocServer32"

    if ($Enable) {
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }

        if (-not (Test-Path "$regPath\$subKey")) {
            New-Item -Path "$regPath\$subKey" -Force | Out-Null
        }

        Set-ItemProperty -Path "$regPath\$subKey" -Name "(Default)" -Value "" -Force
        Write-Host "Classic context menu enabled. Restarting Explorer..." -ForegroundColor Green
    } else {
        if (Test-Path $regPath) {
            Remove-Item -Path $regPath -Recurse -Force
            Write-Host "Classic context menu disabled. Restarting Explorer..." -ForegroundColor Yellow
        } else {
            Write-Host "Classic context menu is already disabled." -ForegroundColor Cyan
        }
    }

    Stop-Process -Name "explorer" -Force
    Start-Process "explorer.exe"
}

$choice = Read-Host "Do you want to enable (Y) or disable (N) the classic context menu? (Y/N)"
if ($choice -match "^[Yy]") {
    Toggle-ClassicContextMenu -Enable
} elseif ($choice -match "^[Nn]") {
    Toggle-ClassicContextMenu -Enable:$false
} else {
    Write-Host "Invalid input. Exiting..." -ForegroundColor Red
}
