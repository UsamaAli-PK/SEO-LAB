#!/usr/bin/env node
/**
 * seo-tools.cjs — Lightweight utility CLI for SEO Operations Platform
 *
 * Adapted from gsd-core-next/get-shit-done/bin/gsd-tools.cjs (opengsd/gsd-core v1.2.0)
 * Stripped to standalone utilities that need no external dependencies.
 *
 * Usage:
 *   node .tools/gsd-tools.cjs generate-slug "Your Title Here"
 *   node .tools/gsd-tools.cjs current-timestamp [full|date|filename]
 *   node .tools/gsd-tools.cjs verify-path-exists "path/to/check"
 *   node .tools/gsd-tools.cjs list-todos "path/to/file.md"
 */

'use strict';

const fs   = require('fs');
const path = require('path');

const [,, command, ...args] = process.argv;

// ─── generate-slug ───────────────────────────────────────────────────────────
if (command === 'generate-slug') {
  const text = args.join(' ');
  if (!text) { console.error('Usage: generate-slug "Your Title"'); process.exit(1); }
  const slug = text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9\s-]/g, '')
    .trim()
    .replace(/[\s_]+/g, '-')
    .replace(/-+/g, '-');
  console.log(slug);
  process.exit(0);
}

// ─── current-timestamp ───────────────────────────────────────────────────────
if (command === 'current-timestamp') {
  const format = args[0] || 'full';
  const now    = new Date();
  const pad    = n => String(n).padStart(2, '0');
  const Y  = now.getUTCFullYear();
  const Mo = pad(now.getUTCMonth() + 1);
  const D  = pad(now.getUTCDate());
  const H  = pad(now.getUTCHours());
  const Mi = pad(now.getUTCMinutes());
  const S  = pad(now.getUTCSeconds());

  if (format === 'full')          { console.log(`${Y}-${Mo}-${D}T${H}:${Mi}:${S}Z`); }
  else if (format === 'date')     { console.log(`${Y}-${Mo}-${D}`); }
  else if (format === 'filename') { console.log(`${Y}-${Mo}-${D}_${H}${Mi}${S}`); }
  else { console.error(`Unknown format: ${format}. Use full|date|filename`); process.exit(1); }
  process.exit(0);
}

// ─── verify-path-exists ──────────────────────────────────────────────────────
if (command === 'verify-path-exists') {
  const target = args[0];
  if (!target) { console.error('Usage: verify-path-exists "path/to/check"'); process.exit(1); }
  const resolved = path.isAbsolute(target) ? target : path.join(process.cwd(), target);
  if (fs.existsSync(resolved)) { console.log('exists'); process.exit(0); }
  else                          { console.log('not-found'); process.exit(1); }
}

// ─── list-todos ──────────────────────────────────────────────────────────────
if (command === 'list-todos') {
  const file = args[0];
  if (!file) { console.error('Usage: list-todos "path/to/file.md"'); process.exit(1); }
  const resolved = path.isAbsolute(file) ? file : path.join(process.cwd(), file);
  if (!fs.existsSync(resolved)) { console.error(`File not found: ${resolved}`); process.exit(1); }
  const lines = fs.readFileSync(resolved, 'utf8').split('\n');
  const todos = lines.filter(l => /^\s*-\s*\[\s*\]/.test(l)).map(l => l.trim());
  console.log(`${todos.length} pending todos:`);
  todos.forEach((t, i) => console.log(`  ${i + 1}. ${t}`));
  process.exit(0);
}

// ─── help ────────────────────────────────────────────────────────────────────
console.log(`seo-tools.cjs — SEO Operations Platform utilities
Adapted from opengsd/gsd-core (standalone subset)

Commands:
  generate-slug "Your Title"                Convert text to URL slug
  current-timestamp [full|date|filename]    Get formatted timestamp
  verify-path-exists "path/to/check"        Check if path exists
  list-todos "path/to/file.md"              List unchecked todos

Examples:
  node .tools/gsd-tools.cjs generate-slug "DSG Gearbox Warning Signs"
  node .tools/gsd-tools.cjs current-timestamp filename
  node .tools/gsd-tools.cjs verify-path-exists "Projects/centralgear-co-uk"
  node .tools/gsd-tools.cjs list-todos ".planning/phases/03-content-pipeline/PLAN.md"
`);
process.exit(0);
