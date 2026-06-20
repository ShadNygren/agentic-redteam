# Planning, Scope, Rules of Engagement & the Operator Log

Red-team operations *look* ad-hoc because the scope is wide — but they are rigorously planned. Planning is where
you turn the client's objectives into a scope, a Rules-of-Engagement (RoE) contract, an execution plan, and the
logging discipline that makes the whole thing accountable. **Read this with `ref 00` during Phase 1.**

> **Great resource:** [redteam.guide](https://redteam.guide) (companion to *Red Team Development and Operations*)
> has free RoE, operator-log, and report templates plus planning/execution/culmination checklists. Use them as a
> baseline and adapt.

## 1. Objectives → scope (the synthesis with the client)
- **You sell the report, and the report must answer the client's questions.** Start from *why* they hired you —
  their objectives — and extrapolate the scope from them. This requires a back-and-forth **synthesis** with the
  client; misalignment here means a technically fine report that answers the wrong question (a failed engagement).
- Pin down exactly what in/out of scope means ("publicly exposed assets" → *which* domains/subdomains/APIs/IPs;
  what's explicitly off-limits). Get it in writing.
- **Engagement depth** flows from the objectives: a **full simulation** (long, stealthy, whole-org adversary
  emulation) vs an **extended pentest / standard red-team op**. Depth picks the methodology.

**Example client objectives (and what each implies):**
- *Identify system misconfigurations & network weaknesses* (often scoped to external/public-facing) → map + test the perimeter.
- *Determine the effectiveness of EDR* → exercise execution/defense-evasion TTPs and measure EDR detection.
- *Evaluate overall security posture & response* → SIEM/detection coverage, remediation, DMZ/internal segmentation.
- *Evaluate the impact of data exposure & exfiltration* → demonstrate (with benign markers) what a breach could reach.

## 2. The four planning documents
1. **Engagement plan** — technical requirements: concept of operations (conops), resource requirements, timelines.
2. **Operations plan** — the engagement plan in detail, with **roles & responsibilities per operator**.
3. **Mission plan** — the **execution** plan: who does what, which techniques/sub-techniques run, when, and which
   operator owns each (e.g. "Operator 1 owns privilege escalation, these ATT&CK techniques, no deviation").
4. **Remediation plan** — the post-operation phase: reporting & remediation.

## 3. Rules of Engagement (RoE)
The RoE establishes the responsibilities, relationships, and guidelines between the **red team, network owner,
system owner, and stakeholders**, and authorizes the work. It's a legal document — sign before any activity.

**The RoE body should contain:**
- The **methodology** used (typically MITRE ATT&CK as the shared nomenclature).
- A **high-level description of activity types** — the attack kill chain / TTPs — and their **sequence**.
- The **hardware/software/infrastructure** to be employed (e.g. C2 framework such as Cobalt Strike/Havoc, redirectors).
- A **deconfliction process** — how events/updates are communicated and how the client confirms "is this you?".
- **Roles & responsibilities** of each functional group / operator (who owns initial access, exfil, etc.).
- **Legal/compliance references** that bound what you can do (PCI DSS, HIPAA, SOX, etc.).
- A **legal-responsibility disclaimer** — mandatory reporting: anything threatening life/limb/eyesight is reported
  promptly to the POC; incidental discovery of serious crimes is reported to the appropriate authorities.

**Full RoE document anatomy (template sections):**
- Client name + date; **executive summary** + objectives; **signing disclaimer** (signatures = approval of the red
  team's authorities); **explicit restrictions**; **authorized target space** (= scope).
- **Definitions** — define *every* term (e.g. "stakeholders," "open network"); on signing, those definitions bind.
- **Scope** — systems/networks/assets in-scope; all software/hardware that are targets.
- **Responsibilities** of customer and red team; **update/communication cadence**.
- **Sensitive-information reporting** + **incidental-discovery** clauses; reporting **must not attribute activity
  to a named individual** (no PII — protects both client employees and red-team operators).
- **Not in support of** law enforcement / criminal investigation.
- **Cease-operation process** — suspend on detecting anomalies that could be a real intrusion, or on hitting
  unintended sensitive info, until reported.
- **Information-usage deconfliction** — real-world incident-reporting still runs; the client POC can call the red
  team POC to confirm whether observed activity is the test.
- **Deliverables + dates** — e.g. an engagement-summary presentation, and a written report within 30 days.
- **Ground rules** by domain — network ops, cloud ops, **physical engagement** (off-limits areas/rooms/buildings,
  no risk to life).
- **Resolution of issues / points of contact** — CIO rep, engagement director, trusted agent, white-cell lead,
  red-team lead, red-team technical lead, emergency contact.
- **Authorization & approval** — signatures from all parties.
- **Appendices** — target environment; POCs; **RT methodology** (tactics → techniques/sub-techniques); engagement
  objective; **threat profile** (next).

## 4. Threat profile (for adversary emulation)
Select the APT to emulate by **realism**: pick a group known to target the client's **geography *and* industry**
(e.g. a financial-sector actor that targets North America for a North-American financial client) — not a random
or geographically irrelevant group. State the TTPs you'll replicate; include the **ATT&CK Navigator layer**
(`ref 04`) as the visual. See `ref 00` for the kill-chain/ATT&CK framing.

## 5. The operator log (accountability)
Every operator keeps a **timestamped log of every action** — the backbone of deconfliction and the report
appendix. A simple spreadsheet works (don't let lack of commercial tooling stop you). Columns:
`start time` · `end time` · `source IP` · `destination IP` · `destination port` · `destination system/hostname` ·
`pivot IP` · `pivot port` · `URL` · `tool/app` · `command run` · `description/reason` · `output/result` ·
`system modification (y/n)` · `comments` · `operator name`.
This gives "who did what, when, and with what result" — match it against the blue team's telemetry during the
purple-team debrief (`ref 03`). Capture screenshots and system changes alongside it.

## 6. Checklists (run them, adapt them)
- **Development** (building the team): required knowledge/skills, roles & responsibilities, methodology, TTP guidance.
- **Engagement** (before you start): RoE signed, communication/deconfliction plan distributed, entry-point method,
  scope + goals/objectives, target restrictions/infrastructure, approvals, scenario/threat-profile development,
  operational-impact planning, threat-infrastructure acquisition.
- **Execution** (daily): every operator logging activity, screenshots + system changes captured, a daily/twice-daily
  internal SITREP, the real-time attack diagram kept current.
- **Culmination** (close-out): roll up data, **roll back any system changes**, validate evidence collected, finalize
  the attack diagram, technical review with the team, executive brief → draft narrative/findings → final report.
