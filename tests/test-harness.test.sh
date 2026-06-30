#!/usr/bin/env bash
# tests/run.sh runs every *.test.sh, exits nonzero on any failure, prints a summary.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN="$ROOT/tests/run.sh"

fail() { echo "  ASSERT FAILED: $1" >&2; exit 1; }

[ -x "$RUN" ] || fail "tests/run.sh is not executable"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/tests"
cp "$RUN" "$work/tests/run.sh"

# Case 1: a passing + a failing test -> nonzero exit, failure reported.
printf '#!/usr/bin/env bash\nexit 0\n' > "$work/tests/aa_pass.test.sh"
printf '#!/usr/bin/env bash\nexit 1\n' > "$work/tests/bb_fail.test.sh"
out="$(bash "$work/tests/run.sh" 2>&1)"; code=$?
[ "$code" -ne 0 ] || fail "runner exited 0 despite a failing test"
echo "$out" | grep -q "FAIL" || fail "runner did not report the failure"

# Case 2: all passing -> exit 0.
rm "$work/tests/bb_fail.test.sh"
bash "$work/tests/run.sh" >/dev/null 2>&1 || fail "runner exited nonzero with all tests passing"

exit 0
