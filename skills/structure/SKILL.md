---
name: structure
description: Brett's house style for structured, skimmable output — section heads, bullets, tables, fixed formats, emoji markers. A primitive other skills inject so their output is predictable and easy to scan. Use when shaping any non-trivial response, or when invoked as /structure.
---

# Structure

One job: define how output is SHAPED so it's skimmable and predictable. Not what to say — how to lay it out.

## Relationship to /razor

- `/razor` cuts prose to dense signal (fewer words).
- `/structure` governs the shape around it (heads, tables, fixed blocks, markers).
- Use both: razor the words, structure the layout.

## The style

- Lead with the answer. No preamble.
- Section heads (`##`) to split distinct ideas.
- Bullets for parallel points; nest for sub-points. One idea per bullet, keyword first.
- Tables when comparing items across dimensions.
- Fixed, repeatable formats for recurring output — same shape every time, so it's parsed at a glance (model the discipline on `/pr`'s result block).
- Emoji markers as labels for fixed blocks (e.g. `✅`, `👉`, `🧑`) — sparingly, as signposts.
- No inline markdown emphasis (no `**bold**` / `*italic*`). Heads, backticks, tables, bullets survive raw reading; inline markup does not.
- Code, commands, paths stay literal — never reshaped for looks.

## Not a schema library

- This skill holds the STYLE, not concrete templates.
- Each consuming skill owns its OWN fixed format (its table columns, its result block) — written in this style.
- Deliberately small. The definition evolves as the house style sharpens.

## Composition

- A primitive, like `/razor`. Other skills reference it to keep their output predictable; it adds no content of its own.
- Pair with `/razor` for any structured response.
