# Skills — unix philosophy

Each skill does one thing extremely well. Skills are composable primitives, not monoliths. Larger workflows emerge by chaining small skills — never by bloating one.

## Principles

- One job per skill. A skill has a single responsibility. If you can't state its job in one sentence, it's too big — split it.
- Compose, don't accumulate. Build workflows by chaining skills, not by adding branches to an existing skill.
- Small and focused. Short SKILL.md, narrow scope, clear handoffs. Prefer two sharp skills over one Swiss-army skill.
- Tracker/tool-agnostic where possible. Keep side concerns (tickets, formatting) in their own skill so the rest stay portable.
- Clear handoffs. A skill ends by naming the next skill, not by doing its job.

## Composition in practice

Existing chain — each link is independently useful:

```
/linear  read/create ticket + In Progress
/planit  plan in chat, approve
/pr      branch + commit every step + push + open PR
/merge   squash-merge + return to base
```

- `/linear` is the only skill that touches Linear — the rest are tracker-agnostic.
- `/razor` is a primitive: other skills call it to format their prose. It adds nothing of its own.

The wider arc, from fuzzy thought to merged code:

```
/duck        think out loud, no action (the off-ramp)
/suggest     3-5 distinct routes for an ambiguous problem
/diagrams    one ascii diagram (flowchart | sequence | mockup)
/planit      plan in chat, approve
/brot-plan   break a goal into a recursive, deterministic plan → gitignored BROT_PLAN.md; enters brot mode
/brot-start  execute BROT_PLAN.md: fan out file-disjoint subagent lanes, each /template goal + tests/; gated on review/merge
/brot-done   end brot mode: confirm all boxes checked, delete the plan, exit
/pr          branch + commit + push + open PR
/merge       squash-merge + return to base
/wt          isolate work in a worktree; reap on merge
```

The brot lifecycle — think → plan → swarm → clean:

```
/duck → /brot-plan → /brot-start → /brot-done
```

- Primitives (reused, add no content of their own): `/razor` (dense prose), `/humansteps` (manual steps in a fixed format).
- `brot mode` and `/duck` are modes: invoked once, they hold the session's posture across turns until done.
- `/brot-start` assumes a `BROT_PLAN.md` exists — run `/brot-plan` first (plan with `/duck` or `/planit` upstream).
- Verify-time (Claude Code bundled skills): `/run` launches the app, `/verify` runs + observes it, `/run-skill-generator` writes a project's per-app launch recipe once. App-specific launch (env, ports, shared daemons) lives in the project run-skill.

## Prose rule

- All prose uses `/razor`. SKILL.md bodies, frontmatter `description`s, and this CLAUDE.md — write them dense and skimmable via `/razor`. Words cost tokens and attention.
- No inline markdown emphasis (no `**bold**`/`*italic*`). Backticks, headers, tables, bullets stay — prose must read cleanly in raw form (diffs, plain editors, AI readers).
- Code, commands, and frontmatter keys stay literal — never compress them.

## Skill file shape

- Path: `skills/<name>/SKILL.md`
- Frontmatter: `name`, `description` (required); `argument-hint` (optional).
- Body: terse, structured, ends with how it composes with other skills.
