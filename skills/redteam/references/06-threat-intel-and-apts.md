# Threat Intelligence & APTs (for adversary emulation)

Adversary emulation means replicating a **specific real threat actor**, so you need to understand who they are,
how they're categorized and named, and how to consume the public intel that drives a realistic emulation. This
reference feeds **threat-profile selection** (`ref 05`), **TTP mapping in the ATT&CK Navigator** (`ref 04`), and
the **OPSEC level** you adopt (`ref 02`).

## What an APT is
An **Advanced Persistent Threat** is a highly skilled, well-resourced group — usually **state-sponsored or
financially motivated** — running **prolonged, targeted** campaigns (months to years) for strategic ends:
**espionage** (IP/state secrets), **sabotage** (disrupt critical systems), or **financial gain**. Three defining
characteristics:
- **Advanced** — sophisticated tradecraft, sometimes zero-days and custom-built malware (their own resource
  development + infrastructure).
- **Persistent** — long-term access while **evading detection** (stealth is intrinsic to staying persistent).
- **Targeted** — chosen high-value targets (governments, large corporations, critical infrastructure), not
  opportunistic.

**APT vs. traditional threat actor** (shapes how stealthy/patient your emulation must be):

| | APT | Traditional actor |
|---|---|---|
| Motivation | geopolitical / strategic / large-scale financial | opportunistic, quick gain/disruption |
| Sophistication | custom malware, multi-vector chains, zero-days | widely available tools, little custom |
| Scope/duration | prolonged, carefully planned campaigns | quick hits |
| Resources | nation-state / large-org backing (money + people) | limited |

## Categories of APT (with examples)
- **Financially motivated (FIN)** — e.g. **FIN6**, **FIN7**: target payment-card / monetizable data.
- **State-sponsored** — e.g. **APT28 / Fancy Bear** (Russian military intel, GRU), **APT29 / Cozy Bear** (Russian
  foreign intel, SVR): espionage, influence ops.
- **Hacktivist / ideologically aligned** — e.g. **Charming Kitten** (Iran): ideological/political agendas,
  sometimes overlapping state campaigns.
- **Cybercrime syndicates** — e.g. **Wizard Spider** (Conti ransomware): APT-like sophistication, financial motive.
- **Hybrid** — state sponsorship + criminal activity for funding (e.g. North Korean groups), hard to categorize.

## Naming conventions (one group, many names)
Different vendors name the same actor differently — **anchor on the MITRE ATT&CK Group ID** to disambiguate:
- **Mandiant** — the `APT#` convention (e.g. APT28, APT29). Widely adopted.
- **CrowdStrike** — animal-by-geography: **Bear = Russia**, **Panda = China**, **Kitten = Iran**,
  **Chollima = North Korea**, **Spider = cybercrime**; Middle East has used **Falcon**.
- **Dell SecureWorks** — metals (older: `TG-` "threat group"); **Palo Alto Unit 42** — constellations;
  **Microsoft** — the 2023 weather/typhoon taxonomy.
- Examples: **APT1 / Comment Crew** (China, PLA); **Lazarus Group / Hidden Cobra** (North Korea, under Chollima);
  **Rocket Kitten** (Iran); **Desert Falcon** (Middle East); **Unit 8200** (Israel, linked to Stuxnet analysis).

## Attribution (consume it; don't claim it)
Attributing a breach to an APT is **hard and often controversial**. Analysts combine **technical indicators**
(malware signatures, C2 infrastructure/domains), **behavioral patterns** (TTPs via ATT&CK), and **geopolitical
context** (who benefits). For emulation you **consume published attribution/intel** to pick and model an actor —
you are not performing attribution, so cite sources and avoid overclaiming.

## How to use this in an engagement
1. **Select the actor** by realism — a group known to target the client's **geography + industry** + the
   client's threat model (`ref 05` threat profile). FIN-style for a payments client; the relevant regional
   state actor for a government/critical-infra client.
2. **Pull their TTPs** into the ATT&CK Navigator (`ref 04`) as your emulation baseline; augment as needed.
3. **Calibrate OPSEC** to the actor's sophistication/stealth (`ref 02`) — emulating a stealthy APT means a
   quieter, more patient campaign than a smash-and-grab actor.
4. **Emulate fresh/current TTPs** each engagement so the blue team keeps learning (`ref 00` cadence).

## Resources
- **MITRE ATT&CK — Groups** (the canonical, ID-anchored actor catalog with techniques + software).
- **APT Groups and Operations** spreadsheet (`apt.threattracking.com`) — cross-vendor names by region, ops,
  toolsets, and CTI links.
- **APTnotes** and the **APT & CyberCriminal Campaign Collections** archive
  (`github.com/CyberMonitor/APT_CyberCriminal_Campagin_Collections` — a large year-by-year corpus of APT/crimeware
  reports + PDFs; note the upstream "Campagin" spelling); **aptmap / APT search**; **MISP / Malpedia** for malware
  + IOCs; vendor CTI (Mandiant, CrowdStrike, Trend Micro, etc.).
- **Microsoft threat-actor naming taxonomy** (2023) for the weather/typhoon mapping.
- For turning all this into an executable emulation plan, see `ref 07`.
