# OPSEC & Detection Testing

The defining idea of red teaming: **stealth is a measurement, not a goal.** Every defense-evasion technique is
run as a **test case** — "does the blue team see this?" — and is **documented and deconflicted**, never hidden.
This is detection-testing for a defensive purpose, the standard practice of every legitimate red-team firm. This
reference is about *what to measure and how to frame it*, not a catalog of evasion recipes.

## Know the defender's playbook: MITRE D3FEND
**D3FEND** is MITRE's defensive counterpart to ATT&CK — a knowledge base of the **countermeasures** the blue team
deploys (tactics: Model, Harden, Detect, Isolate, Deceive, Evict, Restore). A red team should understand it for
two reasons:
- **Anticipate + evade the controls.** Knowing the likely D3FEND countermeasures for the TTPs you'll run lets you
  predict where you'll be detected/blocked and plan accordingly (and watch for **Deceive** — honeytokens/decoys
  are placed precisely to catch you; touching one is a giveaway).
- **The digital-artifact lens *is* the OPSEC model.** D3FEND links offense to defense through **digital
  artifacts** — every technique you run **produces artifacts** (a process spawn, a network connection, a modified
  code segment, a registry key) that defensive techniques **observe**. So "evasion" is really **minimizing or
  altering the artifacts you generate** for a given objective. Each artifact you produce is a detection
  opportunity you're testing — map your planned actions to the artifacts they create, and you've predicted the
  detection surface. (Pair with the detection-gap matrix in `ref 03`.)
- **Shared vocabulary** — reporting findings in D3FEND terms ("you lacked `Process Spawn Analysis`,"
  "`Network Traffic Analysis` caught the C2") lets red and blue speak precisely about coverage and gaps.

## Reframe: ATT&CK "Defense Evasion" as test cases
The MITRE ATT&CK **Defense Evasion (TA0005)** tactic is, for a red team, a checklist of **detection test cases**.
For each technique the actor would use, ask the operational question and record the answer:
- Did the EDR/AV detect or block it?
- Did it generate a log/alert in the SIEM?
- Did the SOC notice and respond, and how fast (time-to-detect / time-to-respond)?
Examples to test (emulate the *actor's* known TTPs, in scope): masquerading, disabling/tampering with logging or
security tools, living-off-the-land binaries (LOLBins), credential dumping detection, lateral-movement
detection, and exfil-channel detection. The value is the **answer**, not the bypass.

## Measure *response*, not just detection — and provoke it on purpose when needed
Detection is half the question; the other half is **did the blue team respond, and how fast?** Track the
defender's **MTTD** (mean time to detect) and **MTTR** (mean time to respond) for the techniques you ran — those
are the headline numbers the engagement exists to move, and they double as a read on the org's **IR maturity**
(do they have playbooks? do they actually action alerts? does the right exec get woken at 2 a.m. *only* when
warranted?).
- **If you sit undetected for a long time, surface presence deliberately to test response.** A real adversary
  stays silent; a *red team* whose goal is to test detection/response can — within RoE and deconfliction —
  trigger a **benign, non-destructive marker** (e.g. a harmless popup / a planted benign artifact) to see
  whether and how fast the SOC notices and responds. The giveaway that it's the red team, not a real attacker,
  is exactly that it's harmless (no data destroyed, no ransom) — which is why the white cell and operator log
  matter for deconfliction.
- **Assess IR maturity as a finding.** Whether the client even *has* documented IR playbooks, and whether they
  hold up under a real attack, is itself a deliverable — "trust but verify": don't take "we have a process" at
  face value; the engagement tests it.

## OPSEC levels — calibrate to the engagement
- **Loud (overt / purple-team):** act openly so the blue team can build/tune detections against known activity.
- **Realistic (typical red team):** behave like the emulated actor — reasonable stealth, normal-looking traffic,
  minimal footprint — to test detection under real conditions.
- **Maximum stealth:** only when the objective is specifically to test the upper bound of evasion; still fully
  logged and deconflicted.
Agree the level in the RoE. Higher stealth ≠ "better" — the right level is the one that answers the client's
detection question.

## What to instrument (so detection can be measured)
Coordinate with the white cell to ensure the relevant telemetry exists/being collected, so "we weren't detected"
means "the control failed," not "no one was looking":
- **Endpoint:** EDR/AV alerts, process creation (Sysmon/EDR), script-block logging, parent-child anomalies.
- **Network:** egress/proxy logs, DNS analytics, beaconing/periodicity detection, unusual destinations.
- **Identity:** auth logs, impossible-travel, Kerberos anomalies (roasting/ticket abuse), privileged-group changes.
- **Email:** gateway verdicts, user-reported phishing rate, click/execution telemetry.

## Detection opportunities along the kill chain (plan these as you go)
For each step you take, note the **detection opportunity** you create — this is the raw material of the report:
- Initial access → email/EDR/execution alerts.
- Discovery (`../pentest/references/03`) → unusual enumeration (SMB/LDAP sweeps, BloodHound collection).
- Credential access → LSASS access, DCSync, roasting requests.
- Lateral movement → remote-exec/admin-share usage, new logon types.
- C2/Exfil → beaconing periodicity, large/odd egress.
Each becomes a row in the detection-gap matrix (`ref 03`): technique → did we do it → was it logged → alerted →
responded.

## Honesty rules specific to detection-testing
- **Report misses *and* hits.** Crediting the blue team's detections is as important as exposing gaps.
- **Never claim "undetected" without confirming the telemetry was actually being collected and reviewed.**
  Distinguish "no control existed," "logged but no alert," and "alerted but no response" — they need different
  fixes.
- **No fabrication:** detection results come from real, deconflicted comparison of your operator log against the
  blue team's telemetry — not assumptions.
