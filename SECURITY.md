# Security & Responsible Use

**Agentic Redteam™** is offensive-security tooling. With great tooling comes legal responsibility.

## Authorized testing only
- **Only test systems you own or have explicit, written authorization to test.** Unauthorized access to
  computer systems is illegal in virtually every jurisdiction (e.g., the U.S. Computer Fraud and Abuse Act
  and equivalents worldwide).
- Keep a **signed authorization** and a **defined scope** (`/work/AUTHORIZATION.md`, `/work/SCOPE.txt`).
  The bundled skill refuses to act without them.
- **Stay in scope.** Never touch out-of-scope, shared, or third-party infrastructure without that party's
  own authorization.
- **No destructive actions** (DoS, data destruction) and **no exfiltration of real data** — proof-of-access
  only — unless explicitly authorized in the Rules of Engagement.

## Built-in guardrails
- Scope allow-list enforcement (`skills/pentest/scripts/scope_check.sh`).
- Human-in-the-loop approval before exploitation / password attacks / post-exploitation.
- Tool-evidenced, reproducible findings only — no fabricated output.
- Egress control; a local-model option so sensitive data never leaves the box.

## Data handling
- Treat all engagement data as confidential per your NDA/MSA. Store evidence under `/work/evidence/`,
  reports under `/work/report/`, and **destroy** them per the engagement's retention terms.
- For regulated data (PCI/PHI), run with a **local model** (no cloud egress) or a sanctioned, documented
  data path.

## Reporting a vulnerability in this project
Found a security issue in **Agentic Redteam** itself (not in a target you're testing)? Please report it
privately to the maintainer rather than opening a public issue, and allow reasonable time to remediate
before disclosure.

## Disclaimer
This software is provided "as is," without warranty of any kind, under the Apache License 2.0. The authors
are not liable for misuse. **You** are responsible for using it lawfully and ethically.
