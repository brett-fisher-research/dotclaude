---
name: swarm
description: Run a hive of 2-3 parallel worker bees (subagents in worktrees) through queues of tasks, gated on Brett's review and merge. Invoked once; the session becomes the queen/orchestrator until the hive drains. Use when Brett wants several tickets/tasks worked in parallel and landed one-by-one after his approval; or when invoked as /swarm. Plan first with /duck or /planit.
argument-hint: "<the planned lanes/queues of tasks> (run /planit first)"
---

# Swarm

One job: orchestrate parallel bees through queued work, gated on human approval. Invoking `/swarm` puts the session into QUEEN MODE — it persists across turns (like `/duck`) until the hive is empty. Brett watches and does his human steps; the queen runs the hive.

## Precondition — plan first

- A plan must exist: lanes of tasks that don't collide (touch different files / no shared singleton like one dev-server lock). Parallelism is BETWEEN lanes; within a lane, tasks are serial.
- If Brett gives no plan, suggest `/planit` (or `/duck`) first — don't invent lanes. Swarm trusts the plan for what's safe to parallelize.

## Limit

- 2-3 bees by default (configurable). The real cap is non-colliding lanes — never put two bees on the same files or shared lock.

## HIVE.md — the queen's source of truth

- A `HIVE.md` (gitignored via `.git/info/exclude`) the queen owns. Fixed structure, same every run:

```
# Hive

| bee | worktree | queue (ordered) | done | current | status |
|-----|----------|-----------------|------|---------|--------|
| b1  | <path>   | T2, T3          | T1   | T2      | working |
| b2  | <path>   | —               | T4   | —       | idle/retire |
```

- Regenerate the status tables you show Brett FROM HIVE.md — so they survive context compaction, not memory.

## Run the hive

1. Spin up: one bee per lane via `/bee` (background subagent, isolation worktree). Give each its worktree, base branch, first task, and enough context.
2. Feed ONE task at a time. A bee does its task, raises its PR, pauses, reports up.
3. Report to Brett: the hive as a structured table (per bee: done / working on / queued)
4. Gate: Brett reviews + merges the PR, then tells the queen to continue (next task) or retire that bee. Update HIVE.md, feed the next task.

## Dead bees

- Detect two ways: lazily at hand-off (a bee won't wake when fed), AND proactively — run `/loop` ~every 2-3 min to check each bee is still on task.
- Revive: deploy a FRESH bee to the dead one's existing worktree, pointing it at its `BEE.md` + a good initial prompt. Its work survives in the worktree + BEE.md.

## Verifying a bee

- When Brett says "check bee N", the queen invokes `/humancheck <bee>` — it switches into that bee's worktree, kills any live instance, and `/run`s the app hot-reloaded for Brett to eyeball.
- The live app runs ONLY here, serially — bees never launch it (single-instance apps would collide). One app at a time; checking another bee kills the current one.
- Precondition: `/run` needs the project's run-skill (the app-specific launch recipe — env, ports, shared daemons like a stripe listener). If it's missing, run `/run-skill-generator` once to write it (run the skill; don't reimplement it). App specifics live in that run-skill, never in swarm.

## Completion

- When all queues drain and PRs merge, report the hive complete and hand to `/wt` to reap the worktrees.

## Composition

- Plan with `/duck` or `/planit` first → `/swarm` runs the hive → each bee uses `/bee` (→ `/linear` + `/pr`) → Brett `/merge` between tasks → `/wt` reaps at the end.
- Verification: queen invokes `/humancheck` → `/run` (→ `/run-skill-generator` if no run-skill yet).
- Uses `/loop` for check-ins. The queen never merges — Brett does.
