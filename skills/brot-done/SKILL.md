---
name: brot-done
description: End brot mode and clean up. Verify every box in BROT_PLAN.md is checked, then delete the gitignored plan file. Use when the user says "/brot-done", "end brot mode", or the brot plan is fully built.
---

# Brot Done
One job: end **brot mode** (entered via [/brot-start](../brot-start/SKILL.md)) and clean up.

- Verify EVERY box in `BROT_PLAN.md` is checked. If any remain unchecked, WARN — list them — and require explicit confirmation before proceeding.
- Delete the gitignored `BROT_PLAN.md`. The durable record is the merged PRs, not this scratch file.

Then print this block:

```
🥨 BROT MODE ENDED 👋
```
