---
name: webapp
description: Scaffold a new Vite + React + TypeScript + Tailwind + Bun webapp with a responsive-image pipeline (sharp + LQIP blur-up + typed manifest). Use when the user asks to create a new React app, new landing page, new marketing site, or any frontend project from scratch — especially one that will display photos and needs them to load fast without layout shift. Do NOT use for modifying an existing React app or for non-frontend tasks.
---

# webapp — React + Tailwind + optimized images

A batteries-included chassis Brett uses for his React projects. Every decision below was already made and validated — don't re-litigate them, just execute.

**End state**: A Vite + React 18 + TypeScript + Tailwind v3 app, managed with Bun, with a `sharp`-based image pipeline that produces responsive WebP+JPEG variants, inline LQIP blur-ups, and a fully-typed manifest. Images drop into `selected_images/`, `bun run images` processes them, `<ResponsiveImage name="..." />` renders them with a fade-in on load and zero layout shift.

---

## Prerequisites

- **Bun** must be installed (`which bun`). Never use npm/yarn/pnpm in this stack — they'll generate competing lockfiles.
- Git repo initialized (or create one).

---

## Step 1 — Ask what the project is

Before scaffolding, confirm with the user:

1. **Project directory** — where on disk? Default: current working directory.
2. **Project name** — for `package.json` "name" field. Kebab-case.
3. **Theme hint** — keep defaults (off-white `bone` + off-black `ink`, Instrument Serif + Inter) or go another direction? If another direction, ask for 2–3 color swatches and a font pairing.

Don't ask about tooling (Vite, Tailwind, Bun, sharp) — those are fixed.

---

## Step 2 — Create project files

Create these files verbatim. Adjust only the `name` in `package.json` and the theme tokens in `tailwind.config.ts` if the user asked for a different palette.

### `package.json`

```json
{
  "name": "REPLACE_WITH_PROJECT_NAME",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "images": "bun run scripts/process-images.ts"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@vitejs/plugin-react": "^4.3.4",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.49",
    "sharp": "^0.33.5",
    "tailwindcss": "^3.4.15",
    "typescript": "^5.6.3",
    "vite": "^5.4.11"
  }
}
```

### `.gitignore`

```
node_modules/
dist/
.DS_Store
*.log
.vite/
.tscache/
*.tsbuildinfo

raw_images/
public/images/.cache.json
```

### `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "useDefineForClassFields": true,
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

### `tsconfig.node.json`

```json
{
  "compilerOptions": {
    "composite": true,
    "target": "ES2022",
    "lib": ["ES2023"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "outDir": "./.tscache/node"
  },
  "include": ["vite.config.ts"]
}
```

### `vite.config.ts`

The `server.watch.usePolling` block is there because Brett runs WSL2 with projects on the Windows filesystem (`/mnt/c/...`). Native inotify events don't cross that boundary, so without polling HMR silently stops working — every save looks like a no-op. Leave polling on; it costs a little CPU but it's the difference between a working and broken dev loop on WSL. On macOS/Linux-native it's harmless.

```ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    watch: {
      usePolling: true,
      interval: 300,
    },
  },
});
```

### `postcss.config.js`

```js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
```

### `tailwind.config.ts`

Defaults below are Brett's "premium off-white" theme. Swap colors/fonts if the user asked for something else.

```ts
import type { Config } from 'tailwindcss';

export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        bone: '#F6F2EC',
        ink: '#141210',
        muted: '#6B635A',
      },
      fontFamily: {
        display: ['"Instrument Serif"', 'ui-serif', 'Georgia', 'serif'],
        sans: ['Inter', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
} satisfies Config;
```

### `index.html`

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#F6F2EC" />
    <title>REPLACE_WITH_PROJECT_TITLE</title>
    <meta name="description" content="REPLACE_WITH_DESCRIPTION" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Inter:wght@400;500;600&display=swap"
    />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

### `src/main.tsx`

```tsx
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import './index.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>
);
```

### `src/App.tsx`

Stub — replace with actual page content after scaffolding.

```tsx
export default function App() {
  return (
    <main className="min-h-[100svh] bg-bone text-ink">
      <div className="mx-auto max-w-7xl px-6 py-12">
        <h1 className="font-display text-5xl">Hello world</h1>
      </div>
    </main>
  );
}
```

### `src/index.css`

`scroll-behavior: smooth` makes in-page anchor links (`href="#section"`) animate instead of snap. `scroll-padding-top: 5rem` offsets targets below a fixed top nav so the heading doesn't land under it — bump higher if the nav is taller. The `prefers-reduced-motion` override turns smooth scroll off for users who've opted out of animation in their OS settings.

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    color-scheme: light;
  }
  html {
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-rendering: optimizeLegibility;
    scroll-behavior: smooth;
    scroll-padding-top: 5rem;
  }
  @media (prefers-reduced-motion: reduce) {
    html {
      scroll-behavior: auto;
    }
  }
  body {
    @apply bg-bone text-ink font-sans;
  }
}
```

### `src/vite-env.d.ts`

```ts
/// <reference types="vite/client" />
```

### `src/generated/image-manifest.ts`

This is normally autogenerated by the image script, but the `ResponsiveImage` component imports from it. Create an empty stub so TypeScript compiles before any images exist.

```ts
// AUTO-GENERATED by scripts/process-images.ts — do not edit by hand.
export type ResponsiveVariant = { width: number; src: string };

export type ProcessedImage = {
  slug: string;
  width: number;
  height: number;
  lqip: string;
  sources: {
    webp: ResponsiveVariant[];
    jpeg: ResponsiveVariant[];
  };
};

export const images = {} as const satisfies Record<string, ProcessedImage>;

export type ImageKey = keyof typeof images;
```

### `src/components/ResponsiveImage.tsx`

```tsx
import { useState } from 'react';
import { images, type ImageKey, type ProcessedImage } from '../generated/image-manifest';

type Props = {
  // `ImageKey | (string & {})` keeps autocomplete for known images while
  // still compiling when the manifest is empty (before `bun run images`).
  name: ImageKey | (string & {});
  alt: string;
  sizes?: string;
  className?: string;
  imgClassName?: string;
  priority?: boolean;
  objectPosition?: string;
};

function buildSrcSet(variants: { width: number; src: string }[]): string {
  return variants.map((v) => `${v.src} ${v.width}w`).join(', ');
}

export default function ResponsiveImage({
  name,
  alt,
  sizes = '100vw',
  className = '',
  imgClassName = '',
  priority = false,
  objectPosition,
}: Props) {
  const image = (images as Record<string, ProcessedImage | undefined>)[name];
  const [loaded, setLoaded] = useState(false);

  if (!image) {
    if (import.meta.env.DEV) {
      console.warn(
        `[ResponsiveImage] No manifest entry for "${name}". Did you run \`bun run images\`?`
      );
    }
    return null;
  }

  const webpSrcSet = buildSrcSet(image.sources.webp);
  const jpegSrcSet = buildSrcSet(image.sources.jpeg);
  const largestJpeg = image.sources.jpeg[image.sources.jpeg.length - 1];

  return (
    <div
      className={`relative overflow-hidden ${className}`}
      style={{ aspectRatio: `${image.width} / ${image.height}` }}
    >
      <img
        src={image.lqip}
        alt=""
        aria-hidden
        className="absolute inset-0 h-full w-full scale-110 object-cover blur-xl"
        style={objectPosition ? { objectPosition } : undefined}
      />
      <picture>
        <source type="image/webp" srcSet={webpSrcSet} sizes={sizes} />
        <img
          src={largestJpeg.src}
          srcSet={jpegSrcSet}
          sizes={sizes}
          alt={alt}
          width={image.width}
          height={image.height}
          decoding="async"
          loading={priority ? 'eager' : 'lazy'}
          {...({ fetchpriority: priority ? 'high' : 'auto' } as Record<string, string>)}
          onLoad={() => setLoaded(true)}
          className={`absolute inset-0 h-full w-full object-cover transition-opacity duration-[600ms] ease-out ${
            loaded ? 'opacity-100' : 'opacity-0'
          } ${imgClassName}`}
          style={objectPosition ? { objectPosition } : undefined}
        />
      </picture>
    </div>
  );
}
```

### Empty directories

Create: `selected_images/` (curated photos source), `scripts/`, `public/images/` — `mkdir -p` is fine. `raw_images/` is optional but conventional.

---

## Step 3 — Copy the image-processing script

The script lives alongside this skill. Copy it into the new project:

```bash
cp ~/.claude/skills/webapp/process-images.ts scripts/process-images.ts
```

Do **not** inline or recreate it from scratch — it's ~200 lines and has load-bearing details (mtime cache, CLI filters, `--force`, pruning, EXIF rotation, slugify rules). Just copy the file.

---

## Step 4 — Install dependencies

```bash
bun install
```

Confirm no errors. `bun.lockb` should be created.

---

## Step 5 — Write project `CLAUDE.md`

Every project scaffolded by this skill gets a `CLAUDE.md` at the project root so future Claude sessions in that directory know the rules. Write this file verbatim (replace `PROJECT_NAME` and the one-line purpose):

````markdown
# PROJECT_NAME

ONE_LINE_PURPOSE. Stack: **Bun** + Vite + React 18 + TypeScript + Tailwind v3. Image pipeline: **sharp** with a typed manifest.

## Package manager: Bun (not npm)

Always use Bun. `bun.lockb` is the source of truth.

```bash
bun install          # install deps
bun run dev          # Vite dev server on :5173
bun run build        # production build
bun run preview      # preview production build
bun run images       # (re)process everything in selected_images/
```

Do **not** run `npm install` / `yarn` / `pnpm` — they'll generate competing lockfiles.

## Photo processing pipeline

### 1. Adding a new image

Drop the source file (JPEG or PNG) into `selected_images/`. Filename becomes the slug:

- `warren-VVEwJJRRHgk-unsplash.jpg` → slug `warren-vvewjjrrhgk` (the `-unsplash` suffix is stripped, the ID is kept so multiple photos from the same photographer don't collide)
- `brett.jpg` → slug `brett`
- `guy-on-bike.jpg` → slug `guy-on-bike`

If you want a clean slug like `warren`, rename the file in `selected_images/` before processing.

Raw, untouched originals go in `raw_images/` (gitignored). `selected_images/` is the curated set that ships with the site.

### 2. Running the script

```bash
bun run images                 # process anything new or changed
bun run images warren          # process only images whose slug/filename contains "warren"
bun run images warren brett    # multiple filters (OR, substring match)
bun run images --force         # re-encode everything, ignore cache
bun run images --force warren  # force re-process just warren
```

This:

- Walks every `.jpg`/`.jpeg`/`.png`/`.webp` in `selected_images/`.
- **Skip-if-fresh**: reads `public/images/.cache.json`; if an image's source mtime is unchanged since last run AND its output files still exist, it's reused, not re-encoded.
- For anything new/changed (or passing `--force`): emits widths **640 / 960 / 1280 / 1920 / 2560** as WebP (q=82) and progressive JPEG (q=82, mozjpeg) to `public/images/<slug>/`. No upscaling.
- Generates a 20px-wide blurred base64 LQIP and inlines it in the manifest.
- Writes `src/generated/image-manifest.ts`, fully typed.
- **Prunes** cache entries + output directories for source files that have been deleted.

**Filter semantics**: positional args narrow what gets re-processed; cached entries for filtered-out images stay in the manifest. If an image is filtered out AND has no cache entry, it's omitted from the manifest entirely.

**Cache file**: `public/images/.cache.json` is gitignored; the processed image files under `public/images/<slug>/` ARE committed so deploys don't need sharp.

### 3. Using an image in the app

```tsx
import ResponsiveImage from './components/ResponsiveImage';

<ResponsiveImage
  name="warren"          // autocompleted from the manifest
  alt="Portrait"
  sizes="100vw"          // real CSS `sizes` string — match the layout
  priority               // only set this for above-the-fold images
  className="h-full w-full"
/>;
```

The component:

- Renders a `<picture>` with WebP + JPEG fallback `srcset`.
- Reserves space with `aspect-ratio` → **zero layout shift**.
- Paints the inline LQIP on first render (no network round-trip).
- Fades in the full-resolution image via `onLoad` over ~600ms.

### 4. `sizes` cheatsheet

| Layout | `sizes` value |
| --- | --- |
| Full-bleed hero | `100vw` |
| 2-col on md+, full on mobile | `(min-width: 768px) 50vw, 100vw` |
| 3-col on lg+, 2-col on md, full on mobile | `(min-width: 1024px) 33vw, (min-width: 768px) 50vw, 100vw` |
| Fixed 400px thumbnail | `400px` |

### 5. `priority` rule

Only set `priority` on above-the-fold images. Everything else should lazy-load.

## Theme tokens

Defined in `tailwind.config.ts`:

- `bone` — `#F6F2EC` (off-white)
- `ink` — `#141210` (off-black)
- `muted` — `#6B635A` (secondary text)
- `font-display` — Instrument Serif
- `font-sans` — Inter

## Deployment notes

Processed images in `public/images/` are **committed** to git so the host doesn't need sharp. Re-run `bun run images` locally when the source set changes, commit the diff, push.
````

---

## Step 6 — First dev run

```bash
bun run dev
```

Should load on `localhost:5173` with the "Hello world" stub. No images yet.

When the user drops their first image in `selected_images/` and runs `bun run images`, the manifest populates and `<ResponsiveImage name="..." />` will render it.

---

## Customization notes

- **Different theme**: edit `tailwind.config.ts` (colors + fonts) and the Google Fonts `<link>` in `index.html`. Also update the `@apply bg-bone text-ink` in `src/index.css`.
- **Different image widths**: edit `WIDTHS` in `scripts/process-images.ts`. Also adjust `WEBP_QUALITY`/`JPEG_QUALITY` there if needed.
- **Tailwind v4**: don't. Stick to v3 unless the user explicitly asks — v4 changes the config format and PostCSS plugin.

---

## Verification

1. `bun run dev` — page loads on :5173.
2. `bun run build` — exits 0, `dist/` is populated.
3. If the user provided images: drop one in `selected_images/`, run `bun run images <slug>`, reference it in `App.tsx` via `<ResponsiveImage>`. In DevTools Network panel throttled to "Fast 4G", you should see the LQIP paint first, then the hi-res fade in over ~600ms with no layout shift.
