/**
 * Content Collections registry — Astro Content Layer.
 *
 * Collections live here (src/content.config.ts is the modern home in Astro 5+).
 * Write-ups are plain markdown files under src/content/write-ups/<file>.md;
 * the Zod schema type-checks frontmatter at build time, so a typo'd date or
 * unknown tool id fails CI instead of silently shipping.
 */
import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from 'astro/loaders';
import { CATEGORY_IDS, DIFFICULTIES, TOOL_IDS } from './lib/taxonomy';

// Lets zod accept our exported `as const` arrays as enum literal tuples
const toEnumTuple = (values: readonly string[]) =>
  values as unknown as [string, ...string[]];

const writeUps = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/write-ups' }),
  schema: z.object({
    title: z.string(),
    /** One-to-two sentence summary used for SEO and listing cards */
    description: z.string().min(1),
    /** Publish date, YYYY-MM-DD */
    pubDate: z.coerce.date(),
    /** Optional correction/retest date */
    updatedDate: z.coerce.date().optional(),
    category: z.enum(toEnumTuple(CATEGORY_IDS)),
    tools: z.array(z.enum(toEnumTuple(TOOL_IDS))).default([]),
    difficulty: z.enum(toEnumTuple(DIFFICULTIES)).default('intermediate'),
    tags: z.array(z.string()).default([]),
    /** Promote to homepage/features */
    featured: z.boolean().default(false),
    /** Optional cover/banner path, resolved against /public */
    image: z.string().optional(),
  }),
});

export const collections = {
  'write-ups': writeUps,
};
