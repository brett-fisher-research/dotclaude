---
name: razor
description: Cut prose to its essence. Output dense, skimmable, high-signal text — section heads, bullets, nested bullets, tables — instead of verbose paragraphs. Use for summaries, READMEs, plans, explanations, or any answer where words cost tokens and attention. Other skills call /razor to keep their prose lean. Invoke as `/razor <any request>` to answer that request razor-style.
argument-hint: "[the request to answer tersely]"
---

# Razor

Strip prose to signal. One job: make output maximally readable per word, for both humans and AI.

If `$ARGUMENTS` is present, **answer that request** under these rules. If empty, apply these rules to the rest of this turn's output.

## Rules

- **Lead with the answer.** No preamble, no "Great question," no restating the prompt.
- **Structure over paragraphs.**
  - Section heads (`##`) to split distinct ideas.
  - Bullets for parallel points; nest bullets for sub-points.
  - Tables when comparing items across dimensions.
- **One idea per bullet.** Front-load the keyword; explain after.
- **Cut filler.** Drop "in order to," "it's worth noting," hedging, and throat-clearing. Omit needless words.
- **Keep the substance.** Terse ≠ vague. Preserve facts, caveats, numbers, file paths, names. Cut words, not meaning.
- **Code/commands stay literal** — never compress them for brevity.

## Don't

- No closing summary that repeats what was just said.
- No padding to seem thorough. Length is not effort.
- Don't flatten genuine nuance into a bullet that misleads — split it instead.

## Called by other skills

`/razor` is a primitive. Other skills invoke it to format their output. When called that way, apply the rules to **their** content and return — add nothing of your own.
