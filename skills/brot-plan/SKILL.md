---
name: brot-plan
description: Create a Mandelbrotian plan (brot plan for short). This means we break down a task of arbitrary size into 2-3 well-defined steps, then if those steps need additional clarity, we break those into 2-3 steps, etc. until we are left with the smallest units of work.
---

# Brot Plan
A lot of plans struggle with ambiguity and complexity. This is where Brot plan comes in. We plan in a fractal manner: start by defining the 2-3 "big rocks" of the plan, then recursively clarify each step with additional steps until we are left with small units of work. 

When coding for example, my goal may be "ship a web application to find the nearest coffee shop to you with a $10 monthly paid subscription". We may have steps like "1. Design the app with user flows and Figma diagrams, 2. Build and deploy the production app, 3. Make a profit on the app". Then further tasks would include planning the designs, talking through the flows, creating designs, deciding on infra, writing Terraform scripts to deploy the infra, creating a marketing plan, setting up recurring reminders to post on X or Reddit, etc.

Notice how the tasks we create can involve further planning. When I later pick up the tasks we've created, I will then plan those out with the /brot-plan skill again.

Use /template goal for defining each step of the plan. 