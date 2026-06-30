#!/usr/bin/env bash
# brot-done = PM/main-thread runs /merge (after user approval), NOT the coding agent;
# plus dev-server teardown + delete BROT_PLAN.md.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-done/SKILL.md"
[ -f "$S" ] || fail "skills/brot-done/SKILL.md missing"
grep -q '/merge' "$S" || fail "no /merge mention"
grep -qi 'PM' "$S" || fail "no PM-merges framing"
# The coding agent must NOT be framed as the merger.
grep -qi 'coding agent runs `/merge`' "$S" && fail "coding agent still framed as the merger"
grep -qi 'merging is the dev' "$S" && fail "dev still framed as the merger"
grep -qi 'dev-server\|dev server' "$S" || fail "no dev-server teardown"
grep -q 'BROT_PLAN.md' "$S" || fail "no BROT_PLAN.md delete"
exit 0
