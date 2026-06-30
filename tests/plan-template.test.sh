#!/usr/bin/env bash
# plan template has goal section, recursive checkbox breakdown, emoji + per-leaf test markers.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

P="$ROOT/skills/brot-template/templates/plan.md"
[ -f "$P" ] || fail "plan.md missing"
grep -q 'High-level goal' "$P" || fail "no high-level goal section"
grep -q -- '- \[ \]' "$P" || fail "no checkbox"
grep -q '🎯' "$P" || fail "no 🎯 goal marker"
grep -q '📋' "$P" || fail "no 📋 test marker"
exit 0
