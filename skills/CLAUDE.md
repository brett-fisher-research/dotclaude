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
/pr      branch + commit every step + push + open PR
/merge   squash-merge + return to base
```

- `/linear` is the only skill that touches Linear — the rest are tracker-agnostic.
- `/razor` is a primitive: other skills call it to format their prose. It adds nothing of its own.

The wider arc, from fuzzy thought to merged code:

```
/brot-board    think out loud on a permissive whiteboard, no pressure to act (the off-ramp)
/suggest       3-5 distinct routes for an ambiguous problem
/diagrams      one ascii diagram (flowchart | sequence | mockup)
/brot-plan     break a goal into a recursive, deterministic plan → gitignored BROT_PLAN.md; enters brot mode
/brot-dev      start the hot-reloaded dev server once in a bg agent; logs → .logs/
/brot-bot      build BROT_PLAN.md in ONE background coding agent: test per leaf, ticks its boxes, raises /pr
/brot-done     end brot mode: dev merges the PR, teardown bg agents, confirm boxes, delete the plan
/pr            branch + commit + push + open PR
/merge         squash-merge + return to base
/wt            isolate work in a worktree; reap on merge
/brot-template grab an output template (goal | plan | humansteps)
```

The brot lifecycle — think → plan → build → clean:

```
/brot-board → /brot-plan → /brot-bot → /brot-done
```

- The brot split (strict SRP): the PM (main thread) plans, watches, chats; ONE background coding agent (`/brot-bot`) does the full dev lifecycle (code → tests → `/pr` → `/merge`). The PM never codes/PRs/merges; the dev never does PM work.
- Primitives (reused, add no content of their own): `/razor` (dense prose), `/brot-template humansteps` (manual steps in a fixed format).
- `brot mode` and `/brot-board` are modes: invoked once, they hold the session's posture across turns until done.
- `/brot-bot` assumes a `BROT_PLAN.md` exists — run `/brot-plan` first (think on `/brot-board` upstream).
- `/brot-dev` runs the app alongside the build; every brot skill reads its `.logs/` instead of starting its own server.
- Verify-time (Claude Code bundled skills): `/run` launches the app, `/verify` runs + observes it, `/run-skill-generator` writes a project's per-app launch recipe once. App-specific launch (env, ports, shared daemons) lives in the project run-skill.

## Prose rule

- All prose uses `/razor`. SKILL.md bodies, frontmatter `description`s, and this CLAUDE.md — write them dense and skimmable via `/razor`. Words cost tokens and attention.
- No inline markdown emphasis (no `**bold**`/`*italic*`). Backticks, headers, tables, bullets stay — prose must read cleanly in raw form (diffs, plain editors, AI readers).
- Code, commands, and frontmatter keys stay literal — never compress them.

## Skill file shape

- Path: `skills/<name>/SKILL.md`
- Frontmatter: `name`, `description` (required); `argument-hint` (optional).
- Body: terse, structured, ends with how it composes with other skills.
