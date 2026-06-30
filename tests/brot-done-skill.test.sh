#!/usr/bin/env bash
# B5: brot-done = coding agent runs /merge + dev-server teardown + delete BROT_PLAN.md.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-done/SKILL.md"
[ -f "$S" ] || fail "skills/brot-done/SKILL.md missing"
grep -q '/merge' "$S" || fail "no /merge mention"
grep -qi 'coding agent' "$S" || fail "no coding-agent-merges framing"
grep -qi 'dev-server\|dev server' "$S" || fail "no dev-server teardown"
grep -q 'BROT_PLAN.md' "$S" || fail "no BROT_PLAN.md delete"
exit 0
