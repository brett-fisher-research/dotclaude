---
name: brot-start
description: Execute a BROT_PLAN.md by fanning out subagents wave by wave, parallelizing file-disjoint lanes. Continues persistent "brot mode" from /brot-plan. Use when the user says "/brot-start", "execute the plan", or wants the brot plan built.
---

# Brot Start
One job: execute `BROT_PLAN.md`. Continues **brot mode** from [/brot-plan](../brot-plan/SKILL.md) — stay in it across turns; end only at `/brot-done`.

On entry, print this block:

```
🥨 BROT MODE · EXECUTING
```

## Execute
- Read `BROT_PLAN.md`. Spawn subagents **wave by wave**; run file-disjoint lanes within a wave concurrently (one batch).
- Hand each subagent a `/template goal` (clear definition-of-done). Each writes its tests into `tests/`, makes `npm run test` green, and ticks its OWN checkboxes in `BROT_PLAN.md`.
- Gate on Brett's review + `/pr` → `/merge` between landable units. Stay in brot mode throughout.

## Hand off
`/brot-done` when the plan is drained.
