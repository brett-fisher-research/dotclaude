#!/usr/bin/env bash
# C2: skills/CLAUDE.md composition map updated to brot-* family; no stale refs / swarm words.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

C="$ROOT/skills/CLAUDE.md"
[ -f "$C" ] || fail "skills/CLAUDE.md missing"
for needed in brot-board brot-bot brot-dev brot-template; do
  grep -q "$needed" "$C" || fail "missing reference: $needed"
done
for bad in '/duck' '/brot-start' '/humansteps' swarm wave 'fan out'; do
  grep -qi "$bad" "$C" && fail "forbidden present: $bad"
done
exit 0
