---
name: brot-plan
description: Turn a goal (usually post-/duck) into a recursive, deterministic plan. Break the goal into big rocks, then recurse each rock into sub-steps until every leaf is an atomic unit of work with a verifiable done-gate. Enters persistent "brot mode". Use when the user says "/brot-plan" or wants a fractal, parallelizable plan before building.
---

# Brot Plan
One job: turn a goal into a recursive, deterministic plan. This enters **brot mode** — a persistent build mode (plan → start) that survives turns and ends only at `/brot-done`, just like /duck persists until /duck-end.

On entry, print this block:

```
🥨 BROT MODE · PLANNING
```

## Plan recursively (the whole point)
- Break the goal into 2-3 **big rocks**.
- RECURSE each rock into 2-3 sub-steps, and each of those again, until every **leaf is atomic** — a single unit of work. The rule: don't stop at the top rocks (the old version's mistake); recurse all the way to atomic leaves.
- EVERY leaf carries a deterministic, verifiable **done-gate**. Use `/template goal` as each leaf's contract.
- Group leaves into dependency **waves** and, within a wave, file-disjoint **lanes** so `/brot-start` can parallelize them.
- Early task: "stand up the `tests/` harness if absent."

## Test convention
All tests live in `tests/`. ONE command runs them all: `npm run test` (unit + shell tests). A unit is "done" only when its goal-template gates have passing tests AND the whole suite stays green.

## Output
PRINT the recursive plan in chat for approval. THEN write it to a **gitignored** `BROT_PLAN.md` at the project root: nested `- [ ]` checkboxes, including a verification box per leaf.

## Hand off
Stay in brot mode. `/brot-start` to execute the plan; `/brot-done` to clean up and exit.
