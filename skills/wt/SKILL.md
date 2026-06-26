---
name: wt
description: Relocate a piece of work into an isolated git worktree, set the worktree up, do the work there, and tear it down when its PR merges. Use when the user says "/wt", "do this in a worktree", "spin up a worktree for ...", or wants one task (or several at once) worked in isolation off the main clone. Composes with /pr, /merge, /linear, /notify. "wt" = worktree.
argument-hint: "<what to work on> (name multiple tasks/tickets for parallel worktrees)"
allowed-tools: EnterWorktree ExitWorktree Bash Read Write Edit Agent Skill
---

# Work in a worktree

One job: manage the worktree around a piece of work — create it, set it up, and reap it when its PR lands. The work itself (editing code, raising the PR) belongs to the other skills; `/wt` is the isolation wrapper.

Work to do is in `$ARGUMENTS`; if invoked bare, infer it from the conversation.

## Pick the mode

- One task → foreground (this session moves into the worktree). Most common.
- Several independent tasks named at once (e.g. "FIS-100, FIS-101, FIS-102 each in its own /wt") → background fleet: one subagent per worktree, run concurrently.

## Foreground — single task

1. Enter a fresh worktree. `EnterWorktree` (name it after the task slug). It branches off a fresh base, creates the worktree, and switches the session into it.
2. Set the worktree up (see Setup). Do this before any work — deps must be installed.
3. Do the work. Hand off to the relevant skill — usually `/pr` (it branches, commits each step, pushes, opens the PR). If the user asked to pick up a ticket, `/linear` first, then `/planit`, then `/pr`.
4. Stay put. The session lives in the worktree through review and follow-up commits. Do NOT exit on its own.
5. Reap on merge — see Cleanup.

## Background fleet — many tasks

- Spawn one subagent per task with `Agent`, `isolation: "worktree"`, `run_in_background: true`. Each subagent: set up its worktree, do its task, raise its `/pr`, then `/notify` the user that it finished (include the PR link).
- Each worktree is isolated — agents commit in parallel without colliding.
- Report the launched set back to the user; the per-task `/notify` calls land as each finishes.

## Setup — the `.worktree-setup` convention

A fresh worktree shares git history but NOT the working dir — `node_modules`, `target/`, `.venv`, build artifacts are all absent. Convention: a `.worktree-setup` script at the repo root, version-controlled, that installs them.

- After entering the worktree, look for `.worktree-setup` at root.
  - Present → run it: `bash .worktree-setup` (POSIX sh via Git Bash; portable across the user's Windows machine and any unix box).
  - Missing → BOOTSTRAP it (the "smart" part):
    1. Sniff the project — `package.json` (+ lockfile → npm/pnpm/yarn), `Cargo.toml`, `go.mod`, `pyproject.toml`/`requirements.txt`, `Gemfile`, etc.
    2. Read `CLAUDE.md` / `README` for any stated setup steps.
    3. Draft `.worktree-setup` from that, show the user, then run it.
    4. Stage it so it rides the task's `/pr` — committed to the repo, it's there for every future worktree and shared with the team.
- Keep `.worktree-setup` repo-specific (install + build only). `/wt` stays generic — it just runs the hook.

## Cleanup — `/wt` owns it, not `/merge`

`/merge` knows nothing about worktrees (it's tracker- and worktree-agnostic). `/wt` reaps what it created.

- Standing rule for this session: when the user runs `/merge` and it succeeds, tear down this worktree.
  - Foreground: `ExitWorktree` with `action: "remove"` — returns the session to the main clone and deletes the worktree + its (now-merged, branch-deleted) branch.
  - Background: `git worktree prune` plus `git worktree remove <path>` for the merged one.
- If the tree still has uncommitted changes, `ExitWorktree` refuses — surface that, don't discard without confirmation.
- No merge yet / abandoned work → the worktree persists. Reap it on demand when the user asks ("clean up the worktree").

## Composition

- Wraps the standard flow in isolation: `/wt` → (`/linear` → `/planit` →) `/pr` → review → `/merge` → `/wt` reaps.
- `/pr` does the branching and commits; `/wt` does not duplicate that — it only owns the worktree's existence.
- `/merge` triggers cleanup via the standing rule above but never performs it.
- `/notify` reports background-fleet completions.
