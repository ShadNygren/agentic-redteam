# OPSEC & Detection Testing

The defining idea of red teaming: **stealth is a measurement, not a goal.** Every defense-evasion technique is
run as a **test case** — "does the blue team see this?" — and is **documented and deconflicted**, never hidden.
This is detection-testing for a defensive purpose, the standard practice of every legitimate red-team firm. This
reference is about *what to measure and how to frame it*, not a catalog of evasion recipes.

## Reframe: ATT&CK "Defense Evasion" as test cases
The MITRE ATT&CK **Defense Evasion (TA0005)** tactic is, for a red team, a checklist of **detection test cases**.
For each technique the actor would use, ask the operational question and record the answer:
- Did the EDR/AV detect or block it?
- Did it generate a log/alert in the SIEM?
- Did the SOC notice and respond, and how fast (time-to-detect / time-to-respond)?
Examples to test (emulate the *actor's* known TTPs, in scope): masquerading, disabling/tampering with logging or
security tools, living-off-the-land binaries (LOLBins), credential dumping detection, lateral-movement
detection, and exfil-channel detection. The value is the **answer**, not the bypass.

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
