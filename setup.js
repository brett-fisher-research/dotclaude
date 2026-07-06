#!/usr/bin/env node
// Idempotent ~/.claude config setup. Safe to run repeatedly.
// Installs this repo's TRACKED surface into ~/.claude. The repo is the source of
// truth for its own surface; everything else in ~/.claude is machine-local and is
// left untouched (settings.json aside):
// 1. Overwrites ~/.claude/settings.json with the repo copy (repo is the source of truth).
// 2. Mirrors repo skills/** into ~/.claude/skills/**: copies every tracked skill file
//    over its destination, then PRUNES any top-level skill DIRECTORY in ~/.claude/skills
//    the repo does not track — so the installed skill set matches the repo exactly.
//    Pruning is scoped strictly to subdirectories of ~/.claude/skills. It never touches
//    anything else under ~/.claude (projects/, history, credentials, MEMORY.md, ...) and
//    never removes loose files in skills/ itself (e.g. the tracked skills/CLAUDE.md).

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

// 2. skills/** — copy every tracked skill file over its destination.
const skillsSrc = path.join(REPO, 'skills');
const skillsDest = path.join(CLAUDE, 'skills');
let skillCount = 0;
for (const rel of walk(skillsSrc)) {
  copyInto(path.join(skillsSrc, rel), path.join(skillsDest, rel));
  skillCount += 1;
}
log(`Synced ${skillCount} skill file(s) -> ${skillsDest}`);

// 3. Prune: delete any top-level skill DIRECTORY in ~/.claude/skills the repo does not
// track. Scoped strictly to subdirectories of ~/.claude/skills — loose files there
// (e.g. the tracked skills/CLAUDE.md) and everything else under ~/.claude are untouched.
const trackedDirs = new Set(
  fs.readdirSync(skillsSrc, { withFileTypes: true })
    .filter((e) => e.isDirectory())
    .map((e) => e.name),
);
let prunedCount = 0;
if (fs.existsSync(skillsDest)) {
  for (const entry of fs.readdirSync(skillsDest, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue; // loose files (CLAUDE.md, ...) left alone
    if (trackedDirs.has(entry.name)) continue; // tracked skill — keep
    fs.rmSync(path.join(skillsDest, entry.name), { recursive: true, force: true });
    log(`Pruned untracked skill dir -> ${path.join(skillsDest, entry.name)}`);
    prunedCount += 1;
  }
}
log(`Pruned ${prunedCount} untracked skill dir(s); ~/.claude/skills now mirrors the repo.`);

log('Done. ~/.claude tracked config is up to date; machine-local state left untouched.');
