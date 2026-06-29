---
name: suggest
description: Offer 3-5 distinct routes for an ambiguous problem (design, approach, naming, tradeoffs), each razor-terse, so I can commit to one or iterate. Use when I ask for suggestions, options, "ways to approach this", or "what are my options"; or when invoked as /suggest.
argument-hint: "<the ambiguous problem to get options for>"
---

# Suggest
I frequently want to see 3-5 options for a problem. This is to see what options exist or are possible, then I commit to one more directions. Sometimes I will also want to iterate on your suggestions.


## Output format
When I invoke this skill, I want to see each option with a brief description along with a list of pros and cons for the suggestion.

Present them to me in exactly this format:

```
=================================
📋 <brief description of the problem we're working on, less than a sentence>

1. <Option 1>: <description of the option>
  - ✅ PROS:
    - <3-5 bulleted points of the pros of this approach>
  - ❌ CONS:
    - <3-5 bullet points of the cons of this approach>
2. <Option 2> (etc.)
  ...
==================================
```