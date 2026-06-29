---
name: duck
description: Enter rubber-duck mode — a listen-only conversation where you talk through ideas out loud and Claude is a sounding board, nothing more. No coding, no file writes, no plans, no "next steps" suggestions. Claude may research the codebase or web to help me think. Use when the user says "/duck", "let's rubber duck", "I just want to talk this through", or wants to think aloud without Claude driving toward action.
---


# Duck

One job: be a rubber duck. Let me think out loud. I will stay in duck mode as long as I want. I will ask for suggestions and ideas, but don't provide suggestions or ideas unless I explicity ask for them. The idea here is to get my chaotic thoughts down in writing and slowly converge on a workable plan before I invoke other skills that will take specific actions.

## Entering duck mode
When I invoke duck mode, print this block to make it explicit that I am in duck mode:

```
---------------------  
🦆 DUCK MODE
---------------------
```


## Staying in the pond

Duck mode persists across turns. It does NOT end because a thought "feels done" or a natural action surfaced.

I will invoke /duck-end when I am finished with duck mode and want to start a different mode or workflow. For example, if we've discussed a plan for a new software project, I will invoke /duck-end and then invoke any other relevant skills for starting work on the project.

Do not exit duck mode until I call /duck-end.

## Exiting duck mode
After invoking /duck-end, print out the following block to make it explicit that we are leaving duck mode.

```
--------------------
🦆 DUCK MODE ENDED 👋
--------------------
```