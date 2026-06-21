#!/usr/bin/env bash
# Agentic Redteam(TM) — smoke test.
# Verifies the built image has the core toolchain wired up. Run inside the container.
# Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License
set -uo pipefail

pass=0; fail=0
check() { # check <label> <command...>
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then echo "  ok   $label"; pass=$((pass+1));
  else echo "  FAIL $label"; fail=$((fail+1)); fi
}

echo "== Agentic Redteam smoke test =="

echo "[core toolchain]"
check "claude (Claude Code) on PATH" command -v claude
check "node present"                 command -v node
check "python3 present"              command -v python3

echo "[kali tools]"
# nmap is in every metapackage (incl. kali-tools-top10) — hard requirement.
check "nmap present"                 command -v nmap
# These exist in kali-linux-headless but not kali-tools-top10; non-fatal if absent.
command -v nuclei   >/dev/null 2>&1 && echo "  ok   nuclei present"   || echo "  warn nuclei absent (top10 toolset?)"
command -v gobuster >/dev/null 2>&1 && echo "  ok   gobuster present" || echo "  warn gobuster absent (top10 toolset?)"
command -v sqlmap   >/dev/null 2>&1 && echo "  ok   sqlmap present"   || echo "  warn sqlmap absent (top10 toolset?)"

echo "[skills + reference libraries]"
check "pentest skill present" test -f /root/.claude/skills/pentest/SKILL.md
check "redteam skill present" test -f /root/.claude/skills/redteam/SKILL.md
# the reference libraries (progressive-disclosure how-to) must be bundled too
PT_REF=/root/.claude/skills/pentest/references
RT_REF=/root/.claude/skills/redteam/references
check "pentest reference library present" test -f "$PT_REF/00-methodology-and-engagement.md"
check "pentest reference library complete (6 files)" test "$(ls -1 "$PT_REF"/*.md 2>/dev/null | wc -l)" -ge 6
check "redteam reference library present" test -f "$RT_REF/00-adversary-emulation-and-methodology.md"
check "redteam reference library complete (8 files)" test "$(ls -1 "$RT_REF"/*.md 2>/dev/null | wc -l)" -ge 8
# shared strategic-foundation doctrine
check "strategy doctrine doc present" test -f /opt/agentic-redteam/docs/STRATEGY_OF_ADVERSARIAL_COEVOLUTION.md

echo "[bayesian reasoning tools]"
BAY=/opt/agentic-redteam/tools/bayesian
check "bayesian doctrine doc present" test -f /opt/agentic-redteam/docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md
check "vulnerability_calculator runs"  python3 "$BAY/vulnerability_calculator.py"
check "exploit_chain_simulator runs"   python3 "$BAY/exploit_chain_simulator.py"
check "prob_to_band maps Very High"    bash -c "cd '$BAY' && python3 -c 'from bands import prob_to_band; assert prob_to_band(0.95)==\"Very High\" and prob_to_band(0.05)==\"Very Low\"'"

echo "[scope guard]"
# both skills carry the scope guard; it must REFUSE when no scope file exists (exit != 0)
for SG in /root/.claude/skills/pentest/scripts/scope_check.sh /root/.claude/skills/redteam/scripts/scope_check.sh; do
  skill=$(echo "$SG" | sed 's#.*/skills/\([^/]*\)/.*#\1#')
  check "$skill scope_check.sh present" test -x "$SG"
  if "$SG" 192.0.2.1 /nonexistent/SCOPE.txt >/dev/null 2>&1; then
    echo "  FAIL $skill scope guard allowed a target with no scope file"; fail=$((fail+1))
  else
    echo "  ok   $skill scope guard refuses with no scope file"; pass=$((pass+1))
  fi
done

echo "== $pass passed, $fail failed =="
[ "$fail" -eq 0 ]
