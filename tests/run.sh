#!/usr/bin/env bash
# Runs every tests/*.test.sh. Exits nonzero if any fail. Prints a pass/fail summary.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pass=0
fail=0
failed_names=()

shopt -s nullglob
for t in "$here"/*.test.sh; do
  name="$(basename "$t")"
  if bash "$t"; then
    echo "PASS  $name"
    pass=$((pass + 1))
  else
    echo "FAIL  $name"
    fail=$((fail + 1))
    failed_names+=("$name")
  fi
done

echo "----------------------------------------"
echo "Summary: $pass passed, $fail failed"
if [ "$fail" -ne 0 ]; then
  printf '  failed: %s\n' "${failed_names[@]}"
  exit 1
fi
exit 0
