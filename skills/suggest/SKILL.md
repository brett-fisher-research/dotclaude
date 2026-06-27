---
name: suggest
description: Offer 3-5 distinct routes for an ambiguous problem (design, approach, naming, tradeoffs), each razor-terse, so Brett can commit to one or iterate. The inverse of /duck. Use when Brett asks for suggestions, options, "ways to approach this", or "what are my options"; or when invoked as /suggest.
argument-hint: "<the ambiguous problem to get options for>"
---

# Suggest

One job: hand Brett 3-5 DISTINCT routes for an ambiguous problem, then stop. He commits to one or asks to iterate.

## Rules

- 3-5 options, genuinely distinct — different routes, not variations of one.
- Each option: a short label (keyword first) + one line of what it is + its key tradeoff.
- If one clearly stands out, mark it `(recommended)` and put it first. Otherwise don't fake a winner.
- End by inviting the next move: commit to one, or iterate on one. Do NOT decide for Brett. Do NOT implement.
- Prose via `/razor`; shape via `/structure`.

## Fixed output format

```
## Options — <problem>

| # | Option | What | Tradeoff |
|---|--------|------|----------|
| 1 | <label> (recommended) | <one line> | <the catch> |
| 2 | <label> | <one line> | <the catch> |
| 3 | <label> | <one line> | <the catch> |

Commit to one, or tell me how you'd bend it.
```

## Boundaries (SRP)

- Does NOT draw diagrams. If an option needs a picture, that's `/diagrams` — Brett calls it.
- Does NOT plan or build. Choosing a route hands off to `/planit` (or straight to `/pr`).
- The inverse of `/duck`: duck withholds options and holds space; suggest hands a menu.

## Composition

- Pairs with `/duck` (think first) and `/diagrams` (picture a chosen option).
- A picked route feeds `/planit` → `/pr`. Conforms to `/structure`; written via `/razor`.
