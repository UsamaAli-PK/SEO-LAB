# SEO Audit Workflow (Option 1)

> Loaded lazily when the user picks Option 1 in `AGENTS.md`. Read this file fully before starting.

## Before You Start — Checklist

- [ ] Confirm you have read this entire file.
- [ ] In Phase 0, run the cache fetch **ONCE** so no agent re-fetches the homepage:
  ```powershell
  python .platform\scripts\fetch_cache.py <url> --domain <slug>
  ```
  This writes `Projects\<slug>\cache\homepage.html`. **Every Tier-A agent MUST READ from
  `Projects\<slug>\cache\homepage.html` instead of fetching the URL again.** Re-fetching is wasteful
  and produces inconsistent snapshots.
- [ ] Every `raw/*.md` output file MUST begin with YAML frontmatter (see "Raw File Contract" below).

## Raw File Contract (MANDATORY)

Each `raw/<area>.md` file MUST open with this frontmatter block before any prose:

```yaml
---
agent: <agent-name, e.g. seo-technical>
score: <0-100>
status: <pass | warn | fail>
summary:
  - <bullet 1>
  - <bullet 2>
  - <bullet 3>
  # 3-5 bullets total
---
```

This frontmatter is what Phase 3 reads. A raw file without valid frontmatter will block preflight.

---

When user picks Option 1 and provides a URL:

## Phase 0 — Understand the site
Run the cache fetch ONCE (see checklist above). Read the cached homepage.
Detect business type: SaaS / e-commerce / local / publisher / agency / portfolio.
Tell the user what type you detected and ask them to confirm or correct it.

**Tools to use for the single cache fetch (in order of preference):**
1. `mcp__fetch__get_markdown` (if fetch MCP available) — cleanest
2. `mcp__firecrawl__firecrawl_scrape` (if firecrawl MCP available)
3. Built-in `WebFetch` — always available, less clean

Write findings to `Projects/<domain-slug>/raw/brainstorm.md`.

## Phase 1 — Create folder structure
```powershell
New-Item -ItemType Directory -Force "Projects\<domain-slug>\raw"
New-Item -ItemType Directory -Force "Projects\<domain-slug>\final"
New-Item -ItemType Directory -Force "Projects\<domain-slug>\cache"
```
Write `final/audit-meta.json` with url, timestamp, business type, available tools.

## Phase 2 — Run analysis agents in parallel

All Tier-A agents READ `Projects\<slug>\cache\homepage.html` — they do not fetch.

**Tier A — Always run (8 areas):**

| Analysis | Output File | What it covers |
|----------|-------------|---------------|
| Technical | `raw/technical.md` | Crawlability, redirects, canonicals, robots.txt, HTTPS |
| Content | `raw/content.md` | E-E-A-T, thin content, headings, readability |
| Schema | `raw/schema.md` | JSON-LD detection, validation, generation |
| Sitemap | `raw/sitemap.md` | XML sitemap structure, missing pages |
| GEO | `raw/geo.md` | AI Overviews readiness, llms.txt, citation signals |
| Performance | `raw/performance.md` | Core Web Vitals: LCP, INP, CLS estimates |
| Visual/UX | `raw/visual.md` | Above-fold, screenshots if Playwright available |
| SXO | `raw/sxo.md` | Search intent match, user journey, page type |

**Tier B — Run if data sources available:**

| Analysis | Needs | Output File |
|----------|-------|-------------|
| Google data | gsc + google-analytics MCPs | `raw/google.md` |
| Backlinks | Web search (estimates only without Moz/Bing API) | `raw/backlinks.md` |
| SERP data | duckduckgo or web search | `raw/dataforseo.md` |

**Tier C — Run only if signals detected:**

| Condition | Analysis | Output File |
|-----------|----------|-------------|
| Local business signals | Local SEO + GBP | `raw/local.md` |
| Products / prices found | E-commerce SEO | `raw/ecommerce.md` |
| Physical location found | Maps + geo-grid | `raw/maps.md` |
| Always | Topic clusters | `raw/cluster.md` |
| Always | FLOW framework | `raw/flow.md` |

**Be honest in every raw file** about what data came from real sources
vs. estimated from page content. Mark clearly: `[DATA: real]` vs `[DATA: estimated]`.

## Phase 3 — Preflight, collect, score

**Step 3a — Preflight FIRST (before any scoring):**
```powershell
python .platform\scripts\audit_preflight.py --domain <slug> --strict
```
If preflight blocks, a raw file is missing or is a stub. **Fix the missing/stub raw file first**,
then re-run preflight. Do not score until preflight passes.

**Step 3b — Collect findings via summaries, NOT full bodies:**
```powershell
python .platform\scripts\collect_findings.py --domain <slug>
```
This reads the YAML `summary:` from each raw file. Work from these summaries.
Only read a full raw body when you need to drill into one specific finding.

**Step 3c — Score:**
Compute scores 0–100 per category. Write `final/health-score.json`.

## Phase 4 — Fix plan
Write `final/fix-plan.md`:
- 🔴 Critical — fix within 1 week
- 🟠 High — fix within 1 month
- 🟡 Medium — fix within quarter
- 🟢 Low / nice-to-have

## Phase 5 — Final deliverables

Write three files in `final/`:
1. `report.md` — full findings
2. `client-audit-report.md` — client-ready version (Usama Ali credits)
3. `client-audit-report.html` — interactive SPA dashboard (light theme, radial score, action planner, developer assets tab)

**Report fixes (apply these):**
- **(a) Dynamic baseline score.** The HTML dashboard's baseline score must be READ at render time
  from `final/health-score.json`. **Never hardcode `46`** (or any number) into the dashboard.
- **(b) Re-audit archiving.** Re-audits write to `Projects\<slug>\final\archive\<YYYY-MM-DD>\` FIRST,
  then promote the new files into `final/`. This preserves the prior audit for comparison.
- **(c) PDF resilience.** If PDF generation (WeasyPrint) fails, **log the failure, deliver MD + HTML,
  and tell the user exactly which artifact is missing.** Never crash the whole audit over a PDF.

**PDF generation (if Python venv available):**
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-seo\skills\seo\scripts\google_report.py" `
  "Projects\<domain>\final\report.md" `
  "Projects\<domain>\final\report.pdf"
```

## After Delivery — Capture a Learning

Append the key finding so future sessions benefit:
```powershell
python .platform\scripts\learn.py add --category audit --pattern "<key finding>" --source <slug>
```
