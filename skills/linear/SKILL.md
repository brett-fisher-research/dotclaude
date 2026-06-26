---
name: linear
argument-hint: '[issue-id]'
description: >-
    Pick up a Linear ticket to start work: read the issue and ALL its comments (or create a ticket if
    none exists), mark it In Progress, then hand off to /planit for planning. Use when the user says
    "/linear", references a Linear issue (e.g. FIS-123), or asks to start work tracked in Linear.
allowed-tools: Bash Read
---

# Linear — ticket intake

One job: **turn a request into a tracked, In-Progress Linear ticket, then hand a clear problem
statement to `/planit`.** This skill owns Linear I/O only. It does not plan, branch, or write code —
those are `/planit`, `/pr`, `/raise`, `/merge`.

You have the Linear MCP server. The user wants to start work on `$0` (an issue id, or empty).

## Steps

1. **Find or create the ticket.**
   - If `$0` is an issue id (e.g. `FIS-123`), use it.
   - If empty, infer the intended ticket from the conversation. If a matching ticket plausibly
     exists, confirm it; otherwise **create one** — we track all work in Linear. Give it a clear
     title, the right team/project, and a sensible label (see conventions). Ask only when the
     team/project is genuinely ambiguous.

2. **Read it fully.** Read the issue description **and every comment** — comments often carry the
   latest decisions. Note any linked parent/sub-issues and blocking relationships.

3. **Mark it In Progress.**

4. **Hand off to `/planit`.** Invoke `/planit` with the ticket's intent so it produces a plan in chat
   for the user to approve. Planning, approval, and everything after belong to the other skills — do
   not start designing solutions here beyond restating the problem.

## After the plan is approved

The work continues by composition (this is just the on-ramp):

```
/linear  → In Progress        (this skill)
/planit  → plan in chat, approve
/pr      → branch <ID>/<slug> + implement + commit each step
/raise   → push + open PR  → comments PR url + sets In Review   (branch named <ID>/slug)
/merge   → squash          → sets the issue Done                (branch named <ID>/slug)
```

**Branch-name contract:** `/pr` names the branch `<ID>/<short-slug>` (e.g. `FIS-123/dark-mode`) when a
ticket is in play. That prefix is how `/raise` and `/merge` know which ticket to update — keep it.

## Linear conventions

- **Every ticket gets a label.** Common ones: `Feature` (new/additive work), `Bug`, `Documentation`,
  `Spike` (research), plus whatever the workspace uses. Be proactive — don't ask which label to add.
- **Use parents + sub-issues** when a unit splits into several independently shippable pieces; keep a
  single cohesive change as one flat ticket.
- When creating a ticket, write a real description (goal + scope + done-when), not a one-liner.
