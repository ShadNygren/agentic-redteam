# MITRE ATT&CK Navigator — Plan, Track, Report

The **ATT&CK Navigator** is the open-source tool that *operationalizes* the ATT&CK knowledge base — the shared
visual layer red and blue both use. Use it to (1) map a threat actor's TTPs, (2) plan/augment an emulation, (3)
track what you executed during the op, and (4) report a detection heat-map to the blue team. It is the single
most useful artifact for tying a red-team engagement to the SOC's detection work.

- Public instance: `mitre-attack.github.io/attack-navigator` (or **self-host** from MITRE's open-source repo for
  sensitive engagements — keep client annotations off a public tool).
- **Pin the ATT&CK version** (e.g. v14/v15) for the engagement and **tell the blue team which version** so the
  technique/sub-technique IDs line up exactly on both sides.

## Core concepts
- **Layer** = a custom view of the matrix (one campaign, one threat group, one platform). You can run many
  layers in parallel tabs and **combine** them (see below).
- **Annotations per technique/sub-technique:** color, **numeric score**, comment, link, metadata — and
  enable/disable cells. Scores drive color **gradients**, which is what makes it a heat-map.
- **Selection:** click to select (blue border); ctrl-click for multi-select; "select sub-techniques with parent"
  to grab a whole technique tree. **Search** matches techniques, sub-techniques, **groups**, and **software**
  (e.g. search software "Cobalt Strike" to highlight everything that tool can do).
- **Filters/layout:** filter by platform (Windows/Linux/macOS/Azure AD…), show technique IDs, show aggregate
  scores, flat/mini layouts.
- **Export:** **JSON** (re-importable — your durable layer format), **Excel**, **SVG/PNG** (drop into the report).

## Use case 1 — Map a threat actor's TTPs (start an emulation)
- From the ATT&CK website's **Group** page (e.g. APT29, APT41) → open/download that group's **Navigator layer**;
  it highlights every technique the group is known to use. Or, in Navigator: search → **threat groups** → pick
  the group → **select all** → apply a color. You now have the actor's TTP map as your emulation baseline.

## Use case 2 — Plan / augment the emulation plan
- Load the actor's layer as the **base** (e.g. APT29 in red). Then **ctrl-select the extra TTPs you want to add**
  and color them differently (e.g. orange) — orange = "TTPs we're adding on top of APT29." That two-color layer
  is your **augmented adversary-emulation plan**, clearly showing actor-derived vs. team-added techniques.
- For a from-scratch op (no specific actor): create an empty Enterprise layer, filter to the target platform,
  and select the techniques you intend to use per tactic (e.g. Initial Access = spearphishing attachment +
  exploit public-facing app; Execution = PowerShell via an Empire C2; Persistence = create domain/local
  accounts). That's your plan.

## Use case 3 — Track execution during the operation (success scoring)
- Keep the planned techniques selected; switch from manual color to a **scoring gradient** (Color Setup →
  preset **red→green**, low=0 high=3). Set every planned technique to **0 (red) = not yet executed**.
- As the op proceeds, raise the score on what you pulled off: **3 (green) = executed successfully**, **1
  (yellow) = partial / trouble** (e.g. "created local accounts = 3, domain accounts = 1"). The live layer now
  shows, at a glance, what worked.

## Use case 4 — Report a detection heat-map to the blue team
- Recolor for the **defender's** lens. A common convention: gradient **green→red**, **0 = red team did NOT
  succeed / was defended** (green), higher score = **red team executed it undetected/undefended** (red). The red
  cells are literally "here's where you need to improve." Hand the blue team the JSON + an SVG/Excel export; pair
  it with the detection-gap matrix in `references/03-purple-team-and-reporting.md`.
- Track **quarter-over-quarter** layers to show whether prior gaps closed — the point of a recurring program.

## Use case 5 — Combine layers (multi-APT heat-map / find common TTPs)
To emulate several actors or find the TTPs they share:
1. Build one layer per group (APT29, APT28, APT39…), each with the **same** gradient and a **score of 1** on its
   techniques. **Consistency across layers is essential** (same version, same gradient, same scoring).
2. New tab → **Create Layer from other layers** → set the **score expression** `a+b+c` (referencing the per-tab
   letters) and inherit one layer's gradient.
3. The combined layer's **cumulative score** reveals overlap: a technique used by only one group scores 1;
   shared by two scores 2; by all three scores 3 — so the **most common TTPs light up**. Use those high-overlap
   techniques to design a holistic, multi-actor emulation campaign.

## Tie-back
Every Navigator cell you touch should correspond to a row in the detection-gap matrix and a tagged step in the
attack narrative (`references/03`). Plan in the Navigator, execute against `../pentest/references/` tooling,
score as you go, and export the heat-map as the centerpiece of the blue-team debrief.
