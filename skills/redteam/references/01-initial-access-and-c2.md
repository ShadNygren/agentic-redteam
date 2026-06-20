# Initial Access & Command-and-Control

This covers how a red team *emulates* an adversary's entry and control phases — at the **operational/methodology
level**, to test whether the organization prevents, detects, and responds. Everything here is **RoE-gated,
human-approved, in-scope, and logged for deconfliction.** The deliverable is detection insight, not a covert
breach. (No malware development, no novel evasion recipes — emulate known TTPs and record what defenders see.)

## Initial access (MITRE ATT&CK: TA0001)
Emulate the actor's realistic entry vector — only those allowed by the RoE.
- **Phishing (T1566)** — the most common real-world entry. Tests people + email controls + EDR. Operational
  notes:
  - Only target **organizational accounts named in the RoE**; never personal accounts; coordinate with the
    white cell. Use a controlled phishing framework (e.g. **GoPhish**) and a benign tracking/payload approved in
    scope. A common APT pattern: the lure document is a **dropper/stager** — itself benign-looking, it calls
    back to C2 and pulls the next stage only after execution (tests email + execution + C2 detection).
  - Build the recipient list and pretext from **recon/target development** (`../pentest/references/01` —
    `theHarvester` emails/names, org-name OSINT); a **missing DMARC/DKIM** found in DNS recon makes domain
    spoofing viable and is itself a finding.
  - What you're measuring: do email gateways/users report it? does the payload execution alert EDR? does the
    SOC respond? Log send time, recipients, and lure so the blue team can correlate.
- **Exposed/external services (T1190, T1133)** — emulate exploitation of an internet-facing service or use of
  valid accounts (from OSINT/credential-stuffing of *test* accounts within RoE). Execution detail lives in
  `../pentest/references/02-web-application-testing.md` and `04-exploitation-and-post-exploitation.md`.
- **Supplied foothold (assumed breach)** — the client provides a beachhead so the engagement focuses on
  post-access detection. Often the highest-value design.
- **Removable media / physical / social** — only if explicitly in scope.

## Payload delivery & execution (TA0002)
- Use payloads to **test execution controls** (application allow-listing, EDR, macro policy, AV). Generation
  basics are in `../pentest/references/04-exploitation-and-post-exploitation.md` (msfvenom/Metasploit). The
  red-team angle: note **what blocked or alerted** — Defender/EDR quarantine, SmartScreen, ASR rules — because
  each is a detection/prevention data point, not an obstacle to defeat silently.
- Prefer **known, established frameworks** over bespoke tooling; emulate the *actor's* delivery technique.

## Command & Control (TA0011)
- **C2 frameworks** (use within scope/egress rules): Sliver, Mythic, PowerShell Empire, Metasploit, Havoc, and
  commercial Cobalt Strike. They provide beaconing, tasking, and session management.
- **OPSEC for realism + measurement** (all to test detection, all logged for deconfliction):
  - **Beacon cadence / jitter** — realistic call-back intervals; tests whether network analytics flag periodic
    beaconing.
  - **Channel choice** — HTTPS/DNS/known-good cloud fronting **only as permitted by RoE egress rules**; tests
    egress filtering and proxy inspection.
  - **Redirectors** — separate the team server from the listener the target sees; tests network attribution.
  - **Least footprint** — minimize hosts touched and actions taken; every extra action is another detection
    chance, recorded either way.
- **Persistence (TA0003)** — emulate the actor's persistence (scheduled tasks, services, run keys) **only if in
  scope**; it tests whether the blue team detects/hunts persistence. Track every mechanism for clean removal.

## Logging discipline (non-negotiable here)
Keep a **timestamped operator log** of every initial-access attempt, payload, C2 channel, and host touched.
During purple-team/deconfliction the blue team matches your log against their SIEM/EDR telemetry to compute the
detection-gap matrix (`ref 03`). If it isn't logged, it can't be credited or learned from.

## Cleanup
Remove implants, C2 artifacts, persistence, and any test accounts. Confirm removal and record it so admins can
verify. The environment must end as it began (plus a better detection posture).
