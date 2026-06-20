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

echo "[skill + scope guard]"
check "pentest skill present" test -f /root/.claude/skills/pentest/SKILL.md
# the reference library (progressive-disclosure how-to) must be bundled too
REFDIR=/root/.claude/skills/pentest/references
check "reference library present" test -f "$REFDIR/00-methodology-and-engagement.md"
check "reference library complete (6 files)" test "$(ls -1 "$REFDIR"/*.md 2>/dev/null | wc -l)" -ge 6
SG=/root/.claude/skills/pentest/scripts/scope_check.sh
check "scope_check.sh present" test -x "$SG"
# scope guard must REFUSE when no scope file exists (exit != 0)
if "$SG" 192.0.2.1 /nonexistent/SCOPE.txt >/dev/null 2>&1; then
  echo "  FAIL scope guard allowed a target with no scope file"; fail=$((fail+1))
else
  echo "  ok   scope guard refuses with no scope file"; pass=$((pass+1))
fi

echo "== $pass passed, $fail failed =="
[ "$fail" -eq 0 ]
