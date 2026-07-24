# Windater

Windows maintenance automation script - updates applications, cleans temporary files, defragments drives and installs Windows updates.

![Windows 10](https://img.shields.io/badge/Windows-10-3AADEF?style=flat-square&logo=windows&logoColor=white)
![Windows 11](https://img.shields.io/badge/Windows-11-2C74D4?style=flat-square&logo=windows&logoColor=white)
![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1+-131E2A?style=flat-square&logo=powershell&logoColor=white)

### README language

- 🇪🇸 [Spanish](./README-es.md)
- 🇺🇸 **English**

## Features

| Function             | Description                                                                              |
| -------------------- | ---------------------------------------------------------------------------------------- |
| **Upgrade Packages** | Upgrades all installed packages via **winget** (**Chocolatey** if winget is unavailable) |
| **Clean Temp Files** | Removes temporary files from `%TEMP%` and `C:\Windows\Temp`                              |
| **Defragmentation**  | Optimizes drive C: using advanced defrag flags (`/C /B /G /L /O`)                        |
| **Windows Update**   | Installs the PSWindowsUpdate module (if missing) and applies all pending Windows updates |

## Requirements

- **PowerShell 5.1** or later
- **Administrator privileges** (the script auto-relaunches as admin if needed)
- **winget** or **Chocolatey** for package upgrades

## Installation

1. Clone the repository:
   ```shell
   git clone https://github.com/Qv1ko/Windater.git
   ```
2. Enter the Windater directory
3. Open PowerShell as Administrator and set the execution policy to allow local scripts:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Usage

Run the script in a PowerShell terminal as Administrator:

```powershell
.\windater.ps1
```
