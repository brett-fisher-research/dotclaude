---
name: diagrams
description: Render an ASCII diagram — flowchart, sequence diagram, or web/component mockup — that works in any plain-text AI chat. Picks the right kind from context, asks if unclear. Use when Brett wants something diagrammed, visualized, a flow or sequence drawn, or a UI mocked in ascii; or when invoked as /diagrams.
argument-hint: "<what to diagram> (optionally: flowchart | sequence | mockup)"
---

# Diagrams

One job: draw ONE ascii diagram of the thing, legibly, in plain text that renders anywhere.

## Kinds

- flowchart — processes, decisions, control flow (boxes + arrows).
- sequence — interactions over time between actors/systems; use when ordering and messages matter (the technical one).
- mockup — ascii art of a web page or component layout.

## Choosing the kind

- If Brett named one, use it.
- Else infer from the ask: a process → flowchart; who-calls-what-when → sequence; what-it-looks-like → mockup.
- If genuinely unclear, ASK which before drawing — one quick question, don't guess wrong.

## Rules

- Text only — boxes, pipes, arrows. No images, no mermaid. Must read raw in any chat.
- Label nodes; show direction. Keep it legible — if it's getting dense, simplify or split, don't cram.
- Draw the diagram and little else. Brief caption if needed; no essay.

## Boundaries (SRP)

- Only draws. Does NOT generate options (`/suggest`) or plan (`/planit`).
- `/suggest` must not call this — Brett invokes `/diagrams` himself on a chosen option.

## Composition

- Pairs with `/suggest` (picture a chosen option) and `/planit` (diagram a flow inside a plan). Useful standalone. Conforms to `/structure`.
