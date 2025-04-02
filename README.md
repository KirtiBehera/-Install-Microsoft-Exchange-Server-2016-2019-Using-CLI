# 📌 Install Microsoft Exchange Server 2016 / 2019 Using CLI

---

## 🏆 Introduction

Microsoft Exchange Server is a popular email and calendaring solution for businesses. This guide provides a **PowerShell script** to install **Exchange Server 2016/2019** on an **Active Directory (AD) environment** using the **Command Line Interface (CLI)**. The script simplifies the installation process, automates the required feature installation, and ensures Exchange is properly configured.

🔹 **Supported Versions:** Exchange Server **2016 & 2019**  
🔹 **Supported Roles:** Mailbox (MB), Management Tools (MT), Edge, Client Access (CA), Hub Transport (HT)

---

## 📷 Screenshots

🔻 **Exchange Server Installation Script Running in PowerShell**

![PowerShell Script Execution](https://via.placeholder.com/800x400?text=PowerShell+Script+Execution)

🔻 **Exchange Server Installation Process**

![Exchange Installation](https://via.placeholder.com/800x400?text=Exchange+Server+Installation)

---

## 🎯 Features of This Script
✅ **Automates Installation** – Installs Exchange Server in a few steps  
✅ **Validates Inputs** – Ensures correct setup paths and roles  
✅ **Includes Required Windows Features** – Automatically installs dependencies  
✅ **Error Handling** – Prevents installation errors due to incorrect input  
✅ **Supports Multiple Roles** – Install Mailbox, Edge, etc.

---

## 🔥 Step-by-Step Guide to Install Exchange Server

### 🛠️ Step 1: Install Required Windows Features
Before installing Exchange Server, ensure that all necessary features are installed:

```powershell
Install-WindowsFeature Server-Media-Foundation
Install-WindowsFeature NET-Framework-45-Features, RSAT-ADDS, RPC-over-HTTP-proxy, `
RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, `
Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, `
Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, `
Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, `
Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, `
Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, `
Windows-Identity-Foundation -Restart
```

### 🛠️ Step 2: Run the Exchange Server Installation Script
Copy and save the following PowerShell script as **Install-Exchange.ps1**

```powershell
# Define the header text
$header = "Install Exchange Server 2016/2019 [On AD Server] – Features Script"
$border = "*" * $header.Length
Write-Host $border -ForegroundColor Cyan
Write-Host $header -ForegroundColor Yellow
Write-Host $border -ForegroundColor Cyan

# Prompt to mount Exchange ISO
Write-Host "Make sure to mount the Exchange ISO image before proceeding." -ForegroundColor Red
$cd = Read-Host "Enter the drive path where Exchange Server setup is located (e.g., E:\)"

if (-Not (Test-Path "$cd\Setup.exe")) {
    Write-Host "Error: Setup.exe not found in the specified path." -ForegroundColor Red
    exit
}

# Prepare Exchange Schema
Write-Host "Preparing Exchange Schema..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOn /PrepareSchema  

# Prepare Active Directory
$org = Read-Host "Enter your Organization Name"
Write-Host "Preparing Active Directory for Exchange..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOn /PrepareAD /OrganizationName:"$org"

# Prepare Domain
$domain = Read-Host "Enter your Domain Name"
Write-Host "Preparing Domain for Exchange..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOn /PrepareDomain:"$domain"

# Install Exchange Server
$roles = Read-Host "Enter the roles to install (e.g., MB, MT, Edge, etc.)"
$mode = Read-Host "Enter installation mode (Install, Upgrade, Uninstall)"

# Validate roles
$validRoles = @("MB", "MT", "Edge", "CA", "HT")
$selectedRoles = $roles -split "," | ForEach-Object { $_.Trim() }
foreach ($role in $selectedRoles) {
    if ($role -notin $validRoles) {
        Write-Host "Invalid role: $role. Allowed roles: MB, MT, Edge, CA, HT." -ForegroundColor Red
        exit
    }
}

# Run Installation
Write-Host "Starting Exchange Server Installation..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /mode:$mode /r:$roles
Write-Host "Exchange Server Installation Completed." -ForegroundColor Green
```

### 🛠️ Step 3: Execute the Script
To run the script:

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
./Install-Exchange.ps1
```

---

## 📜 Exchange Server Role Options
| **Role** | **Description** |
|---------|----------------|
| MB | Mailbox Role |
| MT | Management Tools |
| Edge | Edge Transport Role |
| CA | Client Access Role |
| HT | Hub Transport Role |

---

## 📌 Conclusion
By following this guide, you can **seamlessly install and configure Exchange Server 2016/2019** using PowerShell. This script ensures a smooth, automated setup process while eliminating manual errors. 🚀

For more **detailed execution steps**, visit:  
🔗 [MS Exchange Server 2016 / 2019 CLI Method](https://o365forum.blogspot.com/2025/04/ms-exchange-server-2016-2019-cli-method.html)

💡 **Do you have any questions? Drop a comment below!** ✨

---

## 🔗 Related Resources
🔹 [Microsoft Exchange Server Documentation](https://docs.microsoft.com/en-us/exchange/)  
🔹 [PowerShell Commands for Exchange](https://docs.microsoft.com/en-us/powershell/exchange/exchange-server/exchange-management-shell)

