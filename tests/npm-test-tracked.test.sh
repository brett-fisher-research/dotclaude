#!/usr/bin/env bash
# The harness is tracked (not gitignored) and runnable via npm run test.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

P="$ROOT/package.json"
[ -f "$P" ] || fail "package.json missing"
grep -q 'bash tests/run.sh' "$P" || fail "package.json test script not wired to bash tests/run.sh"

# Tracked = NOT ignored: git check-ignore returns nonzero for tracked paths.
( cd "$ROOT" && git check-ignore -q package.json ) && fail "package.json is gitignored"
( cd "$ROOT" && git check-ignore -q tests/run.sh ) && fail "tests/run.sh is gitignored"
exit 0
