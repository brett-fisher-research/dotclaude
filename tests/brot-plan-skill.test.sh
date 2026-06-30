#!/usr/bin/env bash
# B2: brot-plan cites brot-bot + plan template, bash tests first-class, no swarm/wave/lane/fan out.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

S="$ROOT/skills/brot-plan/SKILL.md"
[ -f "$S" ] || fail "skills/brot-plan/SKILL.md missing"
grep -q '/brot-bot' "$S" || fail "no /brot-bot handoff"
grep -q 'brot-template plan' "$S" || fail "no plan template citation"
grep -qi 'bash' "$S" || fail "no bash test mention"
for w in wave lane 'fan out' swarm; do
  grep -qi "$w" "$S" && fail "forbidden word present: $w"
done
exit 0
