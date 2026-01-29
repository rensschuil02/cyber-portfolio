---
title: 'Network Security Audit @ HvA Amsterdam'
date: '2026-01-15'
tags: ['Network Security', 'Penetration Testing', 'Security Audit']
layout: '../../layouts/MainLayout.astro'
---

# Network Security Audit @ HvA Amsterdam

**Date:** January 15, 2026  
**Duration:** 2 weeks  
**Scope:** Internal network infrastructure assessment

---

## Executive Summary

This report documents a comprehensive network security audit conducted on the HvA Amsterdam internal infrastructure. The assessment aimed to identify security vulnerabilities, misconfigurations, and potential attack vectors within the network perimeter.

### Key Findings

- **Critical:** 2 vulnerabilities identified
- **High:** 5 vulnerabilities identified  
- **Medium:** 8 vulnerabilities identified
- **Low:** 12 vulnerabilities identified

---

## Methodology

The audit followed a structured approach based on industry-standard penetration testing methodologies:

1. **Reconnaissance & Information Gathering**
2. **Network Scanning & Enumeration**
3. **Vulnerability Assessment**
4. **Traffic Analysis**
5. **Security Control Review**

---

## Tools Used

```bash
$ nmap -sV -sC -O target_network
$ wireshark -i eth0
$ netdiscover -r 192.168.1.0/24
$ nikto -h target_server
```

---

## Findings

### 1. Unencrypted Network Traffic

**Severity:** High  
**Description:** During packet capture analysis, cleartext credentials were transmitted over HTTP protocol.

**Evidence:**
```
POST /login HTTP/1.1
Host: internal-portal.hva.nl
Content-Type: application/x-www-form-urlencoded

username=admin&password=P@ssw0rd123
```

**Recommendation:** Implement TLS/SSL encryption for all web services. Enforce HTTPS-only policies.

---

### 2. Open Ports & Services

**Severity:** Medium  
**Description:** Multiple unnecessary services were found running on network devices.

| Port | Service | Risk Level |
|------|---------|------------|
| 21   | FTP     | High       |
| 23   | Telnet  | Critical   |
| 3389 | RDP     | Medium     |

**Recommendation:** Disable unused services and implement proper firewall rules.

---

### 3. Weak Network Segmentation

**Severity:** High  
**Description:** Student network had direct access to administrative VLAN, violating the principle of least privilege.

**Recommendation:** Implement proper VLAN segmentation and access control lists (ACLs).

---

## Traffic Analysis

Using Wireshark, we analyzed 48 hours of network traffic:

- **Total Packets:** 2,458,932
- **Suspicious Connections:** 127
- **Malware Callbacks:** 3 (flagged by IDS)
- **Port Scans Detected:** 15

---

## Remediation Plan

### Immediate Actions (Priority 1)
- [ ] Disable Telnet service on all devices
- [ ] Patch critical vulnerabilities (CVE-2025-XXXX)
- [ ] Implement network segmentation

### Short-term Actions (1-2 weeks)
- [ ] Deploy IDS/IPS solutions
- [ ] Configure SIEM for centralized logging
- [ ] Conduct security awareness training

### Long-term Actions (1-3 months)
- [ ] Implement Zero Trust Architecture
- [ ] Regular penetration testing schedule
- [ ] Security policy documentation

---

## Conclusion

The network audit revealed several security gaps that require immediate attention. While the overall security posture is moderate, implementing the recommended controls will significantly improve the defensive capabilities.

**Risk Rating:** Medium-High

---

## References

- NIST Cybersecurity Framework
- OWASP Testing Guide
- CIS Critical Security Controls

---

*Report prepared by: [Your Name]*  
*Cybersecurity Student @ HvA Amsterdam*
