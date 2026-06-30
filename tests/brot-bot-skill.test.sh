#!/usr/bin/env bash
# brot-bot = ONE background coding agent, /pr, strict SRP; no swarm/wave/lane.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-bot/SKILL.md"
[ -f "$S" ] || fail "skills/brot-bot/SKILL.md missing"
grep -q '^name: brot-bot$' "$S" || fail "name is not brot-bot"
grep -qi 'background' "$S" || fail "no background agent mention"
grep -qi 'single\|one ' "$S" || fail "no single-agent emphasis"
grep -q '/pr' "$S" || fail "no /pr mention"
grep -qi 'SRP' "$S" || fail "no SRP mention"
for w in swarm wave lane 'fan out'; do
  grep -qi "$w" "$S" && fail "forbidden word present: $w"
done
exit 0
