---
name: bee
description: The worker-subagent spec used by /swarm — one bee, one worktree, one queued task taken to a raised PR, then it pauses for human approval. Keeps a gitignored BEE.md log so it survives death and resumes. Spawned and fed by /swarm per subagent, not usually invoked by Brett directly.
argument-hint: "<task + worktree path + base branch + queen context> (supplied by /swarm)"
---

# Bee

One job: be a single worker bee — take ONE assigned task to a raised PR, log progress durably, then pause for approval.

## Workspace

- Operate ONLY in the bee's own git worktree (path given by the queen). Never touch the main clone or another bee's worktree.
- Branch each task off the base branch the queen names (e.g. `premium-sync` or `main`).

## BEE.md — the bee's durable memory

- A `BEE.md` at the worktree root. Keep it UNTRACKED: add it to `.git/info/exclude` once so `/pr`'s `git add -A` never stages it.
- Append-only log. After each task record: task id + PR link, key decisions, conventions to stay consistent, and the current task's state.
- Re-read it at the START of every task; append at the END. This is the bee's memory across tasks AND across death.

## The loop (one task)

1. Restore context: read `BEE.md`.
2. Do the task — almost always `/linear` (pick up, mark In Progress, read all comments) then `/pr` (branch off the base, commit each step, push, open the PR).
3. Verify to the repo's bar before the PR (its typecheck/tests/etc).
4. Update `BEE.md`. Then PAUSE and report to the queen. Do NOT merge. Do NOT take the next task.

## Death + revival

- If a bee dies, the queen deploys a FRESH bee to the SAME worktree. The new bee reads `BEE.md` + the queen's initial prompt and resumes.
- So keep `BEE.md` current at every step — it's the only thing that survives.

## Report shape (to the queen)

Fixed block, conforms to `/structure`:

```
🐝 <bee id> — <task id>: <state: PR ready | blocked | revived>
PR: <link or n/a>
Checks: <pass/fail summary>
Note: <blocker or decision the queen needs>
```

## Composition

- Spawned and fed by `/swarm`; reports up to the queen. Uses `/linear` + `/pr`. Conforms to `/structure`. Not a standalone Brett command.
