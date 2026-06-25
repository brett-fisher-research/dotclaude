#!/usr/bin/env bun
/**
 * Processes images in selected_images/ into responsive WebP + JPEG variants
 * plus an inline LQIP, then writes a typed manifest the React app consumes
 * via `<ResponsiveImage name="..." />`.
 *
 * Usage:
 *   bun run images                 # process anything new or changed
 *   bun run images warren          # process only images whose slug matches "warren"
 *   bun run images warren brett    # multiple filters (OR)
 *   bun run images --force         # re-process everything, ignore cache
 *   bun run images --force warren  # force re-process just warren
 *
 * Behavior:
 *   - Skips any image whose source mtime matches the cache entry and whose
 *     output files still exist on disk.
 *   - Manifest always reflects what's currently in selected_images/. Images
 *     filtered out of *processing* still appear in the manifest if they have
 *     a valid cache entry. Images no source file are pruned from cache + disk.
 */
import { readdir, stat, mkdir, writeFile, rm, readFile } from 'node:fs/promises';
import { existsSync } from 'node:fs';
import { join, extname, basename, resolve } from 'node:path';
import sharp from 'sharp';

const ROOT = resolve(import.meta.dir, '..');
const SRC_DIR = join(ROOT, 'selected_images');
const OUT_DIR = join(ROOT, 'public', 'images');
const MANIFEST_PATH = join(ROOT, 'src', 'generated', 'image-manifest.ts');
const CACHE_PATH = join(OUT_DIR, '.cache.json');

const WIDTHS = [640, 960, 1280, 1920, 2560] as const;
const WEBP_QUALITY = 82;
const JPEG_QUALITY = 82;
const LQIP_WIDTH = 20;

const IMAGE_EXTENSIONS = new Set(['.jpg', '.jpeg', '.png', '.webp']);

type Variant = { width: number; src: string };
type ManifestEntry = {
  slug: string;
  width: number;
  height: number;
  lqip: string;
  sources: { webp: Variant[]; jpeg: Variant[] };
};
type CacheRecord = {
  sourceName: string;
  sourceMtimeMs: number;
  entry: ManifestEntry;
};
type Cache = Record<string, CacheRecord>;

function parseArgs(argv: string[]): { force: boolean; filters: string[] } {
  const force = argv.includes('--force');
  const filters = argv.filter((a) => !a.startsWith('--'));
  return { force, filters };
}

function slugify(filename: string): string {
  const base = basename(filename, extname(filename));
  const cleaned = base
    .replace(/-unsplash$/i, '')
    .replace(/[^A-Za-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .toLowerCase();
  return cleaned || base.toLowerCase();
}

function matchesFilter(slug: string, filename: string, filters: string[]): boolean {
  if (filters.length === 0) return true;
  return filters.some((f) => {
    const needle = f.toLowerCase();
    return slug.includes(needle) || filename.toLowerCase().includes(needle);
  });
}

async function outputsExist(slug: string, entry: ManifestEntry): Promise<boolean> {
  const all = [...entry.sources.webp, ...entry.sources.jpeg];
  for (const v of all) {
    const filePath = join(ROOT, 'public', v.src.replace(/^\//, ''));
    if (!existsSync(filePath)) return false;
  }
  return existsSync(join(OUT_DIR, slug));
}

async function loadCache(): Promise<Cache> {
  if (!existsSync(CACHE_PATH)) return {};
  try {
    const raw = await readFile(CACHE_PATH, 'utf8');
    return JSON.parse(raw) as Cache;
  } catch (err) {
    console.warn(`Cache at ${CACHE_PATH} unreadable (${(err as Error).message}); ignoring.`);
    return {};
  }
}

async function saveCache(cache: Cache): Promise<void> {
  await mkdir(OUT_DIR, { recursive: true });
  await writeFile(CACHE_PATH, JSON.stringify(cache, null, 2), 'utf8');
}

async function processOne(filePath: string, slug: string): Promise<ManifestEntry> {
  const outDir = join(OUT_DIR, slug);
  if (existsSync(outDir)) await rm(outDir, { recursive: true });
  await mkdir(outDir, { recursive: true });

  const meta = await sharp(filePath, { failOn: 'none' }).rotate().metadata();
  if (!meta.width || !meta.height) {
    throw new Error(`Could not read dimensions for ${filePath}`);
  }
  const intrinsicW = meta.width;
  const intrinsicH = meta.height;

  const applicableWidths = WIDTHS.filter((w) => w <= intrinsicW);
  if (applicableWidths.length === 0) applicableWidths.push(intrinsicW);

  const webp: Variant[] = [];
  const jpeg: Variant[] = [];

  for (const w of applicableWidths) {
    const pipeline = sharp(filePath).rotate().resize({ width: w, withoutEnlargement: true });

    const webpPath = join(outDir, `${slug}-${w}.webp`);
    await pipeline.clone().webp({ quality: WEBP_QUALITY }).toFile(webpPath);
    webp.push({ width: w, src: `/images/${slug}/${slug}-${w}.webp` });

    const jpegPath = join(outDir, `${slug}-${w}.jpg`);
    await pipeline
      .clone()
      .jpeg({ quality: JPEG_QUALITY, progressive: true, mozjpeg: true })
      .toFile(jpegPath);
    jpeg.push({ width: w, src: `/images/${slug}/${slug}-${w}.jpg` });
  }

  const lqipBuffer = await sharp(filePath)
    .rotate()
    .resize({ width: LQIP_WIDTH })
    .jpeg({ quality: 40 })
    .toBuffer();
  const lqip = `data:image/jpeg;base64,${lqipBuffer.toString('base64')}`;

  return { slug, width: intrinsicW, height: intrinsicH, lqip, sources: { webp, jpeg } };
}

function emitManifest(entries: ManifestEntry[]): string {
  const sorted = [...entries].sort((a, b) => a.slug.localeCompare(b.slug));
  const body = sorted
    .map((e) => {
      const renderVariants = (vs: Variant[]) =>
        vs.map((v) => `      { width: ${v.width}, src: ${JSON.stringify(v.src)} }`).join(',\n');
      return `  ${JSON.stringify(e.slug)}: {
    slug: ${JSON.stringify(e.slug)},
    width: ${e.width},
    height: ${e.height},
    lqip: ${JSON.stringify(e.lqip)},
    sources: {
      webp: [
${renderVariants(e.sources.webp)}
      ],
      jpeg: [
${renderVariants(e.sources.jpeg)}
      ],
    },
  }`;
    })
    .join(',\n');

  return `// AUTO-GENERATED by scripts/process-images.ts — do not edit by hand.
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

export const images = {
${body}
} as const satisfies Record<string, ProcessedImage>;

export type ImageKey = keyof typeof images;
`;
}

async function main() {
  const { force, filters } = parseArgs(process.argv.slice(2));

  if (!existsSync(SRC_DIR)) {
    console.error(`Source directory not found: ${SRC_DIR}`);
    process.exit(1);
  }

  const files = (await readdir(SRC_DIR))
    .filter((f) => IMAGE_EXTENSIONS.has(extname(f).toLowerCase()))
    .sort();

  await mkdir(OUT_DIR, { recursive: true });
  await mkdir(join(ROOT, 'src', 'generated'), { recursive: true });

  const cache = await loadCache();
  const liveSlugs = new Set<string>();
  const entries: ManifestEntry[] = [];

  let processed = 0;
  let skipped = 0;
  let excluded = 0;

  for (const file of files) {
    const full = join(SRC_DIR, file);
    const s = await stat(full);
    if (!s.isFile()) continue;

    const slug = slugify(file);
    liveSlugs.add(slug);

    const cached = cache[slug];
    const inFilter = matchesFilter(slug, file, filters);
    const mtimeMatches = cached && cached.sourceMtimeMs === s.mtimeMs;
    const outputsOk = cached && (await outputsExist(slug, cached.entry));

    if (!inFilter) {
      if (cached && mtimeMatches && outputsOk) {
        entries.push(cached.entry);
      }
      excluded += 1;
      continue;
    }

    if (!force && cached && mtimeMatches && outputsOk) {
      entries.push(cached.entry);
      skipped += 1;
      console.log(`= ${file}  →  ${slug}  (up to date)`);
      continue;
    }

    const startedAt = Date.now();
    process.stdout.write(`• ${file}  →  ${slug} ... `);
    try {
      const entry = await processOne(full, slug);
      entries.push(entry);
      cache[slug] = { sourceName: file, sourceMtimeMs: s.mtimeMs, entry };
      processed += 1;
      console.log(`${((Date.now() - startedAt) / 1000).toFixed(1)}s`);
    } catch (err) {
      console.error(`\n  Failed: ${(err as Error).message}`);
    }
  }

  // Prune cache entries + output dirs whose source file no longer exists.
  let pruned = 0;
  for (const slug of Object.keys(cache)) {
    if (!liveSlugs.has(slug)) {
      const dir = join(OUT_DIR, slug);
      if (existsSync(dir)) await rm(dir, { recursive: true });
      delete cache[slug];
      pruned += 1;
      console.log(`- pruned ${slug}`);
    }
  }

  await saveCache(cache);
  await writeFile(MANIFEST_PATH, emitManifest(entries), 'utf8');

  console.log(
    `\nManifest: ${entries.length} image(s). ` +
      `Processed ${processed}, reused ${skipped}, filtered ${excluded}, pruned ${pruned}. ` +
      `→ ${MANIFEST_PATH}`
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
