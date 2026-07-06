#!/usr/bin/env bash
# setup.js mirrors ~/.claude/skills to the repo: untracked skill dirs are pruned,
# tracked skill dirs and the loose skills/CLAUDE.md survive. Scoped to skills/ only.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; rm -rf "$TMP"; exit 1; }

TMP="$(mktemp -d)"
FAKE_SKILLS="$TMP/.claude/skills"
mkdir -p "$FAKE_SKILLS"

# A tracked skill (pick the first repo skill dir) pre-installed, plus an untracked one.
TRACKED="$(cd "$ROOT/skills" && for d in */; do echo "${d%/}"; break; done)"
[ -n "$TRACKED" ] || fail "no tracked skill dir found in repo"
mkdir -p "$FAKE_SKILLS/$TRACKED" && echo "stale" > "$FAKE_SKILLS/$TRACKED/SKILL.md"
mkdir -p "$FAKE_SKILLS/untracked-fake" && echo "x" > "$FAKE_SKILLS/untracked-fake/SKILL.md"

# Non-skill machine-local state that must never be touched.
echo '{}' > "$TMP/.claude/settings-should-survive.json"
mkdir -p "$TMP/.claude/projects" && echo "keep" > "$TMP/.claude/projects/p.json"

# Run setup against the temp HOME (setup.js resolves target via os.homedir()).
HOME="$TMP" node "$ROOT/setup.js" >/dev/null 2>&1 || fail "setup.js exited nonzero"

[ ! -d "$FAKE_SKILLS/untracked-fake" ] || fail "untracked skill dir was not pruned"
[ -d "$FAKE_SKILLS/$TRACKED" ] || fail "tracked skill dir $TRACKED missing"
[ -f "$FAKE_SKILLS/CLAUDE.md" ] || fail "tracked skills/CLAUDE.md was not installed/preserved"
[ -f "$TMP/.claude/projects/p.json" ] || fail "non-skill state (projects/) was touched"

# Idempotent: a second run is safe and leaves the same result.
HOME="$TMP" node "$ROOT/setup.js" >/dev/null 2>&1 || fail "setup.js not idempotent"
[ ! -d "$FAKE_SKILLS/untracked-fake" ] || fail "untracked dir reappeared on re-run"
[ -d "$FAKE_SKILLS/$TRACKED" ] || fail "tracked dir lost on re-run"

rm -rf "$TMP"
exit 0
