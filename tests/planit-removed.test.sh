#!/usr/bin/env bash
# planit skill is deleted and no longer referenced in the composition map.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

[ ! -d "$ROOT/skills/planit" ] || fail "skills/planit still exists"
grep -qi 'planit' "$ROOT/skills/CLAUDE.md" && fail "planit still referenced in skills/CLAUDE.md"
exit 0
