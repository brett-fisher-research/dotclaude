---
name: lead-gen-site
description: Generate a free lead-magnet landing page for a prospective web design client. Use this skill whenever the user wants to generate a website or landing page for a new client, prospect, or lead — even if they just say "make a site for [business name]", "generate a page for my lead", or "create a landing page for [business type]". This skill drives variety by selecting across 3 design dimensions, auto-suggesting values based on the business type and prompting the user to confirm or override before building.
---

# Lead-Gen Site Generator

You are helping a web design agency owner quickly generate free, impressive landing pages for prospective clients. The goal is a polished, realistic-looking site that motivates the prospect to hire the agency for the full build.

**Philosophy**: Variety is everything. Each site must feel purpose-built for that specific business — not like an AI template. Three design dimensions control the output; randomness within each dimension, guided by business context, is the engine of variety.

---

## Step 1: Gather Business Info

Ask the user for (or extract from what they've already said):

- **Business name**
- **Business type / industry** (e.g., "dog groomer", "roofing contractor", "yoga studio")
- **Location** (city/region, for local flavor in copy)
- **Any notes** — tagline, key service, tone preferences, anything they mention

If the user has provided all of this, skip straight to Step 2.

---

## Step 2: Auto-Select Dimension Values

Based on the business type, select one value from each of the three dimensions below. Use the **Business Type → Dimension Guidance** table to inform your choices, but feel free to make bold, unexpected choices that will still feel right for the business.

### The Three Dimensions

---

### Dimension 1: Visual Style
*The overall aesthetic personality — colors, fonts, mood.*

| # | Value | Description |
|---|-------|-------------|
| 1 | **Minimalist** | Lots of white space, one accent color, clean sans-serif, understated |
| 2 | **Bold & Playful** | Bright saturated palette, rounded fonts, fun iconography, energetic |
| 3 | **Warm & Organic** | Earthy tones (terracotta, sage, cream), serif fonts, natural textures |
| 4 | **Corporate Professional** | Navy/grey palette, structured layout, trust signals, formal typography |
| 5 | **Dark & Dramatic** | Dark background, high-contrast accents, moody photography, luxury feel |
| 6 | **Retro / Vintage** | Muted palette, serif/slab fonts, grain textures, nostalgic feel |
| 7 | **Tech / Futuristic** | Dark bg with neon accent, monospace or geometric fonts, grid lines |
| 8 | **Editorial / Magazine** | Large display type, varied column widths, editorial photography framing |
| 9 | **Handcrafted / Artisan** | Textured paper bg, hand-drawn accents, script + serif pairing |
| 10 | **Luxury / Premium** | Gold/black/ivory, elegant serif, restrained layout, high-end feel |

---

### Dimension 2: Layout Architecture
*The structural skeleton — how sections are arranged and weighted.*

| # | Value | Description |
|---|-------|-------------|
| 1 | **Hero-Dominant** | Massive hero (80vh+), minimal scroll, one strong CTA |
| 2 | **Asymmetric / Broken Grid** | Elements break column structure, overlapping layers, dynamic tension |
| 3 | **Full-Width Sections** | Each section bleeds edge-to-edge with alternating color blocks |
| 4 | **Split-Screen** | Left/right halves tell parallel stories (text vs image, etc.) |
| 5 | **Card Grid** | Services/features in a neat grid of cards below a modest hero |
| 6 | **Single-Column Narrative** | Centered, linear scroll — feels like a well-designed article |
| 7 | **Feature-Row Alternating** | Text-left/image-right, image-left/text-right, repeating rhythm |
| 8 | **Story-Scroll / Cinematic** | Each scroll step reveals a full-screen "chapter" of the story |
| 9 | **Sidebar + Main** | Persistent left nav or info panel; main content scrolls right |
| 10 | **Dashboard-Style** | Stats, metrics, proof points in structured panel layout |

---

### Dimension 3: Content Density
*How much information is on screen at once.*

| # | Value | Description |
|---|-------|-------------|
| 1 | **Ultra-Sparse** | One idea per screen; whitespace is the design element |
| 2 | **Minimal** | 1–2 elements per section; gets to the point fast |
| 3 | **Balanced** | Standard landing page density; hero + 3–4 sections |
| 4 | **Feature-Rich** | Icons + short copy + images; communicates breadth of services |
| 5 | **Social Proof-Heavy** | Testimonials, star ratings, review counts front and center |
| 6 | **Stats & Numbers** | Key metrics ("500+ clients", "15 years experience") as visual anchors |
| 7 | **FAQ-Expanded** | Long-form page with expandable FAQ, detailed service descriptions |
| 8 | **Text-Dominant / Editorial** | Long-form copy, storytelling, narrative-driven |
| 9 | **Image-Dominant** | Photography-first; minimal text, images carry the message |
| 10 | **Everything Above Fold** | Critical info compressed into one punchy visible screen |

---

### Business Type → Dimension Guidance

Use this as a starting point. Deviate when it makes the result more interesting.

| Business Type | Visual Style | Layout | Content Density |
|---|---|---|---|
| Restaurant / Cafe | Warm & Organic OR Retro | Full-Width Sections | Image-Dominant |
| Home Services (plumber, roofer, HVAC) | Corporate Professional | Feature-Row Alternating | Stats & Numbers |
| Fitness / Yoga / Wellness | Bold & Playful OR Minimalist | Hero-Dominant | Balanced |
| Beauty / Salon / Spa | Luxury OR Warm & Organic | Asymmetric | Social Proof-Heavy |
| Legal / Accounting / Finance | Corporate Professional | Full-Width Sections | Feature-Rich |
| Creative / Design / Photography | Editorial OR Minimalist | Asymmetric | Image-Dominant |
| Tech / SaaS / Software | Tech/Futuristic | Split-Screen | Stats & Numbers |
| Retail / E-commerce | Bold & Playful OR Luxury | Card Grid | Feature-Rich |
| Real Estate | Luxury OR Minimalist | Hero-Dominant | Social Proof-Heavy |
| Education / Coaching | Warm & Organic | Single-Column Narrative | FAQ-Expanded |
| Medical / Dental / Health | Corporate Professional | Sidebar + Main | Balanced |
| Trades / Contractors | Corporate Professional | Feature-Row Alternating | Stats & Numbers |
| Non-profit / Community | Warm & Organic OR Bold & Playful | Story-Scroll | Text-Dominant |

---

## Step 3: Present Suggestions & Get Confirmation

Present your selections like this:

```
Here's what I'm thinking for [Business Name]:

1. Visual Style        → Warm & Organic (#3)
2. Layout Architecture → Feature-Row Alternating (#7)
3. Content Density     → Social Proof-Heavy (#5)

Type a number to change any dimension, or say "go" to build it.
Example: "change 1 to Dark & Dramatic" or "swap layout to Split-Screen"
```

Wait for the user to confirm or request changes. Apply any changes they request, then proceed when they say go (or equivalent).

---

## Step 4: Build the Site

Generate a single, self-contained `index.html` file. All CSS and JavaScript must be inline — no external dependencies except Google Fonts (loaded via `<link>`) and optionally a CDN icon library like Lucide or Font Awesome.

### Content Guidelines

- **Write real copy** — not lorem ipsum. Use the business name, location, and industry to write plausible headlines, taglines, service names, and body copy. Make it feel like a real site.
- **Invent plausible details** — realistic phone number format, address format, hours, service names. The prospect should see their business reflected.
- **Include these sections** (adapt based on density dimension):
  - Hero (headline + subheadline + CTA)
  - Services / What We Do
  - Why Choose Us / Trust signals
  - Social proof (testimonials or review stars)
  - Contact / CTA closing section
  - Footer

### Design Execution Guidelines

Follow the selected dimension values faithfully. Key rules:

**Visual Style**: Set a CSS variable palette and font stack at the top. Commit fully — if it's Luxury, use gold accents and elegant serifs everywhere. If it's Bold & Playful, use saturated colors and rounded corners throughout.

**Layout Architecture**: The chosen architecture should define every section, not just the hero. If it's Asymmetric, multiple sections should break the grid. If it's Full-Width Sections, every section bleeds edge to edge with alternating backgrounds.

**Content Density**: Respect the density choice. Ultra-Sparse means short headlines, huge margins. Feature-Rich means icons + short bullets + images in grids.

### Technical Requirements

- Fully responsive (mobile-first)
- No broken layout at 375px or 1440px viewport
- Valid semantic HTML5
- Smooth scrolling nav (if multi-section)
- Page loads with no errors
- All fonts loaded from Google Fonts

### Images via Unsplash API

Images are fetched using the wrapper script at `~/.claude/skills/lead-gen-site/scripts/fetch_images.py`. This script reads your API key from a `.env` file — **never ask the user for the key or try to read it yourself**.

#### First-time setup (tell the user if the script fails)

No manual install needed if you have `uv`. Dependencies are declared in the skill's `pyproject.toml` and uv installs them automatically on first run.

If you don't have `uv` yet:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### How to fetch images

Before building the HTML, run the script with one keyword string per image slot (3–5 max).

**Important**: The script and its `pyproject.toml` live in the skill directory, not the project directory. You must use `--project` to point `uv` at the skill directory so it can find the dependencies. Run the command **from the project working directory** so the script's `load_dotenv(".env")` picks up the project's `.env` file (which contains `UNSPLASH_ACCESS_KEY`).

```bash
uv run --project ~/.claude/skills/lead-gen-site python ~/.claude/skills/lead-gen-site/scripts/fetch_images.py "roofing,roof,contractor" "construction,workers" "house,exterior"
```

**Do NOT** `cd` into the skill directory to run the script — that will break `.env` discovery. Always run from the project root.

The script returns JSON like:

```json
{
  "images": [
    {
      "query": "roofing,roof,contractor",
      "url": "https://images.unsplash.com/photo-abc123?...",
      "credit": "Photo by Jane Doe on Unsplash",
      "credit_url": "https://unsplash.com/@janedoe?utm_source=..."
    }
  ]
}
```

Use the `url` values as `<img src="...">` in the HTML. Include a small photo credit in the page footer using the `credit` and `credit_url` fields (required by Unsplash's API guidelines).

#### Image slot limits

Use **3–5 images maximum** per site to stay within the 50 requests/hour demo limit.

| Layout | Recommended slots |
|--------|------------------|
| Hero-Dominant | 1–2 |
| Feature-Row Alternating | 3–4 |
| Full-Width Sections | 2–3 |
| Split-Screen | 2 |
| Card Grid | 2–3 |
| Image-Dominant (density) | 4–5 |
| Minimal / Ultra-Sparse (density) | 1 |

#### Keyword guidance by business type

| Business | Hero query | Section queries |
|----------|-----------|-----------------|
| Roofing / contractor | `roofing,roof,contractor` | `construction,workers` / `house,exterior` |
| Restaurant / cafe | `restaurant,dining,food` | `coffee,cafe` / `chef,kitchen` |
| Yoga / fitness | `yoga,meditation,wellness` | `fitness,exercise` |
| Salon / spa | `spa,beauty,luxury` | `massage,skincare` |
| Real estate | `modern-home,architecture` | `interior,living-room` |
| Law / finance | `office,professional,business` | `meeting,suits` |
| Dental / medical | `clinic,healthcare,clean` | `doctor,professional` |
| Photography | `camera,photography,studio` | `portrait,light` |

Use different keyword combinations for each slot so images don't look similar.



NEVER use:
- Inter, Roboto, Arial, or system fonts as primary typeface
- Purple-to-blue gradients as default color scheme
- Generic card layouts with drop shadows as the only design pattern
- Cookie-cutter hero with centered text + button + stock photo placeholder

ALWAYS:
- Choose a distinctive display font pairing for the business type
- Make color palette decisions feel intentional and specific to the industry
- Add one unexpected visual detail that makes the design memorable

---

## Step 5: Deliver

Save the file as `[business-name]-landing.html` (slugified, lowercase, hyphens).

### Embed Dimension Choices as an HTML Comment

At the very top of the file, before the `<!DOCTYPE html>` declaration, insert a structured comment block recording the exact choices made. This allows any future Claude Code session (or the user) to instantly understand the design configuration without needing to re-specify it.

Format it exactly like this:

```html
<!--
  LEAD-GEN SITE CONFIG
  Business : Riverside Roofing
  Location : Phoenix, AZ
  Generated: 2025-06-12

  Design Dimensions:
  1. Visual Style        → Corporate Professional (#4)
  2. Layout Architecture → Feature-Row Alternating (#7)
  3. Content Density     → Stats & Numbers (#6)

  To edit: tell Claude "load the config from the comment at the top of this file"
  and it will read these settings and continue from where you left off.
-->
```

### When Editing an Existing File

If the user provides an existing file that already contains this comment block, read it first and treat those dimension values as the current configuration. Offer to change any of them before proceeding with edits.

### Tell the User

After delivering the file:
- One sentence about the design direction you took
- Remind them the config is saved in the top comment so future sessions can pick up where they left off
- Offer to tweak any dimension or regenerate with a different combination