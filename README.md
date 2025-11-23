# Windows Utils

A comprehensive collection of PowerShell utilities for Windows system administration and automation. Includes tools for DNS management, networking diagnostics, WiFi profile management, OneDrive synchronization, and file operations.

## Features

### 🔧 DNS Management
- **NRPT Rules**: Create and manage DNS split tunnels with Name Resolution Policy Table (NRPT) rules
- **DNS Configuration**: Set Cloudflare DNS, localhost DNS, or custom DNS servers per interface
- **DNS Diagnostics**: Diagnose DNS server order and performance across network interfaces
- **Privacy Protection**: Prevent DNS leakage on multi-homed devices using SMHNR controls

### 🌐 Networking
- **Active Connection Monitoring**: Track TCP connections with process information and public IP details
- **WiFi Management**: Extract and manage WiFi profiles with passwords

### 📁 File Management
- **Duplicate Detection**: Find and remove duplicate files with interactive cleanup
- **File Cleanup**: Automatically delete old temporary files and Office logs/traces
- **Bulk Moves**: Move large folder structures with progress tracking
- **File Validation**: Find files missing from backup/destination directories

### ☁️ OneDrive Automation
- **Sync Monitoring**: Track and display OneDrive synchronization queue
- **Online-Only Mode**: Convert files to online-only status for cloud-only storage
- **Migration Support**: Move folders to OneDrive with automatic sync verification
- **Deprovisioning Tracking**: Monitor file deprovisioning status

## Requirements

- **OS**: Windows 10/11 or Windows Server 2016+
- **PowerShell**: 5.1 or later (PowerShell 7+ recommended)
- **Permissions**: Administrator privileges required for most scripts
- **Python** (optional): For DNS performance testing, Python 3.6+ with `dnspython` package

## Installation

1. Clone or download this repository:
```powershell
git clone https://github.com/yourusername/windows-utils.git
cd windows-utils
```

2. (Optional) For DNS performance testing, install Python dependencies:
```bash
pip install dnspython
```

3. Allow script execution in PowerShell (if needed):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Quick Start

### DNS Examples

```powershell
# Check DNS server order by interface
.\networking\dns\Get-DnsOrder.ps1

# Set Cloudflare DNS on interface 6
.\networking\dns\Set-CloudFlareDns.ps1 -interface 6

# Set default DNS to custom nameservers (prevents DNS leakage)
.\networking\dns\nrpt\Replace-DefaultDnsClientNrptRule.ps1 -nameserver1 '10.66.66.1' -nameserver2 'fd42:42:42::1'

# Test DNS performance
python networking\dns\TestDnsPerf.py --dns-servers 1.1.1.1 8.8.8.8 --domains example.com google.com
```

### Networking Examples

```powershell
# List active TCP connections with public IP info
.\networking\Get-ActiveConnections.ps1

# Dump all WiFi profiles and passwords
.\networking\wifi\Get-WifiProfiles.ps1
```

### File Management Examples

```powershell
# Find duplicate files in a directory
.\file\Find-DuplicateFiles.ps1 -directory "C:\Users\Username\Documents"

# Delete temporary files older than 7 days
.\file\Delete-OldFiles.ps1 -path "C:\Temp" -days 7

# Move first 10 directories from source to destination
.\file\Move-PartialFolder.ps1 -source "C:\LargeFolder" -destination "D:\Backup" -numberOfFolders 10

# Find files in source not present in backup
.\file\Find-FilesNotInDirectory.ps1 -sourceDir "C:\Original" -searchDir "D:\Backup"
```

### OneDrive Examples

```powershell
# Monitor OneDrive sync queue
.\onedrive\Get-OneDriveSyncingQueue.ps1 -directory "C:\Users\Username\OneDrive" -wait 1000

# Convert all files in directory to online-only
.\onedrive\Set-OneDriveOnlineOnly.ps1 -directory "C:\Users\Username\OneDrive\Archive"

# Move folders to OneDrive with sync verification
.\onedrive\Move-PartialFolderToOneDrive.ps1 -source "D:\Documents" -destination "C:\Users\Username\OneDrive" -numberOfFolders 5 -wait 1000

# Touch (refresh) syncing files to unblock them
.\onedrive\Touch-OneDriveSyncingFiles.ps1 -directory "C:\Users\Username\OneDrive"
```

## Project Structure

```
windows-utils/
├── file/                           # File operations and management
│   ├── Delete-OfficeLogsAndTraces.ps1    # Remove Office cache and logs
│   ├── Delete-OldFiles.ps1               # Delete files older than N days
│   ├── Find-DuplicateFiles.ps1           # Find duplicate files by hash
│   ├── Find-FilesNotInDirectory.ps1      # Find missing backup files
│   ├── Move-PartialFolder.ps1            # Move N subdirectories
│   ├── Remove-Duplicates-finddupe.ps1    # Interactive duplicate removal
│   └── Schedule-TempFilesDelete.ps1      # Create scheduled cleanup task
├── networking/                     # Networking utilities
│   ├── Get-ActiveConnections.ps1         # Monitor TCP connections
│   ├── dns/                              # DNS management
│   │   ├── readme.md                     # DNS documentation
│   │   ├── Get-DnsOrder.ps1              # List DNS by interface priority
│   │   ├── Set-CloudFlareDns.ps1         # Set Cloudflare DNS
│   │   ├── Set-CloudFlareDns-ipv4.ps1    # IPv4 only Cloudflare DNS
│   │   ├── Set-LocalhostDns.ps1          # Set localhost as DNS
│   │   ├── TestDnsPerf.py                # DNS performance benchmark
│   │   └── nrpt/                         # NRPT (DNS split tunnel) rules
│   │       ├── RemoveAll-DnsClientNrptRule.ps1
│   │       ├── Replace-DefaultDnsClientNrptRule.ps1
│   │       ├── Replace-DnsClientNrptRule.ps1
│   │       ├── Replace-DnsClientNrptRuleForInterface.ps1
│   │       └── Replace-DnsClientNrptRuleForSuffix.ps1
│   └── wifi/                             # WiFi management
│       └── Get-WifiProfiles.ps1          # Extract WiFi profiles and passwords
├── onedrive/                       # OneDrive synchronization helpers
│   ├── Get-OneDriveDeprovisioningQueue.ps1
│   ├── Get-OneDriveSyncingQueue.ps1
│   ├── Move-PartialFolderToOneDrive.ps1
│   ├── Set-OneDriveOnlineOnly.ps1
│   └── Touch-OneDriveSyncingFiles.ps1
├── LICENSE
└── README.md
```

## Detailed Documentation

- **DNS Management**: See [DNS Documentation](./networking/dns/readme.md) for detailed NRPT rules, DNS privacy concerns, and advanced configuration examples

## Important Notes

### Security Warnings

⚠️ **WiFi Passwords**: The `Get-WifiProfiles.ps1` script displays WiFi passwords in plain text. Use with caution and only on machines you control.

⚠️ **NRPT Rules**: NRPT rules require administrator privileges and affect system-wide DNS resolution. Misconfiguration can break DNS functionality.

⚠️ **OneDrive Operations**: OneDrive scripts directly manipulate file attributes. Test with non-critical data first.

### DNS Privacy & SMHNR

Windows Smart Multi-Homed Name Resolution (SMHNR) can leak DNS queries to unexpected servers on multi-homed devices (laptops, VPNs). Refer to [SANS Whitepaper on SMHNR](https://www.sans.org/white-papers/40165/) for details. NRPT rules are the recommended mitigation.

## Common Use Cases

### Scenario 1: Pi-Hole + Cloudflare DNS Split Tunnel
```powershell
# Route local domain queries to Pi-Hole, everything else to Cloudflare
.\networking\dns\nrpt\Replace-DefaultDnsClientNrptRule.ps1 -nameserver1 '10.66.66.1' -nameserver2 'fd42:42:42::1'
.\networking\dns\nrpt\Replace-DnsClientNrptRule.ps1 -namespace '.local' -displayname 'local' -nameserver1 '192.168.1.100'
```

### Scenario 2: Backup Large Folder Structure
```powershell
# Move 50 folders at a time to external drive, scheduled
.\file\Move-PartialFolder.ps1 -source 'D:\BigFolder' -destination 'E:\Backup' -numberOfFolders 50
# Schedule with .\file\Schedule-TempFilesDelete.ps1
```

### Scenario 3: OneDrive Migration
```powershell
# Move files to OneDrive incrementally with sync verification
.\onedrive\Move-PartialFolderToOneDrive.ps1 -source 'D:\Documents' -destination "$env:USERPROFILE\OneDrive\Documents" -numberOfFolders 10 -wait 5000
```

## License

MIT License - See [LICENSE](./LICENSE) file for details.