/**
 * Single source of truth for the portfolio taxonomy.
 *
 * Write-up frontmatter, listing pages, filter routes and badges all read from
 * here — adding a category or tool never touches more than one file.
 */

export interface Category {
  id: string;
  label: string;
  /** Terminal ornament rendered next to category headings */
  command: string;
  description: string;
  /** Tailwind classes backing the category chip */
  chipClass: string;
}

export const CATEGORIES: readonly Category[] = [
  {
    id: 'defensive-ops',
    label: 'Defensive Operations',
    command: 'splunk search index=main',
    description:
      'SIEM engineering (Splunk), log analysis, detection rules and incident response simulations.',
    chipClass: 'text-term-amber border-term-amber/40',
  },
  {
    id: 'assessment',
    label: 'Security Assessments',
    command: 'nmap -sV -sC -p- <target>',
    description:
      'Infrastructure auditing and penetration testing with Nmap, Wireshark and Metasploit.',
    chipClass: 'text-term-cyan border-term-cyan/40',
  },
  {
    id: 'web-security',
    label: 'Web Security',
    command: 'sqlmap -u <url> --batch',
    description:
      'Discovering and remediating OWASP Top 10 vulnerabilities, from injection to full system takeover.',
    chipClass: 'text-term-red border-term-red/40',
  },
  {
    id: 'hardening',
    label: 'System Hardening',
    command: 'sudo ufw limit ssh',
    description:
      'HSTS, CSP and secure network segmentation — shrinking attack surfaces before attackers find them.',
    chipClass: 'text-term-green border-term-green/40',
  },
  {
    id: 'networking',
    label: 'Network Security',
    command: 'tcpdump -i eth0 -nn',
    description:
      'Protocol-level analysis, traffic monitoring and secure network design.',
    chipClass: 'text-term-cyan border-term-cyan/40',
  },
  {
    id: 'malware',
    label: 'Malware Analysis · RE',
    command: 'ghidra --open-proj',
    description:
      'Static and behavioral analysis of software internals, including educational reverse engineering.',
    chipClass: 'text-term-amber border-term-amber/40',
  },
] as const satisfies readonly Category[];

export const CATEGORY_IDS = ['defensive-ops', 'assessment', 'web-security', 'hardening', 'networking', 'malware'] as const;
export type CategoryId = (typeof CATEGORY_IDS)[number];

export const DIFFICULTIES = ['beginner', 'intermediate', 'advanced'] as const;
export type Difficulty = (typeof DIFFICULTIES)[number];

/** Tools referenced in write-ups. Extend freely — the enum just picks it up. */
export const TOOL_IDS = [
  'splunk',
  'nmap',
  'wireshark',
  'metasploit',
  'burp',
  'gobuster',
  'sqlmap',
  'responder',
  'mitm6',
  'ntlmrelayx',
  'hashcat',
  'bepinex',
  'ghidra',
] as const;
export type ToolId = (typeof TOOL_IDS)[number];

export const TOOLS: Record<ToolId, string> = {
  splunk: 'Splunk',
  nmap: 'Nmap',
  wireshark: 'Wireshark',
  metasploit: 'Metasploit',
  burp: 'Burp Suite',
  gobuster: 'Gobuster',
  sqlmap: 'SQLMap',
  responder: 'Responder',
  mitm6: 'MITM6',
  ntlmrelayx: 'impacket ntlmrelayx',
  hashcat: 'Hashcat',
  bepinex: 'BepInEx',
  ghidra: 'Ghidra',
};

/** Resolves a category id to its definition; throws loudly on drift. */
export function getCategory(id: string): Category {
  const found = CATEGORIES.find((category) => category.id === id);
  if (!found) throw new Error(`Unknown category id: ${id}`);
  return found;
}

/** Resolves a tool id to its display label; throws loudly on drift. */
export function getToolLabel(id: string): string {
  const found = TOOLS[id as ToolId];
  if (!found) throw new Error(`Unknown tool id: ${id}`);
  return found;
}
