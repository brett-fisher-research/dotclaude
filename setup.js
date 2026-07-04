#!/usr/bin/env node
// Idempotent ~/.claude config setup. Safe to run repeatedly.
// Installs this repo's TRACKED surface into ~/.claude without disturbing
// machine-local state (projects/, history, credentials, MEMORY.md, untracked skills):
// 1. Overwrites ~/.claude/settings.json with the repo copy (repo is the source of truth).
// 2. Merges repo skills/** into ~/.claude/skills/** — mkdir -p + copy-over, never delete.

'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');

const REPO = __dirname;
const CLAUDE = path.join(os.homedir(), '.claude');

function log(msg) {
  console.log(`[dotclaude] ${msg}`);
}

// Copy one file, creating parent dirs as needed. Overwrites the destination.
function copyInto(src, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}

// All files under a directory, returned as paths relative to it.
function walk(dir, base = dir) {
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      out.push(...walk(full, base));
    } else if (entry.isFile()) {
      out.push(path.relative(base, full));
    }
  }
  return out;
}

// 1. settings.json — repo overrides any live file.
copyInto(path.join(REPO, 'settings.json'), path.join(CLAUDE, 'settings.json'));
log(`Installed settings.json -> ${path.join(CLAUDE, 'settings.json')}`);

// 2. skills/** — copy every tracked skill file over its destination. Additive:
// skills ~/.claude has that the repo does not track are left untouched.
const skillsSrc = path.join(REPO, 'skills');
let skillCount = 0;
for (const rel of walk(skillsSrc)) {
  copyInto(path.join(skillsSrc, rel), path.join(CLAUDE, 'skills', rel));
  skillCount += 1;
}
log(`Synced ${skillCount} skill file(s) -> ${path.join(CLAUDE, 'skills')}`);

log('Done. ~/.claude tracked config is up to date; machine-local state left untouched.');
