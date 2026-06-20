# Building an Adversary Emulation Plan

Adversary **emulation** is the heart of a serious red-team engagement: mimic a *specific, real* threat actor's
TTPs so the client gets a realistic read on how they'd fare against the adversaries that actually target them.
This reference is the end-to-end workflow — pick the actor, gather intel, map and *sequence* the TTPs, and turn
them into an executable plan. It builds on actor selection (`ref 06`), the ATT&CK Navigator (`ref 04`), and
planning/RoE (`ref 05`).

## Emulation vs. Simulation (know the difference)
- **Adversary Emulation** — replicate **one specific** threat actor's known TTPs/kill chain **as accurately as
  possible**, with little/no deviation. (Analogy: a console *emulator* striving for 1:1 fidelity.) **100% is
  almost never achievable** — you only have what's public; aim for the closest faithful reproduction.
- **Adversary Simulation** — adopt adversarial TTPs from one **or multiple** actors **as a basis**, then
  **augment** — combine the TTPs *shared across* several relevant groups (the multi-APT heat-map from `ref 04`)
  and/or add fresh TTPs from current CTI or your own toolkit. Deliberately deviates to be more comprehensive.
- **The line blurs, and that's fine** — what matters is knowing which you're doing: emulation = fidelity to *one*
  actor; simulation = an *augmented/combined* TTP set. State it in the plan.

## Why clients want emulation (vs. an "extended pentest")
- **Realistic, full kill chain** using techniques real actors use — not a broad-but-generic scope.
- **Tests the *Defenders*, not just the defenses** — the SOC's ability to **detect, respond, and escalate** (when
  does the analyst reach the CISO? is the timing appropriate?), i.e. readiness *and* resilience.
- **Holistic** — people, processes (communication/escalation), and technology, not just tooling.
- **Actionable + comparable** — report findings on the **ATT&CK Navigator** as a report card (detected = green,
  missed = red); compare quarter-over-quarter to show whether the blue team is improving.

## The emulation lifecycle (cyclic)
**Choose a technique → choose a test for it → execute the procedure → analyze detection of it → improve defenses
→ repeat.** Red owns the first three (choose/test/execute); blue owns analyze/improve. It's a *loop* — each round
can emulate a different actor, keeps the SOC sharp, and is exactly the purple-team cycle (`ref 03`).

## The plan-development workflow
### 1. Select the threat actor
If the client didn't name one, choose by:
- **Industry/sector** — does the actor target their vertical? **Geography** — does it target their region?
- **CTI availability — the single most important criterion.** You cannot realistically emulate a group you barely
  know. Favor an actor with rich public CTI over a perfect-but-opaque match.
- **Private/commercial CTI** — does the client have closed-source CTI or **IOCs from prior attacks** they want
  emulated? That's gold.
Sources to build the candidate list: the **ATT&CK Groups** page (search by industry/geo, e.g. "biotechnology",
"North America"), the **APT Groups & Operations** spreadsheet (origin/aliases), cross-referenced. Trim to the
actor that best fits the client's threat model *and* has enough intel to emulate.

### 2. Gather CTI on the chosen actor
ATT&CK group **references**; vendor reports (Mandiant/FireEye, CrowdStrike, Trend Micro, etc.); **APTnotes** and
the **APT & CyberCriminal Campaign Collections** archive — `github.com/CyberMonitor/APT_CyberCriminal_Campagin_Collections`
(a large, year-by-year corpus of APT/crimeware reports + PDFs; note the upstream "Campagin" spelling); **aptmap /
APT search**; **MISP / Malpedia** for malware + IOCs. (See also `ref 06` resources.)

### 3. Map the TTPs
Pull the group's **ATT&CK Navigator layer** (every cataloged group has one) — `ref 04`. This gives you the *set*
of techniques. It does **not** give you order.

### 4. Reconstruct the attack kill chain (the sequence ATT&CK omits)
The ATT&CK group layer lists *what* an actor does, **not what it does first or in what order** — the Enterprise
matrix has no temporal axis. To emulate faithfully, determine the actor's **typical path** (initial access →
discovery → privesc → lateral movement → C2 → collection → exfil) from **CTI write-ups of specific operations**.
Sometimes a clean diagram exists; often you build the **kill-chain diagram** yourself from multiple reports. With
2–3+ documented operations you can infer a reliable sequence.

### 5. Convert TTPs into the plan
A plan should include most/all **post-compromise** tactics (and **initial access** if in scope; **assumed-breach**
lets you start after it). Key realities:
- **Adversary behavior is cyclical, not linear.** Discovery / credential access / collection recur on *most*
  machines, each often followed by more lateral movement. Expect tactics (e.g. Discovery) to **repeat** at
  multiple phases.
- **Technique varies by target type** — local enumeration on a workstation differs from a domain controller; the
  same actor uses different sub-techniques in different parts of the path.
- **Deviation is acceptable.** Not every cataloged technique fits the path neatly — fit what fits, and **leave out**
  a technique that doesn't fit logically.
- **Make concessions on hard/illegal-to-replicate tradecraft.** Complex C2 infrastructure (custom domains, CDN
  fronting) need not be reproduced 1:1 — emulate the **known TTPs**, approximate the infrastructure within RoE
  (`ref 01`), and document the concession.

## Why accurate emulation is hard (set client expectations)
1. **Not all TTPs are public** — especially new groups; you may know their initial access but not persistence/
   privesc. A partial picture isn't enough for faithful emulation.
2. **Some activity is difficult or illegal to emulate** — make documented concessions.
3. **Public intel is assembled over time** from disclosed breaches and attributed after the fact.
4. **Actors are fluid** — tooling and tradecraft evolve per target; fold in the **latest CTI** so you're current
   (most change is in tooling).
5. **No order in the matrix** — reconstruct sequence from CTI (step 4).

## Manual vs. automated execution
- **Manual** — develop the payloads, malicious documents, and toolkit yourself; run the exploitation tailored to
  the environments the actor targets. Highest fidelity, most effort.
- **Automated** — frameworks like **CALDERA**, **Atomic Red Team**, and the **MITRE Engenuity adversary-emulation
  plans** run mapped techniques on demand (great for repeatable, purple-team validation — `ref 03`).
Typical progression: emulate a simpler actor (e.g. **FIN6**) first, then an advanced one (e.g. **APT29**), and
build both a manual and an automated plan where useful.

## Resources
MITRE **ATT&CK** + **Navigator** + **Groups**; **APT Groups & Operations** spreadsheet; **APTnotes**;
**APT & CyberCriminal Campaign Collections** (`github.com/CyberMonitor/APT_CyberCriminal_Campagin_Collections`);
**aptmap/APT search**; **MISP/Malpedia**; vendor CTI; MITRE **ATT&CK Defender** adversary-emulation labs;
**CALDERA**/**Atomic Red Team**/**Engenuity** emulation plans.
