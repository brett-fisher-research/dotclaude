#!/usr/bin/env bash
# B1: brot-board is a permissive whiteboard; no-pressure-to-act + /brot-plan handoff; no old framing.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-board/SKILL.md"
[ -f "$S" ] || fail "skills/brot-board/SKILL.md missing"
grep -q '^name: brot-board$' "$S" || fail "name is not brot-board"
grep -qi 'pressure to act' "$S" || fail "no no-pressure-to-act framing"
grep -q '/brot-plan' "$S" || fail "no /brot-plan handoff"
grep -qi 'out of the pond' "$S" && fail "stale 'out of the pond' framing present"
grep -qi 'listen-only' "$S" && fail "stale 'listen-only' framing present"
exit 0
