---
name: planit
argument-hint: '[what to plan]'
description: >-
    Produce an implementation plan and print it IN CHAT for approval — terse (via /razor), with ASCII
    diagrams for flows and ASCII option diagrams when a UX/design decision is needed. The plan is not
    complete until the user approves it; no code is written. Use before implementing any non-trivial
    change, or when invoked by /linear.
---

# Planit — plan in chat, then gate on approval

One job: turn a problem into a plan the user approves, printed in chat. No file writes, no code.
Standalone-invokable, or called by `/linear` after ticket intake.

Plan the work in `$ARGUMENTS` (or the ticket/context handed in by `/linear`).

## Rules

1. Print the plan in chat. Never write it to a file. (No `.features/`, no `PLAN.md`.) The chat is
   the artifact.
2. Keep it terse — use `/razor`. Dense, skimmable: section heads, bullets, tables. No padding.
3. Diagram the flows in ASCII. Any non-trivial control flow, architecture, or data path gets an
   ASCII diagram, not a paragraph.
4. Surface decisions as ASCII options. When the work needs a choice — especially a UX/layout
   choice — present 2–3 concrete alternatives as ASCII wireframes/diagrams and use `AskUserQuestion`
   to let the user pick. Iterate on the wireframe until they're happy.
5. Cover what a builder needs: approach, files to add/change, flows, docs to update (per the
   repo's own conventions / `CLAUDE.md` — defer specifics to the repo, don't hardcode), risks and
   cut-lines, and how it'll be verified.
6. GATE — not done until approved. End by explicitly asking whether the plan is good. Iterate on
   feedback. Do not start coding. Approval is the only exit.

## After approval

Hand off to `/pr` to branch and implement (committing every step), then `/raise`, then `/merge`.
`/planit` itself stops at "approved."

## Anti-goals

- Don't implement, branch, or touch git — that's `/pr`.
- Don't manage Linear status — that's `/linear` (start) and `/raise` + `/merge` (finish).
- Don't bury a real choice in prose. If it's a decision, make it a visible, selectable option.
