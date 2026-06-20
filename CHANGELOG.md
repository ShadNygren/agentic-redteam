# Changelog

All notable changes to **Agentic Redteam™** are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Note: maintaining this changelog is good practice, not an Apache-2.0 requirement. Apache-2.0 §4(b) only
> requires modification notices when redistributing a *modified* upstream Apache work; this is an original work.

## [Unreleased]
### Added
- `redteam` reference `05-planning-scope-roe.md` — turning client objectives into scope, the full Rules-of-
  Engagement document anatomy, the four planning documents (engagement / operations / mission / remediation),
  threat-profile selection, the timestamped operator log, and planning/execution/culmination checklists.

### Changed
- `redteam` reporting reference (`03`) expanded with the scenario/scope (assumed-breach) section and a
  color-coded, legend-defined attack-diagram in the report structure.
- Smoke test now expects 6 redteam reference files.
- `pentest` recon reference (`01`, shared by both skills) substantially expanded: passive vs active framing
  (ATT&CK Reconnaissance TA0043), deeper DNS recon (dnsrecon/dnsdumpster/Netcraft/crt.sh), WAF/CDN detection
  (wafw00f), web-tech fingerprinting (whatweb/Wappalyzer/BuiltWith → version→CVE), subdomain enumeration
  (sublist3r/amass/fierce/knockpy + SecLists), search-engine dorking, automated frameworks (Amass/recon-ng/
  Sniper), and an active vulnerability-scanning subsection (NSE/nikto/wpscan/cmsmap/searchsploit). The `redteam`
  initial-access reference ties phishing target lists + spoofability back to recon outputs.

## [0.1.0] - 2026-06-20
Initial public release: an AI-augmented offensive-security toolkit — Kali Linux + Claude Code + two Claude Code
skills — packaged as a single runnable Docker image, with a deterministic, human-in-the-loop safety harness.

### Added
- **Docker image** built on `kalilinux/kali-last-release` (override to `kali-rolling`) with a configurable
  `TOOLSET` (default `kali-linux-headless`), Node.js 20, and the Claude Code CLI. `ANTHROPIC_API_KEY` is supplied
  at run time, never baked in; `/work` is the mounted engagement workspace.
- **`pentest` skill** — comprehensive, authorized vulnerability assessment, using progressive disclosure (a
  focused `SKILL.md` + a `references/` library): methodology & engagement, recon & enumeration, web-app testing,
  Active Directory / internal, exploitation & post-exploitation, and reporting. Grounded in PTES, NIST SP 800-115,
  OWASP WSTG, MITRE ATT&CK, and an OSCP/PEN-200 mindset.
- **`redteam` skill** — objective-driven adversary emulation + detection testing (distinct from `pentest`),
  reusing the pentest references for execution and adding its own library: adversary emulation & methodology
  (Cyber Kill Chain / Unified Kill Chain / ATT&CK, cadence), initial access & C2, OPSEC & detection testing,
  purple team & reporting, and a full ATT&CK Navigator workflow.
- **Scope guard** (`scope_check.sh`) in each skill — exact whole-line allow-list match against `/work/SCOPE.txt`;
  refuses any target when no scope file exists.
- **Authorization & scope templates** (`examples/AUTHORIZATION.md`, `examples/SCOPE.txt`) — the artifacts each
  skill requires under `/work` before it will act.
- **Methodology document** (`docs/PENETRATION_TESTING_WITH_KALI_LINUX_AND_CLAUDE_CODE.md`) — vendor-neutral
  write-up of the AI-augmented approach, guardrails, and compliance mapping (PCI/SOC 2/HIPAA/NIST).
- **Smoke test** (`tests/smoke-test.sh`) — verifies the image wires up Claude Code, Node, nmap, both skills, both
  reference libraries, and both scope guards (including refusal when no scope file is present).
- **CI** (`.github/workflows/docker-build.yml`) — builds the lean image and runs the smoke test on push/PR; a
  gated job can publish the full headless image to GHCR once enabled.
- **Project docs & licensing** — `README.md`, `SECURITY.md`, `NOTICE`, and the Apache-2.0 `LICENSE`
  (Copyright 2026 Shad Nygren / Virtual Hipster Corporation), with trademark disclaimers (not affiliated with
  OffSec or Anthropic).

### Security
- Hard safety model enforced by both skills: no action without written authorization, in-scope-only via the scope
  guard, human-in-the-loop gate before any exploitation / password attack / post-exploitation, tool-evidenced and
  reproducible findings only (no fabrication), and an egress-controlled / local-model option for regulated data.
  Red-team evasion is framed strictly as detection testing — exercised within Rules of Engagement and documented
  for the blue team, never covert intrusion.

[Unreleased]: https://github.com/ShadNygren/agentic-redteam/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/ShadNygren/agentic-redteam/releases/tag/v0.1.0
