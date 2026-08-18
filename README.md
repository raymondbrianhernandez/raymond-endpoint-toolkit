# Raymond Endpoint Toolkit

Portable Windows endpoint toolkit for diagnostics, repair, performance optimization, security auditing, incident response, and technician maintenance workflows.

**Current version:** `0.9.2-beta`

## Overview

Raymond Endpoint Toolkit is a self-contained Windows batch toolkit designed for endpoint technicians and IT troubleshooting. It combines common CMD utilities with embedded PowerShell reporting so a technician can launch diagnostics, repairs, audits, and maintenance tasks from one portable menu.

The toolkit automatically requests administrator privileges when launched and stores generated logs and reports in a `logs` folder beside the BAT file.

## Main capabilities

- **Network / Wi-Fi**
  - Full network HTML report
  - DHCP release / renew
  - DNS cache flush
  - TCP/IP and Winsock reset
  - Connectivity testing
  - Saved Wi-Fi profiles and password lookup
  - Current connection information
  - Windows WLAN report

- **Windows repair / hardware**
  - SFC
  - DISM CheckHealth, ScanHealth, and RestoreHealth
  - Hardware rescan
  - Driver report
  - Windows Update repair
  - User profile health
  - Windows shell repair
  - Registry diagnostics and repair center

- **Diagnostics / reporting**
  - System information
  - Disk and drive health
  - Running processes
  - System uptime
  - Battery report
  - BitLocker status
  - Full diagnostic HTML report
  - Deep audio diagnostics

- **Security / forensic auditing**
  - USB device security
  - Browser history
  - Network artifacts
  - Port and service exposure
  - Microsoft Defender maintenance and offline scan
  - Security configuration
  - Persistence and startup entries
  - Scheduled tasks
  - Windows services
  - Users and local administrators
  - Authentication and logon activity
  - Installed software security
  - Remote access software
  - Network security configuration
  - File integrity
  - Windows Update health
  - Crash and stability review
  - Incident response snapshot

- **Performance / optimization**
  - Performance analyzer
  - Safe optimization center
  - Power and sleep diagnostics
  - Startup performance analysis

- **Portable / maintenance**
  - Driver backup
  - WinGet application update center
  - Available-update reporting
  - Selected application updates
  - Update-all workflow with confirmation
  - WinGet source refresh

## Registry Diagnostic / Repair Center

The registry center is designed around a safer workflow: **inspect, back up, confirm, change, verify, and log**.

It includes registry health checks, key backup and restore, user profile auditing, Explorer and Start Menu policies, Windows Update policy inspection, network and proxy settings, startup entries, security policy checks, registry search, snapshot comparison, and direct access to Registry Editor.

The toolkit intentionally does **not** include a generic registry cleaner or automatic removal of arbitrary registry keys.

## Reports and logs

Generated reports are stored locally under:

```text
logs\
```

Many reports open automatically in the default browser and use HTML for easier review.

Reports may contain sensitive endpoint information such as usernames, computer names, IP addresses, browser artifacts, USB history, installed software, and security configuration. Review reports before sharing them publicly.

## Requirements

- Windows 10 or Windows 11
- Administrator privileges for many repair and audit functions
- Windows PowerShell 5.1 or newer
- WinGet / App Installer for the application update features
- Some reports depend on Windows components or hardware interfaces that may not be available on every system

## Running the toolkit

1. Download `Raymond-Endpoint-Toolkit.bat`.
2. Place it in a writable folder or on a writable USB drive.
3. Double-click the BAT file.
4. Approve the Windows administrator prompt.
5. Select a menu option.

No installation is required.

## Portable use

The toolkit determines its working directory from the BAT file location, so it can be run from removable media without depending on a fixed drive letter. Logs and reports are written beside the toolkit in its local `logs` directory.

Do not remove the USB drive while a report, scan, backup, or repair operation is running.

## Safety and scope

This project contains administrative, security-auditing, browser-artifact, registry, and incident-response functionality. Use it only on systems you own or are authorized to administer.

Repair operations that can modify Windows configuration require confirmation where appropriate. Audit/reporting functions are intended to distinguish findings that need review from confirmed faults rather than treating every unusual result as malicious or broken.

## Project status

This project is currently in **beta**. The menu and feature set are still being refined before the first stable `1.0.0` release.

## Author

**Raymond Hernandez**  
Endpoint / IT Infrastructure and Cybersecurity

## License

Licensed under the [MIT License](LICENSE).
