# Purple Teaming & Reporting

The red-team deliverable is **not a vulnerability list — it's an honest account of whether a realistic adversary
could achieve the objective and, above all, what the blue team detected, missed, and how fast they responded.**
The report makes the defenders measurably better, and the engagement is repeated (typically quarterly or
semi-annually) to verify they actually improved.

## Purple teaming
Red + blue working **together** (vs. a covert red-only test). Modes:
- **Live purple team:** run a technique, watch the SOC's telemetry in real time, tune the detection, repeat.
  Fast detection-engineering loop; great for building coverage against specific ATT&CK techniques (pair with
  Atomic Red Team for discrete, repeatable test cases).
- **Debrief purple team:** run the red campaign covertly, then sit down with the blue team to walk the kill
  chain against their logs (deconfliction → detection-gap analysis).
Either way the goal is the same: convert the campaign into **new/tuned detections.**

## The detection-gap matrix (the core artifact)
Map every action you took to MITRE ATT&CK and grade the defense. One row per technique:

| ATT&CK ID | Technique | Did we execute it | Logged? | Alerted? | Responded? | Time-to-detect | Gap / recommendation |
|---|---|---|---|---|---|---|---|
| T1566.001 | Spearphishing attachment | yes | yes | no | no | — | No alert on macro execution; add EDR rule + user-report workflow |
| T1003 | Credential dumping | yes | yes | yes | yes | 6 min | Detection worked — credit the SOC; tune to cut TTR |

- Distinguish the failure modes — they need **different fixes:** *no control existed* vs *logged but no alert*
  vs *alerted but no response*.
- **Credit detections, not just gaps.** Telling the blue team what they caught is as valuable as what they missed.
- **Never mark "undetected" unless you confirmed the telemetry was actually being collected** (deconfliction
  log vs SIEM/EDR). No fabrication — results come from real comparison.

## MITRE ATT&CK Navigator — plan and report with it
The **ATT&CK Navigator** is the shared visual layer for both ends of the engagement:
- **Planning:** mark the techniques you intend to emulate (scoped to the threat actor) before the campaign.
- **Reporting:** color the same matrix by outcome (detected / partial / missed) and hand it to the blue team as
  a heat-map of their coverage. Because ATT&CK is the **common language** of red and blue, the Navigator export
  drops straight into the SOC's detection-engineering backlog.
- Track quarter-over-quarter Navigator layers to **show improvement over time** — the real point of a recurring
  red-team program.

## Report structure
1. **Executive summary** — was the objective achieved? overall detection/response posture? top 3 things to fix.
2. **Engagement overview** — objective(s), emulated threat actor, scope, RoE, dates, witting parties.
3. **Attack narrative** — the kill chain as a timeline/story (initial access → C2 → privesc → lateral → objective),
   each step tagged with its ATT&CK ID and the detection opportunity it created.
4. **Detection-gap matrix + ATT&CK Navigator layer** — the analysis above.
5. **Recommendations** — prioritized improvements to **detection & response** (new log sources, detections,
   playbooks, training, segmentation), plus any **exploited vulnerabilities** handed off in standard finding
   format (use `../pentest/references/05-reporting.md` for CVSS/reproduction/remediation per vuln).
6. **Appendices** — full operator log (timestamps), evidence, cleanup confirmation.

## Honesty, cadence & confidentiality
- **Report what actually happened** — both the accesses you achieved (with benign proof) and every detection
  the blue team scored. The trophy is a stronger blue team, not a clean sweep.
- **Recurring program:** red-team value compounds across quarters — each engagement should emulate **fresh
  TTPs** and measure whether prior gaps were closed.
- Treat the report and operator log as highly sensitive (it's a map of how to attack the org); deliver over an
  agreed secure channel; destroy working data per retention terms; never pair the client with specifics in any
  non-deliverable/public material.
