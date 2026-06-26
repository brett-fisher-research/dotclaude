---
name: new-skill
argument-hint: "[what the new skill should do]"
description: Scaffold a new skill that follows the unix philosophy — one job, done extremely well, composable with the others. Use when the user says "/new-skill", "create a skill", "add a skill", or wants to turn a repeated workflow into a reusable skill. Enforces single-responsibility (splits multi-job requests), writes all prose via /razor, and wires the new skill into the existing chain.
---

# New skill — scaffold a single-purpose skill

One job: create a new skill that does **one thing extremely well**. See `../CLAUDE.md` for the philosophy.

The user wants a skill that does `$ARGUMENTS` (an intent, or empty — then infer from the conversation).

## 1. Find the one job

- **State the job in one sentence.** If you can't, the scope is wrong.
- **Reject bundling.** If the request packs multiple jobs ("do X and Y and Z"), STOP. Propose splitting into separate skills that compose. Don't scaffold a monolith.
- **Check for overlap.** Scan `skills/` (`ls C:/Users/Brett/.claude/skills`). If an existing skill already owns this job, extend it instead of duplicating.

## 2. Name it

- `<name>` is short, kebab-case, verb-or-noun for the single job (e.g. `razor`, `merge`).
- Path: `skills/<name>/SKILL.md`. Confirm the dir doesn't already exist.

## 3. Write it — all prose via `/razor`

Invoke `/razor` to write **every** prose part: the `description` and the body. Code, commands, and frontmatter keys stay literal.

Frontmatter:
- `name` — matches the dir.
- `description` — what it does + **when to use it** (trigger phrases). This is how the skill gets selected; make it specific.
- `argument-hint` — optional; only if the skill takes args.

Body:
- Lead with the one-job statement.
- Terse, structured (heads + bullets), skimmable.
- Handle `$ARGUMENTS` / `$0` if the skill takes input.

## 4. Wire it into the chain

- End the SKILL.md by naming **how it composes** — which skill precedes it, which follows, what it hands off.
- If it slots into the `/linear → /planit → /pr → /raise → /merge` flow, say where.
- Keep it portable: push tracker/tool-specific concerns into the skill that owns them, not this one.

## 5. Hand off

- New skills live in this repo → land via the PR flow. Tell the user it's scaffolded; `/pr` already running this change will commit it, then `/raise`.

## Composition

- Calls `/razor` (primitive) for all prose.
- Runs inside `/pr` when the new skill is a tracked code change.
- Reads `../CLAUDE.md` for the philosophy it enforces.
