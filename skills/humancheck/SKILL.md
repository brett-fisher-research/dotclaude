---
name: humancheck
description: Get a bee's work running in front of you to verify by hand — switch into that bee's worktree, kill any live instance, and launch the app hot-reloaded via /run. Use when Brett wants to eyeball a specific bee's change in the running app (e.g. "check bee 2"), or when invoked as /humancheck. Usually called by the /swarm queen, also works standalone.
argument-hint: "<bee id or worktree>"
---

# Humancheck

One job: put one bee's running app in front of Brett so he can verify it by hand. Nothing else runs the live app — this is the single, serial gate where it does.

## Why it's the only place the app runs

- Single-instance apps (one lock, one dev port, one local db) can't run twice at once. Bees never launch the app (see `/bee`); they only edit, test, and raise PRs.
- So the live app runs at exactly one moment: when Brett checks a bee. That keeps it collision-free.

## Steps

1. Resolve the bee → its worktree path (from `HIVE.md` if the queen is running).
2. Kill any currently-running instance (free the lock / port / db).
3. Switch the session into that worktree.
4. `/run` — launches the app hot-reloaded, using the project's run-skill recipe. If no run-skill exists, `/run-skill-generator` writes one first (one-time).
5. Hand Brett what he needs to look at — for a web app, the URL + port via `/humansteps`; for desktop, the window is already up. Then Brett verifies.

## Notes

- Serial by design: checking another bee kills the current instance first. One live app at a time.
- App-specific launch (env, ports, shared daemons like a stripe listener) lives in the project's run-skill — never here.

## Composition

- Invoked by the `/swarm` queen when Brett says "check bee N"; also standalone.
- Wraps `/run` (which consults the project run-skill / `/run-skill-generator`). Uses `/humansteps` to surface a web URL. 