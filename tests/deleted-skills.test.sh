#!/usr/bin/env bash
# replaced skills are gone.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

for s in duck duck-end template brot-start humansteps; do
  [ ! -d "$ROOT/skills/$s" ] || fail "skills/$s still exists"
done
exit 0
