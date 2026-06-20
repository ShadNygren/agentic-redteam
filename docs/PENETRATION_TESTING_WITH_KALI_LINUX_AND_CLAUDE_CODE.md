# Penetration Testing with Kali Linux and Claude Code

*A documented methodology for AI-augmented penetration testing — Claude Code orchestrating a Kali Linux toolkit
through a hardened MCP server, wrapped in a deterministic harness with human-in-the-loop control so findings are
tool-evidenced and reproducible, never hallucinated.*

---

## 0. Why this document exists
Engagements often ask for "formal internal and external penetration testing." "Formal" is fuzzy, so this document
defines what it usually means and how Agentic Redteam delivers it with Kali Linux + Claude Code. It is both an
honesty artifact (it does not overstate the capability) and a capability plan (it describes a technical assessment
that can genuinely be delivered).

**What "formal" penetration testing usually means (so it can be scoped precisely):**
- **A recognized methodology, documented:** PTES, NIST SP 800-115, OWASP WSTG, OSSTMM — a structured, repeatable
  process with a written report an **auditor will accept** (not ad-hoc poking).
- **PCI DSS (Req. 11.4):** pen testing **at least annually and after significant change**, by a tester who is
  **organizationally independent and qualified** (PCI doesn't mandate one specific cert, but qualification +
  independence are required; internal testers must be independent of the team that built the system).
- **SOC 2 / HIPAA:** neither *mandates* a pen test or a specific certification, but **auditors expect one** as
  evidence for the vulnerability-management / monitoring controls and the HIPAA §164.308(a)(1) risk analysis.
- **"Qualified" tester:** often signaled by a cert — **OSCP** (hands-on, the gold standard), **GPEN**, **CEH**, **PNPT**.
- **Scope the sign-off, not just the test (note):** this methodology produces the **technical penetration test** plus
  an evidenced, **auditor-acceptable report**. Some compliance sign-offs — most notably a **PCI QSA-signed
  assessment** — additionally require a tester with a specific certification and/or organizational independence.
  Confirm those requirements during scoping and staff the engagement accordingly; AI-augmented testing complements,
  but does not by itself constitute, a certified attestation.

---

## 1. The approach in one paragraph
**Kali Linux now officially supports AI-driven penetration testing via a Kali MCP server** — so this isn't a bolt-on
hack, it's the platform's own direction. Agentic Redteam runs a **standard pen-testing methodology** (PTES / NIST
800-115) and uses **Claude Code as the orchestration layer** that drives a **Kali Linux toolkit** through that **MCP
(Model Context Protocol) server**. The AI accelerates recon, enumeration, output parsing, hypothesis generation, and
reporting; **a human approves every intrusive or destructive action**, and **every finding is validated against real
tool output** before it goes in the report. This directly counters the documented AI-pentest failure mode —
**"hallucinated compliance"** (models fabricating exploit output or pretending to follow safety rules) — with
deterministic validators and human review.

---

## 2. Architecture (AI-augmented Kali)
Kali Linux officially supports AI-driven testing; the reference stack is **Ollama (local LLM) + `mcp-kali-server`
(an MCP bridge, a Flask server on `127.0.0.1:5000` exposing tools like `nmap`, `gobuster`, `dirb`, `nikto`) + an MCP
client (`5ire`)**. The Agentic Redteam adaptation:

| Layer | Reference stack | Agentic Redteam build |
|---|---|---|
| **Toolkit** | Kali Linux + its tools | Kali Linux (VM/Docker), full toolset |
| **MCP bridge** | `mcp-kali-server` (Flask, localhost) | `mcp-kali-server` **hardened** (scope guard, allow-list, rate limits, audit log) |
| **Orchestrator (MCP client)** | `5ire` + Ollama | **Claude Code** (the orchestration harness) — or a local Ollama model when data must never leave |
| **Model** | local `llama3.1:8b` / `qwen3:4b` | **Claude (Bedrock or API) for capability; local model for regulated/no-egress data** |
| **Isolation** | sandboxed Docker (e.g., PentAGI) | Kali in an isolated VM/Docker; egress-controlled; scoped network |

**Two data-path modes (choose per engagement):**
- **Local-only (no data leaves):** Ollama + local model on the Kali box — for PCI/PHI/sensitive scopes that forbid
  cloud AI. Slower/less capable model, maximum confidentiality.
- **Cloud-AI with a sanctioned path:** Claude via **AWS Bedrock** (in-boundary) or the Anthropic API **with a written
  AI-use + data-handling agreement** — more capable, only where explicitly sanctioned in writing.

---

## 3. Methodology — phases, Kali tools, and how Claude Code augments each
Backbone = **PTES (7 phases)** mapped to **NIST SP 800-115 (Planning → Information Gathering → Vulnerability Analysis
→ Exploitation → Post-Testing)**, with **MITRE ATT&CK** for adversary emulation and **OWASP WSTG** for web apps.

### Phase 1 — Pre-engagement (Planning)
- **Deliverables:** signed **Authorization / "get-out-of-jail" letter**, **scope** (in-scope IPs/domains/apps,
  explicitly out-of-scope assets), **Rules of Engagement (RoE)** (testing windows, allowed techniques, no-DoS,
  data-handling, escalation contacts), NDA/MSA, success criteria.
- **AI augmentation:** Claude drafts the RoE/scope checklist and a test plan from the target environment description;
  **a human signs off.** *No scanning happens before written authorization — full stop.*

### Phase 2 — Reconnaissance / OSINT (Information Gathering)
- **Kali tools:** `nmap` (light), `theHarvester`, `recon-ng`, `amass`, `dnsenum`, `whois`, Shodan, `spiderfoot`.
- **AI augmentation:** Claude orchestrates passive recon, dedupes/structures the asset inventory, flags the juiciest
  attack surface, and **cross-checks every host against the in-scope list** before anything active runs.

### Phase 3 — Scanning & Enumeration
- **Kali tools:** `nmap` (service/version/NSE), `masscan`, `gobuster`/`dirb`/`ffuf` (web content), `nikto`, `enum4linux`,
  `smbclient`, `whatweb`; authenticated/unauthenticated vuln scans with **OpenVAS/Greenbone** or **Nessus**, `nuclei`.
- **AI augmentation:** Claude parses raw scan output into a structured services/findings table, correlates versions to
  CVEs, and proposes prioritized next steps. **Deterministic validator:** the AI may not assert a port/service/CVE the
  raw tool output doesn't actually show.

### Phase 4 — Vulnerability Analysis
- **Tools:** `nuclei`, OpenVAS/Nessus results, Exploit-DB / `searchsploit`, manual verification.
- **AI augmentation:** Claude triages scanner output, **removes false positives**, ranks by exploitability + business
  impact, and maps to **MITRE ATT&CK** techniques. A human confirms before exploitation.

### Phase 5 — Exploitation  *(human-in-the-loop GATE)*
- **Kali tools:** `metasploit`, `sqlmap`, **Burp Suite** (web), `hydra`/`medusa` (auth), `responder`, custom PoCs.
- **Control:** **every exploit attempt requires explicit human approval**; destructive/DoS techniques are off by RoE;
  actions are rate-limited and logged. The goal is **proof of impact**, not damage.
- **AI augmentation:** Claude suggests exploit paths and crafts/safens payloads; **the human pulls the trigger** and
  **the AI records only what actually happened** (real tool output as evidence) — never a fabricated shell.

### Phase 6 — Post-Exploitation
- **Kali tools:** `linpeas`/`winpeas` (privesc), `bloodhound`/`sharphound` (AD), `mimikatz` (lab/authorized only),
  lateral-movement tooling — **all scope-bounded.**
- **AI augmentation:** Claude maps the access graph and reachable impact; **stops at the scope boundary** and never
  exfiltrates real data (proof-of-access, not data theft). Cleanup of any artifacts is tracked.

### Phase 7 — Reporting  *(the auditor-facing deliverable)*
- **Contents:** executive summary; methodology + scope + RoE; findings with **CVSS severity**, reproducible
  steps/evidence (screenshots, tool output), business impact, and **prioritized remediation** (a "fixable roadmap,
  not a 200-finding PDF" principle); retest plan.
- **AI augmentation:** Claude drafts the report from validated findings; **every claim is traceable to evidence**; the
  human reviews and signs. This is where "grounded, not hallucinated" is non-negotiable.

---

## 4. AI guardrails (the differentiator + the documented risks)
Research is explicit that LLM pentest agents can **invent vulnerabilities, fabricate exploit output, and fall into
"hallucinated compliance."** A **deterministic harness** is the answer:
1. **Tool-evidenced findings only** — the AI cannot assert anything the underlying Kali tool didn't actually return;
   findings carry the raw evidence. (No fabricated shells, no invented CVEs.)
2. **Human-in-the-loop for all intrusive/destructive actions** — recon/enumeration can be AI-paced; exploitation is
   gated by explicit approval.
3. **Preflight scope checks** — every target is validated against the in-scope allow-list **before** any active action;
   out-of-scope is hard-blocked.
4. **Rate limits + a panic stop** — bounded request rates; a kill switch halts the run.
5. **Egress control / local-LLM option** — for data that can't leave, run the model locally (Ollama) on an isolated
   Kali box; otherwise a sanctioned Bedrock/API path with a written AI-use + data-handling agreement.
6. **Reproducibility** — every finding must be independently reproducible from the documented steps.

These guardrails apply a **secure-by-default** discipline — code-execution gated behind human approval, audit
logging, scope enforcement — to offensive security.

---

## 5. Safety, legal, and ethics (non-negotiable)
- **Never test without signed authorization + defined scope.** Unauthorized testing is illegal.
- **Stay in scope.** No out-of-scope assets, no third-party/shared infrastructure without their authorization.
- **Protect engagement data.** Proof-of-access, not exfiltration; secure handling/retention/destruction per the MSA/NDA.
- **No DoS / no production damage** unless explicitly authorized in the RoE; prefer non-disruptive techniques.
- **Responsible disclosure** of anything incidental; clean up artifacts; document everything.

---

## 6. Compliance mapping (what each framework wants)
| Framework | Pen-test requirement | Independence / qualification | How this methodology fits |
|---|---|---|---|
| **PCI DSS** | Annual + after significant change (Req. 11.4) | Organizationally independent + qualified tester | Produces the technical test + report; a **QSA-signed attestation**, where required, additionally needs an independent qualified assessor |
| **SOC 2** | Not mandated; expected as evidence | No specific cert mandated | Produces the test + evidence an auditor accepts |
| **HIPAA** | Risk analysis required; pen test is best practice | No mandate | Feeds the §164.308(a)(1) risk analysis the covered entity signs off |
| **NIST 800-115** | The gov standard methodology | — | Followed as the backbone |

**Certification & independence:** some frameworks or auditors require the tester to hold a specific certification
(e.g., **OSCP / GPEN / CEH**) or to be **organizationally independent** of the team that built the system. Establish
these requirements during pre-engagement scoping and staff the engagement to meet them. This methodology covers the
**technical assessment and the auditor-acceptable report**; it does not by itself constitute a certified attestation.

---

## Sources
- [Penetration Testing Methodology (2025) — DeepStrike](https://deepstrike.io/blog/penetration-testing-methodology)
- [OWASP Web Security Testing Guide — Penetration Testing Methodologies](https://owasp.org/www-project-web-security-testing-guide/v41/3-The_OWASP_Testing_Framework/1-Penetration_Testing_Methodologies)
- [NIST SP 800-115: Technical Guide to Security Testing — Software Secured](https://www.softwaresecured.com/post/nist-sp-800-115-and-penetration-testing)
- [NIST's Penetration Testing Recommendations — RSI Security](https://blog.rsisecurity.com/nists-penetration-testing-recommendations-explained/)
- [5 Penetration Testing Standards to Know — Sprocket Security](https://www.sprocketsecurity.com/blog/pentesting-standards-2025)
- [Kali Linux Enhances AI-driven Penetration Testing (Ollama, 5ire, mcp-kali-server) — Cyber Security News](https://cybersecuritynews.com/kali-linux-ai-driven-penetration-testing/)
- [PentAGI: Open-source autonomous AI penetration testing — Help Net Security](https://www.helpnetsecurity.com/2026/04/22/pentagi-autonomous-ai-penetration-testing/)
- [Autonomous AI Agents for Penetration Testing: A Complete Guide — Astra](https://www.getastra.com/blog/penetration-testing/autonomous-ai-agents-for-penetration-testing/)
- [How to Run AI-Assisted Pentesting Locally Without Leaking Client Data — DEV](https://dev.to/alanwest/how-to-run-ai-assisted-pentesting-locally-without-leaking-client-data-18ec)
- [HackSynth: LLM Agent for Autonomous Penetration Testing — arXiv](https://arxiv.org/pdf/2412.01778)
