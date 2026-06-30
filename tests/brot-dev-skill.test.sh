#!/usr/bin/env bash
# B4: brot-dev mentions .logs + hot reload + background + browser logs.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-dev/SKILL.md"
[ -f "$S" ] || fail "skills/brot-dev/SKILL.md missing"
grep -q '^name: brot-dev$' "$S" || fail "name is not brot-dev"
grep -q '.logs' "$S" || fail "no .logs mention"
grep -qi 'hot reload' "$S" || fail "no hot reload mention"
grep -qi 'background' "$S" || fail "no background mention"
grep -qi 'browser' "$S" || fail "no browser logs mention"
exit 0
