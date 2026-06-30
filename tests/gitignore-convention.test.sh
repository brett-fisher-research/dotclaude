#!/usr/bin/env bash
# C3: root BROT_PLAN.md is gitignored; stale skills/BROT_PLAN.md comment fixed to root convention.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

( cd "$ROOT" && git check-ignore BROT_PLAN.md >/dev/null ) || fail "BROT_PLAN.md not gitignored"
grep -q '^skills/BROT_PLAN.md$' "$ROOT/.gitignore" && fail "stale skills/BROT_PLAN.md ignore line still present"
exit 0
