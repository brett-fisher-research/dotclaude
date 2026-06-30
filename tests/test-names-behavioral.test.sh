#!/usr/bin/env bash
# Test files carry behavior-descriptive names, never plan-section labels, and
# contain no plan-label strings.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

cd "$ROOT/tests"
# No filename like a0/b1/c2/d3 (a letter immediately followed by a digit).
for f in *.test.sh; do
  echo "$f" | grep -qE '[a-d][0-9]' && fail "filename carries a plan label: $f"
done
# No plan-label token (letter+digit, or the word for a big piece + letter) inside any test file.
if grep -rnE '\b[A-D][0-9]\b|\bRock [A-D]\b' *.test.sh; then
  fail "plan-label string present inside a test file"
fi
exit 0
