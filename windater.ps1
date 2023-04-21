if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}
winget upgrade -h --all --accept-source-agreements --include-unknown --force
Remove-Item $env:USERPROFILE\AppData\Local\Temp\* -ErrorAction SilentlyContinue
Remove-Item C:\Windows\Temp\* -Force -ErrorAction SilentlyContinue
defrag /C /B /G /L /O
Install-Module -Name PSWindowsUpdate -Force
Get-WindowsUpdate; Install-WindowsUpdate -AcceptAll
cls; (Invoke-WebRequest "https://raw.githubusercontent.com/kiedtl/winfetch/master/winfetch.ps1" -UseBasicParsing).Content.Remove(0,1) | Invoke-Expression
Start-Sleep(10)
