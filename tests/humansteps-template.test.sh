#!/usr/bin/env bash
# A4: humansteps template ports the fixed-format contract.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

H="$ROOT/skills/brot-template/templates/humansteps.md"
[ -f "$H" ] || fail "humansteps.md missing"
grep -q '🧑 Human steps' "$H" || fail "no 🧑 Human steps header"
grep -q '→ expect:' "$H" || fail "no → expect: line"
grep -q '✅ Done when:' "$H" || fail "no ✅ Done when: line"
exit 0
