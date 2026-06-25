---
name: pr
description: Start a pull-request workflow for any code change. Use when the user says "/pr", "let's make a PR", "start a branch for ...", or whenever code is about to change. This is the STANDARD entry point for ALL code changes — it ensures a clean tree, branches off an up-to-date main, and enforces commit-at-every-step discipline. It does NOT push or open a PR — that happens later via /raise, then /merge.
argument-hint: "<what you're about to work on>"
allowed-tools: Bash Read Write Edit
---

# Start a pull-request workflow

Standard workflow for **every** code change. Nothing lands on `main` directly — all work rides a PR branch from here. Three skills:

1. **`/pr`** (this skill) — clean tree, branch off fresh `main`, do the work, commit every step.
2. **`/raise`** — push the branch and open the PR.
3. **`/merge`** — squash-merge, return to `main`, pull.

Work to do is in `$ARGUMENTS`; if invoked bare, infer it from the conversation.

## Steps

1. **Guard against unsaved work on `main`.** Check first:
   ```bash
   git status --porcelain && git branch --show-current
   ```
   - **Dirty tree** (uncommitted/untracked): STOP. Show the changes and use `AskUserQuestion`:
     - **Bring along** — carry onto the new branch (`git stash` → branch → `git stash pop`).
     - **Commit first** — separate finished change: commit on current branch before proceeding.
     - **Stash and set aside** — `git stash`, leave for later.
     - **Discard** — destructive; only on explicit confirmation.

     Never silently proceed over a dirty tree.
   - **Already on a non-`main` PR branch**: ask whether to keep working on it (skip to step 3) or branch fresh.

2. **Branch off up-to-date `main`.** Sync the remote first:
   ```bash
   git fetch origin --prune
   git checkout main
   git pull --ff-only
   git checkout -b <type>/<short-slug>
   ```
   `<type>` = loose grouping of the work:
   - `feat/` — new feature or capability
   - `bug/` — bug fix
   - `chore/` — tooling, deps, config, refactors with no behavior change
   - `docs/` — documentation only
   - …or another short, sensible prefix.

   `<short-slug>` is kebab-case (e.g. `feat/dark-mode-toggle`, `bug/save-modal-autofill`). Confirm: `git branch --show-current`.

3. **Do the work, committing at EVERY step** — not one giant commit at the end:
   ```bash
   git add -A && git commit -m "<concise, present-tense message>"
   ```
   - Each commit = a coherent, self-contained step (e.g. "scaffold app", "wire up save flow").
   - **Clean tree on every handback.** Whenever you yield to the user — question, progress, review — everything you changed is already committed. Confirm with `git status --porcelain` (empty).
   - Follow the repo's commit convention (short, imperative; see `git log`). End each message with the standard co-author trailer.

4. **Stop at committed — do NOT push or open a PR.** Never run `git push` or `gh pr create`. The branch stays local until the user invokes **`/raise`**. When done, tell the user it's ready to review locally, then `/raise` when they want the PR opened.

## Relationship to other skills

Code-changing skills (`/new-experiment`, `/experiment`, `/promote-experiment`, and any future one) **run inside this flow**: invoke `/pr` first, commit every step, leave pushing/PR-opening to `/raise` and `/merge`. See `~/claude-experiments/CLAUDE.md` ("Code changes go through the PR workflow").
