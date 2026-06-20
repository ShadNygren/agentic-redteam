#!/usr/bin/env bash
# Agentic Redteam(TM) — scope guard.
# Exits 0 only if <target> exactly matches a line in the in-scope allow-list.
# Usage: scope_check.sh <target> [scope-file]   (default scope file: /work/SCOPE.txt)
#
# Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License
set -euo pipefail

target="${1:-}"
scope_file="${2:-/work/SCOPE.txt}"

if [[ -z "$target" ]]; then
  echo "ERROR: no target given. Usage: scope_check.sh <target> [scope-file]" >&2
  exit 2
fi
if [[ ! -f "$scope_file" ]]; then
  echo "REFUSE: scope file '$scope_file' not found. No authorized targets => STOP." >&2
  exit 3
fi

# Exact, whole-line match (ignore blank lines and # comments). No wildcards by design:
# scope must be explicit. Add CIDR/glob matching only if the RoE explicitly allows it.
if grep -vE '^\s*(#|$)' "$scope_file" | sed 's/[[:space:]]//g' | grep -qxF "$target"; then
  echo "IN-SCOPE: $target"
  exit 0
else
  echo "OUT-OF-SCOPE: '$target' is not in $scope_file => DO NOT TOUCH IT. Stop and ask the human." >&2
  exit 1
fi
