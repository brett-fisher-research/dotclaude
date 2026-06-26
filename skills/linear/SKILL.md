---
name: linear
argument-hint: '[issue-id]'
description: >-
    Pick up a Linear ticket to start work: read the issue and ALL its comments (or create a ticket if
    none exists), mark it In Progress, then hand off to /planit for planning. This skill is the single
    home for all Linear interaction — it also updates the ticket after /raise and /merge. Use when the
    user says "/linear", references a Linear issue (e.g. FIS-123), or asks to start work tracked in Linear.
---

# Linear — the single home for ticket interaction

This is the **only** skill that talks to Linear. `/planit`, `/pr`, `/raise`, and `/merge` are
tracker-agnostic; they never touch Linear. All ticket reads and status writes live here, so the
workflow stays composable and the other skills work in any repo with no tracker at all.

You have the Linear MCP server. The user wants to start work on `$0` (an issue id, or empty).

## 1. Intake (when this skill runs)

1. **Find or create the ticket.**
   - If `$0` is an issue id (e.g. `FIS-123`), use it.
   - If empty, infer the intended ticket from the conversation. If a matching ticket plausibly
     exists, confirm it; otherwise **create one** — we track all work in Linear. Give it a clear
     title, the right team/project, and a sensible label (see conventions). Ask only when the
     team/project is genuinely ambiguous.
2. **Read it fully** — the description **and every comment** (comments often carry the latest
   decisions). Note linked parent/sub-issues and blocking relationships.
3. **Mark it In Progress.**
4. **Hand off to `/planit`** with the ticket's intent, so it produces a plan in chat for the user to
   approve. Don't design solutions here beyond restating the problem.

## 2. The rest of the lifecycle (Linear updates this skill owns)

`/pr` → `/raise` → `/merge` run on their own and stay Linear-free. This skill performs the ticket
updates at these points — do them as the flow reaches each step:

| When | Update the ticket to |
|---|---|
| Intake (above) | **In Progress** |
| After `/raise` opens the PR | add a **comment with the PR URL**, set **In Review** |
| After `/merge` lands the PR | **Done** |

```
/linear  read/create + In Progress      ← here
/planit  plan in chat, approve
/pr      branch <ID>/slug + commits
/raise   push + open PR
   └─ /linear: comment PR url + In Review
/merge   squash-merge
   └─ /linear: set Done
```

**Branch-name contract:** `/pr` names the branch `<ID>/<short-slug>` (e.g. `FIS-123/dark-mode`) when a
ticket is in play. That prefix is how this skill recovers which ticket to update after `/raise` and
`/merge` — keep it.

## Linear conventions

- **Every ticket gets a label.** Common ones: `Feature` (new/additive work), `Bug`, `Documentation`,
  `Spike` (research), plus whatever the workspace uses. Be proactive — don't ask which label to add.
- **Use parents + sub-issues** when a unit splits into several independently shippable pieces; keep a
  single cohesive change as one flat ticket.
- When creating a ticket, write a real description (goal + scope + done-when), not a one-liner.
