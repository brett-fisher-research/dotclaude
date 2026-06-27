---
name: humansteps
description: Lay out the manual steps Brett must do himself — to verify a change or set up something external (create a Discord bot, copy API keys, click through a dashboard) — in a fixed, skimmable format. Use whenever work needs Brett to act outside the agent (manual setup, verification, credentials), or when invoked as /humansteps.
argument-hint: "<what the human needs to do or verify>"
---

# Human steps

One job: tell Brett exactly what HE must do by hand, in a predictable format — nothing the agent can do itself.

## Two modes (detect from context)

- VERIFY — confirm a change works (click here, check this value).
- SETUP — do an external/manual task the agent can't (log into a service, create an app, copy secrets back).

## Rules

- Only TRUE human steps. If the agent can do it, the agent does it — don't list it.
- Each step: imperative action + where + the observable result to expect.
- Secrets/keys: tell Brett what to copy and where to paste it back; never ask him to paste a secret into chat unless needed, and say so plainly.
- Prose via `/razor`; shape via `/structure`.

## Fixed output format (the contract)

```
🧑 Human steps — <verify | setup>: <subject>

1. <imperative action> — <where / how>
   → expect: <observable result>
2. <next action> — <where / how>
   → expect: <observable result>

✅ Done when: <the end state you should see>
📋 Paste back: <what to return to me, or "nothing">
```

- Keep steps minimal and ordered. Split a step if it hides two actions.
- Omit `📋 Paste back` only when truly nothing comes back.

## Composition

- A primitive, callable anywhere — often after `/pr` (verify), or mid-`/swarm` when a bee or the queen hits an external gap.
- Conforms to `/structure`; written via `/razor`.
