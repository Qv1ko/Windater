#Requires -Version 5.1

function Write-Status {
    param(
        [string]$Message,
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Type = "Info"
    )
    $prefix = @{ Info = "[+]"; Success = "[OK]"; Warning = "[!]"; Error = "[X]" }[$Type]
    $color  = @{ Info = "Cyan"; Success = "Green"; Warning = "Yellow"; Error = "Red" }[$Type]
    Write-Host "$prefix $Message" -ForegroundColor $color
}

function Is-Administrator {
    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-WingetUpgrade {
    Write-Status "Upgrading packages..."
    try {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        $wingetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

        $choco = Get-Command choco -ErrorAction SilentlyContinue

        if ($winget -or (Test-Path $wingetPath)) {
            Write-Status "Using winget..."
            if ($winget) {
                winget upgrade -h --all --accept-source-agreements --include-unknown --force
            } else {
                & $wingetPath upgrade -h --all --accept-source-agreements --include-unknown --force
            }
        }
        elseif ($choco) {
            Write-Status "Using Chocolatey..."
            choco upgrade all -y
        }
        else {
            Write-Status "No package manager found. Install winget or Chocolatey." -Type Warning
            return
        }
        Write-Status "Packages upgraded" -Type Success
    }
    catch {
        Write-Status "Package upgrade error: $($_.Exception.Message)" -Type Error
    }
}

function Invoke-TempCleanup {
    Write-Status "Cleaning temporary files..."
    try {
        $userTemp   = "$env:USERPROFILE\AppData\Local\Temp"
        $windowsTemp = "C:\Windows\Temp"
        $cleaned = 0; $skipped = 0

        foreach ($tempPath in @($userTemp, $windowsTemp)) {
            if (Test-Path $tempPath) {
                Get-ChildItem -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
                        $cleaned++
                    }
                    catch { $skipped++ }
                }
            }
        }
        Write-Status "Cleanup: $cleaned removed, $skipped skipped (in use)" -Type Success
    }
    catch {
        Write-Status "Cleanup error: $($_.Exception.Message)" -Type Error
    }
}

function Invoke-Defragmentation {
    Write-Status "Defragmenting drive C:..."
    try {
        defrag /C /B /G /L /O
        Write-Status "Defragmentation completed" -Type Success
    }
    catch {
        Write-Status "Defragmentation error: $($_.Exception.Message)" -Type Error
    }
}

function Invoke-WindowsUpdate {
    Write-Status "Checking for Windows updates..."
    try {
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            Write-Status "Installing PSWindowsUpdate module..."
            Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
        }
        Import-Module PSWindowsUpdate
        Get-WindowsUpdate
        Install-WindowsUpdate -AcceptAll
        Write-Status "Windows updates completed" -Type Success
    }
    catch {
        Write-Status "Windows Update error: $($_.Exception.Message)" -Type Error
    }
}

function Invoke-Winfetch {
    Write-Status "Running winfetch..."
    try {
        $url     = "https://raw.githubusercontent.com/kiedtl/winfetch/master/winfetch.ps1"
        $content = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
        $content.Substring(1) | Invoke-Expression
        Write-Status "Winfetch completed" -Type Success
    }
    catch {
        Write-Status "Winfetch error: $($_.Exception.Message)" -Type Error
    }
}

if (-not (Is-Administrator)) {
    Write-Status "Administrator privileges required. Relaunching..." -Type Warning
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Host ""
Write-Status "Windater - Windows Maintenance Script"

$tasks = @(
    "Invoke-WingetUpgrade",
    "Invoke-TempCleanup",
    "Invoke-Defragmentation",
    "Invoke-WindowsUpdate",
    "Invoke-Winfetch"
)

foreach ($task in $tasks) {
    Write-Host ""
    & $task
}

Write-Host ""
Write-Status "Maintenance completed" -Type Success
Start-Sleep -Seconds 10
