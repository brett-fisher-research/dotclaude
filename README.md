# dotclaude

Version-controlled [Claude Code](https://claude.com/claude-code) configuration —
shared across machines. Only `settings.json`, `README.md`, and the `skills/`
directory are tracked; everything else in `~/.claude/` (credentials, history,
sessions, caches, projects, `settings.local.json`, …) is gitignored and stays
machine-local.

## Setting up on a new machine

A fresh machine already has a `~/.claude/` directory with its own settings,
skills, and local state, so you can't `git clone` into it. Instead, "adopt" the
existing directory into this remote. The `.gitignore` only tracks `settings.json`
and `skills/`, so machine-local state is never touched.

```sh
cd ~/.claude
git init
git remote add origin https://github.com/brett-fisher-research/dotclaude.git
git fetch origin

# Bring in the ignore rules FIRST, so machine-local state is protected
git checkout origin/main -- .gitignore

# Point the local branch at the remote, keep all existing working files untouched
git reset --mixed origin/main
```

After this, `git status` shows only:

- `modified: settings.json` (if this machine's settings differ from the repo's)
- any skills this machine has that aren't in the repo yet, as **untracked** under
  `skills/`

Everything else stays ignored and untouched.

## Reconcile and push the machine's skills up

```sh
# Add this machine's existing skills into the shared repo
git add skills/
```

For `settings.json`, decide — settings are often machine-specific:

```sh
# Option A — make THIS machine's settings the shared ones:
git add settings.json

# Option B — discard this machine's settings, take the repo's version:
git checkout origin/main -- settings.json
```

Then:

```sh
git status            # sanity-check: only settings.json + skills/, nothing machine-local
git commit -m "Add skills from <machine-name>"
git push origin main
```

## Notes

- **Settings drift is the thing to watch.** If machines need different settings,
  keep the shared `settings.json` minimal and put per-machine overrides in
  `settings.local.json` (gitignored). Otherwise every machine fights over
  `settings.json`.
- **If a skill name collides** (same `skills/<name>/` exists locally and in the
  repo with different content), `git reset --mixed` keeps your local copy and
  shows it as modified — review the diff before `git add`-ing so you don't clobber
  the version already on the remote.
- **Going forward**, just `git pull` / `git push` from inside `~/.claude` like a
  normal repo.
