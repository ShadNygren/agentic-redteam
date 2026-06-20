# Adversary Emulation & Red-Team Methodology

A red team **emulates a real adversary against a defined objective to test detection and response.** It is not a
broader pentest — it's a narrower, deeper, stealthier, goal-oriented campaign whose true output is *how well the
organization's defenders did.*

## Red team vs penetration test (pick the right engagement)
| | Penetration test (`pentest` skill) | Red team (this skill) |
|---|---|---|
| Question | "What vulnerabilities exist?" | "Can an adversary achieve objective X, and is it detected?" |
| Scope | Broad, enumerate everything | Narrow, objective-driven, often whole-org |
| Stealth | Usually overt/noisy | Stealthy — footprint is a measurement |
| Blue team | Usually aware | Usually unwitting (that's the test) |
| Method | Methodology coverage (PTES/OWASP) | Threat-actor TTP emulation (MITRE ATT&CK) |
| Output | Vulnerability report + remediation | Attack narrative + **detection-gap analysis** |
| Duration | Days–weeks | Weeks–months campaign |

Related modes: **purple team** (red + blue collaborate live to build detections — see `ref 03`); **assumed
breach** (start with a foothold to focus on post-access detection rather than burning time on initial access).

> **Red team is NOT ad-hoc.** The wide scope makes it *look* chaotic, but every engagement follows a structured
> framework — for repeatability, accountability, and to stay inside the RoE. Pick a framework and work it.

## Frameworks & kill chains (the structured backbone)
- **Lockheed Martin Cyber Kill Chain** — the classic 7 linear stages, a good planning skeleton:
  **Reconnaissance → Weaponization → Delivery → Exploitation → Installation → Command & Control → Actions on
  Objectives.** (Weaponization = build the deliverable, e.g. a malicious document/payload; Delivery = email/web/
  USB; Installation = persistence/implant; Actions on Objectives = what the adversary ultimately wanted —
  ransomware/exfil/etc., where the **red team draws the line and stops with a benign proof**.)
- **Unified Kill Chain** — a more granular process model that merges the kill chain with ATT&CK phases; useful
  when a simple linear chain doesn't capture loops (regain access, pivot, repeat).
- **MITRE ATT&CK** — not a step-by-step methodology but the **framework** both red and blue adopt as a *common
  language*. It is **more comprehensive than the Cyber Kill Chain**: it adds Resource Development, Execution,
  Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, and detailed
  **post-exploitation** tactics the kill chain glosses over. ATT&CK's **Impact** tactic ≈ the kill chain's
  "Actions on Objectives." Use ATT&CK to plan TTPs and to speak the same language as the SOC in the report.
- **Pick + combine:** plan the campaign on a kill chain (narrative flow) and tag every action with an ATT&CK
  technique ID (so it maps to detections later — `ref 03`).

## Cadence & evolving TTPs (why it's a recurring program)
- Red-team operations are typically run **quarterly or twice a year** — not as a one-off. The value is the
  **trend**: does the blue team detect/respond better than last time, and were prior gaps closed?
- Each engagement should **emulate fresh / current TTPs** (new APT tradecraft) so the blue team keeps learning
  against an evolving threat landscape — not the same script every quarter.

## Objectives — design the "flags" first
A red team is defined by its objective(s), agreed with the client:
- Examples: "reach Domain Admin," "access the crown-jewel database," "obtain a benign marker file on the CFO's
  host," "demonstrate ability to disrupt process Y." Use **benign proof markers**, never real data/harm.
- Each objective implies a **kill chain** to plan and a set of **detection opportunities** to measure along it.

## Threat-intel-driven emulation (MITRE ATT&CK)
- Emulate a **specific, relevant threat actor** (or a representative profile) using public threat intel and
  **MITRE ATT&CK** — replicate their known **TTPs** (tactics → techniques → procedures), not random tradecraft.
  This makes the test realistic and the findings actionable for the SOC. **Choosing and modeling the actor:**
  see `ref 06` (APTs, categories, naming, attribution).
- Plan the campaign across the ATT&CK tactics: Reconnaissance → Resource Development → Initial Access →
  Execution → Persistence → Privilege Escalation → Defense Evasion → Credential Access → Discovery → Lateral
  Movement → Collection → Command & Control → Exfiltration → Impact. **Map every planned action to an ATT&CK
  technique ID up front** — that map becomes the detection-gap matrix later (`ref 03`).
- Resources: MITRE ATT&CK, the ATT&CK Navigator, MITRE Engenuity adversary-emulation plans, the Atomic Red
  Team test library (great for discrete, repeatable detection test cases in purple-team mode).

## Rules of Engagement — red-team specifics (beyond the pentest RoE)
Confirm these in writing before starting; they go beyond a standard pentest RoE:
- **Objective(s)** and the benign success markers.
- **Allowed initial-access vectors:** phishing? (which users — never personal accounts), exposed services,
  supplied foothold? Physical/social engineering in or out?
- **C2 egress rules:** allowed protocols/domains, redirector use, data caps; no real exfiltration.
- **Witting parties (the "white cell")** vs unwitting staff — who knows the test is happening.
- **Deconfliction:** a named contact + channel to instantly confirm "that alert is us, not a real attacker,"
  and a kill-switch to pause/stop. Maintain a **timestamped action log** the white cell can match to telemetry.
- **No-go list:** systems, data, and techniques that are off-limits regardless (e.g. anything risking safety,
  patient care, or production stability); **no DoS/destruction.**
- **Detection handling:** if you're caught, do you go quiet, escalate noise, or pause? Agree in advance.

## Operating principle
Footprint is data. Every action either stays under the radar (a detection gap to report) or trips a control (a
detection win to credit). Your job is to traverse the kill chain realistically and **truthfully record what the
defenders saw** — the engagement makes the blue team measurably better.
