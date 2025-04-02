<#
=============================================================================================
Name:           Install MS Exchange Server 2016 / 2019 CLI
Author:         Kirti Behera
Description:    This script helps to install Exchange Server in an Active Directory (AD) environment.
Version:        1.1
Website:        https://o365forum.blogspot.com/
                https://www.electrowander.in.net/

Script Highlights: 
~~~~~~~~~~~~~~~~~
A single script allows you to install Exchange Server seamlessly.  

For detailed execution: https://o365forum.blogspot.com/2025/04/ms-exchange-server-2016-2019-cli-method.html
=============================================================================================
#>

# Define the header text
$header = "Install Exchange Server 2016/2019 [On AD Server] – Features Script"

# Create a border line
$border = "*" * $header.Length

# Display the header with formatting
Write-Host $border -ForegroundColor Cyan
Write-Host $header -ForegroundColor Yellow
Write-Host $border -ForegroundColor Cyan

# Install required Windows Features for Exchange
Write-Host "Installing required Windows features for Exchange Server..." -ForegroundColor Green
Install-WindowsFeature Server-Media-Foundation

Install-WindowsFeature NET-Framework-45-Features, RSAT-ADDS, RPC-over-HTTP-proxy, `
RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, `
Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, `
Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, `
Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, `
Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, `
Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, `
Windows-Identity-Foundation -Restart

Write-Host "Windows Features installed. Restarting if required..." -ForegroundColor Green

# Prompt user to mount the Exchange ISO
Write-Host "Make sure to mount the Exchange ISO image before proceeding." -ForegroundColor Red
$cd = Read-Host "Enter the drive path where Exchange Server setup is located (e.g., E:\)"

# Validate that the setup file exists
if (-Not (Test-Path "$cd\Setup.exe")) {
    Write-Host "Error: Setup.exe not found in the specified path. Please check and try again." -ForegroundColor Red
    exit
}

# Run Exchange Setup for Schema Preparation
Write-Host "Preparing Exchange Schema..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOn /PrepareSchema  

# Run Exchange Setup for Active Directory Preparation
$org = Read-Host "Enter your Organization Name"
Write-Host "Preparing Active Directory for Exchange..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOn /PrepareAD /OrganizationName:"$org"

# Run Exchange Setup for Domain Preparation
$domain = Read-Host "Enter your Domain Name"
Write-Host "Preparing Domain for Exchange..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOn /PrepareDomain:"$domain"

# Install Exchange Server using CLI
Write-Host "Installing Microsoft Exchange Server..." -ForegroundColor Green

$roles = Read-Host "Enter the roles to install (e.g., MB for Mailbox, MT for Management Tools, Edge, etc.)"
$mode = Read-Host "Enter installation mode (Install, Upgrade, Uninstall)"

# Validate roles input
$validRoles = @("MB", "MT", "Edge", "CA", "HT")
$selectedRoles = $roles -split "," | ForEach-Object { $_.Trim() }

foreach ($role in $selectedRoles) {
    if ($role -notin $validRoles) {
        Write-Host "Invalid role detected: $role. Allowed roles: MB, MT, Edge, CA, HT." -ForegroundColor Red
        exit
    }
}

# Run Exchange Installation
Write-Host "Starting Exchange Server Installation..." -ForegroundColor Green
& "$cd\Setup.exe" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /mode:$mode /r:$roles

Write-Host "Exchange Server Installation Completed." -ForegroundColor Green


Write-Host "Thank you " -ForegroundColor Cyan
