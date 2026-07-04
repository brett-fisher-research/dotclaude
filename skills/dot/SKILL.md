---
name: dot
description: Manage the user's ~/.claude config (settings + skills), version-controlled in this dotclaude repo — a brot-os tenant synced via /brot-sync. Use when working with tracked ~/.claude config: editing settings.json or skills, checking their status/diffs, or committing and syncing config changes. The repo is the single source of truth; never edit the installed ~/.claude copy.
---

# ~/.claude config (dotclaude tenant)

The user's `~/.claude` config lives in the `dotclaude` repo — a brot-os tenant cloned to
`dotfiles/dotclaude`. The retired `cfg` bare-repo workflow (`~/.dotfiles` aliased as `cfg`) is
gone; do not use it.

## The model

- The repo is the single source of truth. Repo-root files map onto `~/.claude/`:
  `settings.json` -> `~/.claude/settings.json`, `skills/**` -> `~/.claude/skills/**`.
- Edit config in the repo, then re-sync. NEVER edit the installed `~/.claude` copy directly — a
  sync overwrites it and the edit is lost.
- Only the tracked surface is shared: `settings.json`, `skills/`, `package.json`, `tests/`,
  `setup.js`, `README.md`. Everything else in `~/.claude` (projects, history, credentials,
  MEMORY.md, untracked skills) is machine-local and never touched.

## Install / sync

`npm run setup` (from the repo) is idempotent — it overwrites `~/.claude/settings.json` and
copies every tracked skill file into `~/.claude/skills/**`, leaving all other `~/.claude` state
untouched.

Do not cd into the tenant to pull or setup. From the brot-os root run `/brot-sync` (or
`npm run sync`): it pulls the repo and drives its `npm run setup`.

## Version control

Git work happens inside the tenant repo (`dotfiles/dotclaude`) with plain `git`, on a feature
branch, landed via `/pr` -> `/merge`. Then `/brot-sync` from the brot-os root installs it. Cross-
machine: pull brot-os, `/brot-sync`, done.
