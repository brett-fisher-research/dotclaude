#!/usr/bin/env bash
# A2: brot-template skill renamed from template; templates/ (incl goal.md) moved under it.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-template/SKILL.md"
[ -f "$S" ] || fail "skills/brot-template/SKILL.md missing"
grep -q '^name: brot-template$' "$S" || fail "name is not brot-template"
[ -f "$ROOT/skills/brot-template/templates/goal.md" ] || fail "templates/goal.md missing"
[ ! -d "$ROOT/skills/template" ] || fail "old skills/template dir still exists"
grep -q '/template ' "$S" && fail "stale /template self-reference in SKILL.md"
exit 0
