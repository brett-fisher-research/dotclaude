---
name: brot-done
description: End brot mode and clean up. The coding agent merges the open PR, then teardown stops the dev-server and coding-agent background agents, verifies every box in BROT_PLAN.md is checked, and deletes the gitignored plan file. Use when the user says "/brot-done", "end brot mode", or the brot build is finished and merged.
---

# Brot Done
One job: end brot mode (entered via [/brot-plan](../brot-plan/SKILL.md)) and clean up.

## Merge (the coding agent's job)
- The coding agent runs `/merge` on its open PR — merging is the dev's job, not the PM's. The PM never merges (strict SRP, same boundary as `/brot-bot`).

## Teardown
- Stop the dev-server background agent from `/brot-dev`.
- Stop the `/brot-bot` coding agent.
- Verify EVERY box in `BROT_PLAN.md` is checked. If any remain unchecked, WARN — list them — and require explicit confirmation before proceeding.
- Delete the gitignored `BROT_PLAN.md`. The durable record is the merged PRs, not this scratch file.

Then print this block:

```
🥨 BROT MODE ENDED 👋
```
