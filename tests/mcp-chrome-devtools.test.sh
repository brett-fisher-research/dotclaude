#!/usr/bin/env bash
# setup.js upserts the chrome-devtools MCP server into ~/.claude.json:
# adds it while preserving unrelated mcpServers entries and unrelated top-level
# keys; creates the file when absent; a second run is a no-op (idempotent).
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { echo "  ASSERT FAILED: $1" >&2; rm -rf "$TMP"; exit 1; }

# node helper: parse the given .claude.json and print an expression's value.
# CFG=<file> EXPR=<js> — avoids passing Git Bash paths through node's require().
jget() { CFG="$1/.claude.json" EXPR="$2" node -e '
  const c = JSON.parse(require("fs").readFileSync(process.env.CFG, "utf8"));
  process.stdout.write(String(eval(process.env.EXPR)));
'; }

TMP="$(mktemp -d)"

# (a) Pre-existing file: an unrelated MCP server + an unrelated top-level key.
cat > "$TMP/.claude.json" <<'JSON'
{
  "numStartups": 42,
  "mcpServers": {
    "other-server": { "command": "foo", "args": ["bar"] }
  }
}
JSON

HOME="$TMP" node "$ROOT/setup.js" >/dev/null 2>&1 || fail "setup.js exited nonzero"

[ "$(jget "$TMP" 'c.numStartups')" = "42" ] || fail "unrelated top-level key not preserved"
[ "$(jget "$TMP" 'c.mcpServers["other-server"].command')" = "foo" ] || fail "unrelated MCP server not preserved"
[ "$(jget "$TMP" 'c.mcpServers["chrome-devtools"].command')" = "npx" ] || fail "chrome-devtools not added"
[ "$(jget "$TMP" 'c.mcpServers["chrome-devtools"].args.join(",")')" = "-y,chrome-devtools-mcp@latest,--headless=true,--isolated=true" ] || fail "chrome-devtools args wrong"

# (c) Idempotent: a second run leaves byte-for-byte identical content.
before="$(cat "$TMP/.claude.json")"
HOME="$TMP" node "$ROOT/setup.js" >/dev/null 2>&1 || fail "setup.js not idempotent"
[ "$(cat "$TMP/.claude.json")" = "$before" ] || fail "second run changed ~/.claude.json"

# (b) No file: install creates it with chrome-devtools registered.
FRESH="$(mktemp -d)"
HOME="$FRESH" node "$ROOT/setup.js" >/dev/null 2>&1 || fail "setup.js exited nonzero (fresh)"
[ -f "$FRESH/.claude.json" ] || fail "~/.claude.json not created when absent"
[ "$(jget "$FRESH" 'c.mcpServers["chrome-devtools"].command')" = "npx" ] || fail "chrome-devtools not registered in fresh file"
rm -rf "$FRESH"

rm -rf "$TMP"
exit 0
