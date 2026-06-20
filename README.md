# Agentic Redteam™

*AI-augmented penetration testing — built on Kali Linux, driven by Claude Code.*

**Copyright © 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License**

> ⚠️ **Authorized testing only.** This is offensive-security tooling. Use it solely against systems you
> own or have **explicit written permission** to test. See [`SECURITY.md`](SECURITY.md).

---

## What this is
A Docker image that packages **Kali Linux + Claude Code + two Claude Code skills** into a single, runnable,
AI-augmented offensive-security toolkit. Claude Code orchestrates the Kali toolset by following recognized
methodologies — **PTES / NIST SP 800-115 / OWASP WSTG / MITRE ATT&CK** — wrapped in a **deterministic harness
with human-in-the-loop control** so every finding is **tool-evidenced and reproducible, not hallucinated** (the
documented failure mode of AI pentesters), and written up as an **auditor-acceptable report**.

The two skills are distinct disciplines (use the right one):
- **`pentest`** — broad, comprehensive **vulnerability assessment**: find and verify as many issues as possible
  across a scope, with a prioritized remediation report.
- **`redteam`** — objective-driven **adversary emulation**: emulate a real threat actor (MITRE ATT&CK TTPs) to
  test the organization's **detection & response**, delivering an attack narrative + detection-gap analysis.

Because it ships as a **Docker image you run where the test needs to happen**, it covers **both**:
- **External** assessments (run it anywhere with reach to the target), and
- **Internal** assessments — deploy the container **inside the network** to answer "a guest joins our
  WiFi, what can they reach?" (a hosted web service can't do this; a container on the LAN can).

The full methodology is in [`docs/PENETRATION_TESTING_WITH_KALI_LINUX_AND_CLAUDE_CODE.md`](docs/PENETRATION_TESTING_WITH_KALI_LINUX_AND_CLAUDE_CODE.md).

## Quick start
```bash
# Build (default: kali-last-release base + kali-linux-headless CLI toolset)
docker build -t agentic-redteam .

# Run: mount a workspace (authorization/scope IN, report OUT), provide your Claude key.
# --network host (or a bridged target VLAN) is needed for INTERNAL testing.
docker run -it --rm \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -v "$(pwd)/work:/work" \
  --network host \
  agentic-redteam

# Inside the container:
#   1) put your signed scope at /work/AUTHORIZATION.md and targets (one per line) at /work/SCOPE.txt
#   2) run:  claude        # the `pentest` skill is preloaded and enforces the guardrails
```

### Build options
| Build arg | Default | Alternatives |
|---|---|---|
| `KALI_TAG` | `kali-last-release` (stable, reproducible) | `kali-rolling` (weekly, latest tools) |
| `TOOLSET` | `kali-linux-headless` (full CLI suite) | `kali-tools-top10` (lean), `kali-linux-large` (full desktop suite) |

```bash
docker build --build-arg KALI_TAG=kali-rolling --build-arg TOOLSET=kali-tools-top10 -t agentic-redteam:lean .
```

## Safety model (why this is trustworthy)
- **No action without written authorization + in-scope confirmation** (`scripts/scope_check.sh`).
- **Human-in-the-loop gate** before any exploitation / password attack / post-exploitation.
- **Tool-evidenced findings only** — no fabricated output, every finding reproducible.
- **Egress-controlled**; for regulated data you can swap Claude for a **local model** so nothing leaves.

## The skills
Both skills give the agent the depth of an experienced operator via **progressive disclosure**: a focused
`SKILL.md` entry point (hard rules + phase workflow) backed by a `references/` library it reads as each phase
demands. They share tooling and the same guardrails; the difference is goal and posture.

**[`pentest`](skills/pentest/SKILL.md)** — comprehensive assessment. References:
[methodology & engagement](skills/pentest/references/00-methodology-and-engagement.md),
[recon & enumeration](skills/pentest/references/01-recon-and-enumeration.md),
[web-app testing](skills/pentest/references/02-web-application-testing.md),
[Active Directory / internal](skills/pentest/references/03-active-directory-and-internal.md),
[exploitation & post-exploitation](skills/pentest/references/04-exploitation-and-post-exploitation.md),
[reporting](skills/pentest/references/05-reporting.md). Mindset: PTES / NIST SP 800-115 / OWASP WSTG / OSCP.

**[`redteam`](skills/redteam/SKILL.md)** — objective-driven adversary emulation + detection testing. Reuses the
pentest references for execution, and adds:
[adversary emulation & methodology](skills/redteam/references/00-adversary-emulation-and-methodology.md) (kill
chains, ATT&CK, cadence),
[initial access & C2](skills/redteam/references/01-initial-access-and-c2.md),
[OPSEC & detection testing](skills/redteam/references/02-opsec-and-detection-testing.md),
[purple team & reporting](skills/redteam/references/03-purple-team-and-reporting.md),
[ATT&CK Navigator](skills/redteam/references/04-attack-navigator.md),
[planning, scope & RoE](skills/redteam/references/05-planning-scope-roe.md),
[threat intel & APTs](skills/redteam/references/06-threat-intel-and-apts.md),
[adversary-emulation plan](skills/redteam/references/07-adversary-emulation-plan.md). All evasion is framed as
**detection testing** — exercised within RoE and documented for the blue team, never covert intrusion.

See [`SECURITY.md`](SECURITY.md) and the skills under [`skills/`](skills).

## Strategic foundation
Both skills are grounded in a shared doctrine:
[**The Strategy of Adversarial Co-Evolution**](docs/STRATEGY_OF_ADVERSARIAL_COEVOLUTION.md) (identical in the
[Agentic Blueteam](https://github.com/ShadNygren/agentic-blueteam) companion). When both sides know the playbook
(ATT&CK + D3FEND), *knowledge is only the floor* — victory is decided by **tempo, terrain, deception, and
adaptation velocity**. Red vs. blue is **positive-sum sparring** (*iron sharpens iron*; "shall we play a game?")
that makes the organization win the real battles, later, against the genuine adversary.

## Keeping current (living project)
New attacks are devised continuously, so defense must co-evolve. This project **continuously monitors
cybersecurity developments and integrates emerging tactics** — ATT&CK/D3FEND updates, CISA/NSA advisories,
community CTI, new research, and new attack surfaces (e.g. AI/LLM) — and evolves **in lockstep with the blue-team
companion**: a new offensive technique on one side begets the matching detection on the other. See the doctrine's
§12 and [`CHANGELOG.md`](CHANGELOG.md).

## Trademarks
**Agentic Redteam™** is a trademark of Shad Nygren / Virtual Hipster Corporation.
This project is **built on Kali Linux** and **driven by Claude Code** — it is **not affiliated with,
sponsored by, or endorsed by OffSec or Anthropic**. **Kali** and **Kali Linux** are trademarks of OffSec;
**Claude** and **Claude Code** are trademarks of Anthropic. All product names are used **descriptively**
to identify the underlying software; no logos are used.

## License
Code and documentation: **Apache License 2.0** — see [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE). The
bundled Kali tools, Claude Code, and other third-party software remain under their own respective licenses.

## Changelog
Notable changes are tracked in [`CHANGELOG.md`](CHANGELOG.md) ([Keep a Changelog](https://keepachangelog.com) +
[SemVer](https://semver.org)).
