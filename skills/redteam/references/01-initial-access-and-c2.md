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

## Command & Control — setup (TA0011)
C2 is how you task the foothold and is one of the richest detection surfaces. Set it up to **emulate the actor
realistically and measure what the defenders see** — every choice is a test case, all logged for deconfliction.

**Frameworks** (use within scope/egress rules): Sliver, Mythic, PowerShell Empire, Metasploit, Havoc, and
commercial Cobalt Strike. They provide listeners, payload/stager generation, beaconing, tasking, and session
management.

**Architecture (set it up in this order):**
1. **Team server** — the operator-side C2 controller, on disposable, dedicated infrastructure (cloud VM). Never
   the box the target talks to directly. Lock it down (firewall to operator IPs, TLS).
2. **Listener / channel** — what the implant calls back on. Pick per the **RoE egress rules**: **HTTPS** (blends
   with web traffic, tests proxy/TLS inspection), **DNS** (tests DNS egress/analytics), or domain/CDN fronting
   where permitted. Use a **valid TLS cert** (e.g. Let's Encrypt) and an aged/categorized domain for realism.
3. **Redirector** — a lightweight relay (e.g. nginx/socat/HTTP) between the target and the team server, so the
   target only ever sees the redirector. Protects/obscures the team server and **tests network attribution**;
   burn and replace redirectors, not the team server.
4. **Payload / implant** — generate from the framework; **stager** (small, pulls the stage from the listener)
   vs **stageless** (self-contained). Match the *actor's* delivery (see Payload delivery above; reverse vs bind
   and staged vs stageless are explained in `../pentest/references/04-exploitation-and-post-exploitation.md`).
5. **Beacon back** — confirm the implant checks in, then task it.

**Beacon OPSEC (realism + measurement):**
- **Sleep + jitter** — realistic call-back interval with randomized jitter; tests whether network analytics flag
  periodic beaconing. **Kill date** so no implant outlives the engagement window.
- **Malleable / traffic profiles** — shape C2 traffic to look like normal/known-good services where the framework
  supports it; tests signature/heuristic network detection.
- **Least footprint** — minimize hosts touched and actions taken; every extra action is another detection chance,
  recorded either way.

**Internal / peer-to-peer C2 (post-foothold):** for hosts with **no direct egress**, chain them via a
**peer-to-peer channel** (e.g. an **SMB named-pipe** beacon) through an already-controlled host that does have
egress — tests lateral-C2 / named-pipe detection. Pivoting/routing details: `../pentest/references/04`.

**Infrastructure hygiene:** dedicated, disposable infra per engagement; don't reuse domains/IPs across clients;
tear everything down at close-out. Record all C2 domains/IPs/channels in the operator log for deconfliction.

**Persistence (TA0003)** — emulate the actor's persistence (scheduled tasks, services, run keys) **only if in
scope**; it tests whether the blue team detects/hunts persistence. Track every mechanism for clean removal.

## Logging discipline (non-negotiable here)
Keep a **timestamped operator log** of every initial-access attempt, payload, C2 channel, and host touched.
During purple-team/deconfliction the blue team matches your log against their SIEM/EDR telemetry to compute the
detection-gap matrix (`ref 03`). If it isn't logged, it can't be credited or learned from.

## Cleanup
Remove implants, C2 artifacts, persistence, and any test accounts. Confirm removal and record it so admins can
verify. The environment must end as it began (plus a better detection posture).
