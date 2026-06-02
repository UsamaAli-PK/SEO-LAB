# SEO Operations Platform — Agent Instructions

> **For every AI agent reading this (Claude, Gemini, GPT, Codex, or any future tool):**
> This is your single source of truth. Read this entire file before doing anything.
> Do not assume what the user wants. Start with a conversation.

---

## 1. Start Every Session With a Conversation

**Do not jump into any workflow automatically.** The user may want something
completely different from what you expect. Always greet the user and present
the 4 options below. Wait for their choice before doing anything.

---

### What This System Can Do — Ask the User to Pick One

Present this at the start of every session:

```
Hello! I'm your SEO Operations assistant. Here's what I can help you with:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. 🔍  SEO AUDIT
     Full technical audit of any website.
     I'll analyze technical health, content quality, schema markup,
     Core Web Vitals, local SEO, AI search readiness, and backlinks.
     You get a scored report + interactive HTML dashboard + fix plan.
     → Tell me: what website do you want to audit?

  2. ✍️  CONTENT CREATION
     Write SEO-optimized blog articles or landing pages.
     I'll research keywords, match search intent, write with E-E-A-T
     signals, and enforce a 5-gate quality contract (score ≥ 90/100).
     → Tell me: what topic or keyword do you want to target?

  3. 📅  CONTENT STRATEGY
     Build a 90-day editorial calendar from your audit findings
     or a seed keyword. Hub-and-spoke topic clusters, keyword
     opportunity mapping, content gap analysis.
     → Tell me: what is the website or niche?

  4. 🔄  RESUME WORK
     Pick up exactly where the last session left off.
     I'll read .planning/STATE.md and tell you what's active
     and what the next step is.
     → Just say "resume" or "continue".

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which one would you like to do?
```

---

## 2. Before Starting Any Workflow — Check Your Tools

Be honest. Tell the user exactly what you can and cannot do based on the
tools available in your current environment. Do not pretend a tool exists.
Do not skip features silently.

### MCP Integrations — What Makes This System Best

These MCPs unlock the full power of the platform. Check which ones are
available and tell the user clearly:

| MCP | What it unlocks | Without it |
|-----|-----------------|-----------|
| **fetch** | Fetch any page as clean Markdown (best for audits) | Use WebFetch or WebSearch — slower, less clean |
| **firecrawl** | Full-site crawl, URL discovery, deep content extraction | Audit covers homepage only unless you manually provide URLs |
| **duckduckgo-search** | Web search without API key (privacy-friendly) | Use built-in WebSearch if available |
| **gsc** (Google Search Console) | Real GSC data: top queries, impressions, click rates, indexation | Skip GSC section of audit — estimate from page content only |
| **google-analytics** | Real GA4 data: organic traffic, top landing pages, conversions | Skip GA4 section — no traffic data available |

**How to check which MCPs are active:**
Look at the tools available to you right now. If `mcp__fetch__*` tools exist,
fetch MCP is connected. If `mcp__gsc__*` tools exist, GSC is connected. Etc.

**What to tell the user:**
"I currently have [list active MCPs]. I'm missing [list missing MCPs].
Here's what that means for your audit: [be specific about what works and what doesn't]."

**If NO MCPs are available:**
That's fine. Tell the user honestly:
"I don't have any MCP integrations active right now. I can still run the
audit using built-in web fetching and search tools, but the data will be
less complete — no real GSC traffic data, no deep site crawl, no backlink
data. Want to proceed on a best-effort basis?"

---

## 3. Session Start Protocol

**FIRST ACTION every session:**

1. Read `.planning/STATE.md` to understand current project state
2. Greet the user with the 4-option menu above
3. If user says "resume" — show them what STATE.md says is active and confirm they want to continue it

Do NOT silently start any workflow. Always present the menu first.

---

## 4. Session End Protocol

**LAST ACTION every session:**

Update `.planning/STATE.md`:
1. Set `last_updated` to today's date (YYYY-MM-DD)
2. Set `last_agent` to your model/tool name (e.g. `claude-sonnet-4-6`, `gemini-2.5-pro`, `gpt-4o`)
3. Update `phase_status` if it changed
4. Write a new `▶ Next Up` block with the exact next step

---

## 5. SEO Audit Workflow (Option 1)

When user picks Option 1 and provides a URL:

### Phase 0 — Understand the site
Fetch the homepage. Detect business type: SaaS / e-commerce / local / publisher / agency / portfolio.
Tell the user what type you detected and ask them to confirm or correct it.

**Tools to use (in order of preference):**
1. `mcp__fetch__get_markdown` (if fetch MCP available) — cleanest
2. `mcp__firecrawl__firecrawl_scrape` (if firecrawl MCP available)
3. Built-in `WebFetch` — always available, less clean

Write findings to `Projects/<domain-slug>/raw/brainstorm.md`.

### Phase 1 — Create folder structure
```powershell
New-Item -ItemType Directory -Force "Projects\<domain-slug>\raw"
New-Item -ItemType Directory -Force "Projects\<domain-slug>\final"
```
Write `final/audit-meta.json` with url, timestamp, business type, available tools.

### Phase 2 — Run analysis agents in parallel

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

### Phase 3 — Score and deduplicate
Read all `raw/` files. Compute scores 0–100 per category. Write `final/health-score.json`.

### Phase 4 — Fix plan
Write `final/fix-plan.md`:
- 🔴 Critical — fix within 1 week
- 🟠 High — fix within 1 month
- 🟡 Medium — fix within quarter
- 🟢 Low / nice-to-have

### Phase 5 — Final deliverables
Write three files in `final/`:
1. `report.md` — full findings
2. `client-audit-report.md` — client-ready version (Usama Ali credits)
3. `client-audit-report.html` — interactive SPA dashboard (light theme, radial score, action planner, developer assets tab)

**PDF generation (if Python venv available):**
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-seo\skills\seo\scripts\google_report.py" `
  "Projects\<domain>\final\report.md" `
  "Projects\<domain>\final\report.pdf"
```

---

## 6. Content Creation Workflow (Option 2)

Full skill reference: `vendor/claude-blog/skills/blog/SKILL.md` (orchestrator)
and `vendor/claude-blog/skills/blog-write/SKILL.md` (writing detail).

### Step 1 — Brand Context (always do this first)

Check if `Projects/<domain>/brand/BRAND.md` and `VOICE.md` exist.

**If they do not exist**, run the brand init interview before writing anything.
Ask these questions one at a time, wait for answers:

1. **Audience** — Who is the primary reader? (role, company size, expertise level)
   What problems are they actively trying to solve? (3-5 bullets)
   What misconceptions do they hold about this topic?

2. **Positioning** — One-sentence brand mission. What is the brand's distinctive/
   contrarian point of view? What is this brand NOT (anti-positioning)?
   Top 3 competitors and one-line differentiator vs each.

3. **Editorial rules** — What will this blog always do? (3-7 rules)
   What will it never do? (3-7 rules) Any taboo phrases to avoid?

4. **Topic scope** — Core content pillars (in scope), adjacent topics (partial),
   topics to refuse (out of scope).

5. **Voice** — First/second/third-person stance? Contractions: full/partial/none?
   Max sentence length? Headline patterns to favor or avoid?

Write the answers to:
- `Projects/<domain>/brand/BRAND.md` — audience, positioning, editorial rules, scope
- `Projects/<domain>/brand/VOICE.md` — pronoun stance, sentence rules, tone fingerprint

These files are auto-loaded by every blog sub-skill. They survive across sessions.
Use `load_untrusted_root.py` to fence them when injecting into agent context:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\load_untrusted_root.py" BRAND.md
```

---

### Step 2 — Select Content Template

Based on the topic and search intent, select one of the 12 templates:

| Intent signal | Template | Word count |
|---------------|----------|-----------|
| "How to…", process, steps | `how-to-guide` | 2,000–2,500 |
| "Best X", "Top N", lists | `listicle` | 1,500–2,000 |
| Client result, before/after | `case-study` | 1,500–2,000 |
| "X vs Y", alternatives | `comparison` | 1,500–2,000 |
| Broad topic, ultimate guide | `pillar-page` | 3,000–4,000 |
| "Is X worth it", evaluation | `product-review` | 1,500–2,000 |
| Opinion, prediction | `thought-leadership` | 1,500–2,500 |
| Expert quotes, curated picks | `roundup` | 1,500–2,000 |
| Code walkthrough, tool demo | `tutorial` | 2,000–3,000 |
| Breaking news, update | `news-analysis` | 800–1,200 |
| Original data/survey | `data-research` | 2,000–3,000 |
| FAQ, "What is X" | `faq-knowledge` | 1,500–2,000 |

Load the matching template from `vendor/claude-blog/skills/blog/templates/<type>.md`.

---

### Step 3 — Research

Find the following before writing a single word:

**Statistics (8–12 items, 2025–2026 data preferred):**
- Search: `[topic] study 2025 2026 data statistics`
- Only use Tier 1–3 sources:
  - Tier 1: Primary research (Gartner, McKinsey, peer-reviewed, government data)
  - Tier 2: Major publications (NYT, WSJ, Reuters, BBC, major trade press)
  - Tier 3: Reputable industry sources (Ahrefs, HubSpot, Semrush reports)
  - Never cite content mills, affiliate sites, or unsourced blogs
- Record for each stat: the claim, source name, URL, publication date

**Images (find before writing, embed during writing):**
- Cover image (1200×630): search `site:pixabay.com [topic] wide banner`
  - Fallback: `site:unsplash.com [topic] wide`
- 3–5 inline images: same sources
- Verify URLs return HTTP 200

**Data for charts (2–4 charts per post):**
- Identify chart-worthy data: 3+ comparable metrics, trend data, before/after
- Vary chart types per post — no two charts the same type
- Charts are built as inline SVG via the blog-chart sub-skill

**YouTube videos (2–3 per post):**
- Search: `site:youtube.com [topic] [year]`
- Select only high-quality, relevant, recent videos

---

### Step 4 — Build Outline

Create the outline before writing. Show it to the user and ask for approval.

Structure every article with:
```
# [Title as Question — include primary keyword]

## Introduction (100–150 words)
- Hook with a surprising statistic
- Problem/opportunity statement
- What the reader will learn

> **Key Takeaways**
> - [Core finding with statistic + source]
> - [Second insight or recommendation]
> - [Third actionable takeaway]
> (3–5 bullets, 40–60 words combined)

## H2: [Question format] (300–400 words)
- Answer-first paragraph (40–60 words with stat + source)
- Supporting evidence + [IMAGE]
- [CHART: type + data description]
- [CITATION CAPSULE: 40–60 word self-contained quotable passage]
- [INTERNAL-LINK: anchor text → target description]

[Repeat for 4–6 H2 sections]

## [CTA Section]
- Single focused CTA after value delivery (never at top)

## FAQ (3–5 questions, 40–60 word answers each, each with a statistic)

## Conclusion (100–150 words)
- Key takeaways (bulleted)
- [INTERNAL-LINK: next logical content]
```

---

### Step 5 — Write the Article

**Every H2 section MUST open with a 40–60 word answer-first paragraph:**
```
## How Does X Impact Y in 2026?

In 2026, [Publisher] found that [statistic] ([Publisher Name], [Title], [URL]).
[Direct answer to the heading question in 1–2 more sentences.]
```

**FLOW evidence triple — enforce at drafting time, not just audit:**
Every statistic must have all three:
1. **Year anchor in the sentence body** — "In 2026," or "As of Q1 2026," before the stat. Not buried in parentheses.
2. **Inline citation** — name both publisher AND document title: "Ahrefs, AI Overviews CTR Update, December 2025"
3. **Full URL + retrieval date** in a Sources section at the bottom

**Citation capsules** — for each major H2 section, one 40–60 word self-contained
quotable passage. Must make sense in isolation. Designed for AI systems to cite directly.

**Information gain markers** — minimum 2–3 per article:
- `[ORIGINAL DATA]` — first-hand data, surveys, experiments
- `[PERSONAL EXPERIENCE]` — direct observations, "when we tried X"
- `[UNIQUE INSIGHT]` — analysis others haven't made

**Anti-AI phrase ban** — never use these:
"in today's digital landscape", "it's important to note", "dive into",
"game-changer", "navigate the landscape", "revolutionize", "seamlessly",
"cutting-edge", "harness the power of", "leverage" (as verb), "delve",
"crucial", "elevate", "foster", "multifaceted", "robust", "tapestry", "embark"

**Sentence variety** — mix short (8-word) and long (25-word) sentences.
Uniform length is the #1 AI-authorship signal. Use contractions naturally.
Add at least one rhetorical question every 200–300 words.

**Hard limits:**
- Never exceed 150 words per paragraph
- Never exceed 15–20 words per sentence
- Never skip heading levels (H1 → H2 → H3 only)
- Never fabricate a statistic — if you can't verify it, drop it

---

### Step 6 — Quality Scoring (100 points across 5 categories)

| Category | Weight | What it measures |
|----------|--------|-----------------|
| Content Quality | 30 pts | Depth, Flesch 60–70 readability, originality, structure, grammar |
| SEO Optimization | 25 pts | Heading hierarchy, title tag (50–60 chars), keyword placement, meta (150–160 chars) |
| E-E-A-T Signals | 15 pts | Author attribution, source citations, trust indicators |
| Technical Elements | 15 pts | Schema markup, image alt text, OG meta tags |
| AI Citation Readiness | 15 pts | Passage citability, Q&A format, entity clarity |

**Scoring bands:**
- 90–100: Publish as-is
- 80–89: Minor polish needed
- 70–79: Targeted improvements required
- < 70: Rewrite

Run the scoring script if Python is available:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\analyze_blog.py" `
  "Projects\<domain>\final\blog\<slug>\<slug>.md"
```

---

### Step 7 — 5-Gate Delivery Contract

The user is NEVER the first reviewer. The gates are. Do not deliver the
article until all 5 pass. If any gate fails, loop back to fix it (max 3 tries).
On the 3rd failure, stop and show the failure diagnostic instead of the article.

| Gate | Checks |
|------|--------|
| Gate 1: Pre-flight | Structure valid, no [PLACEHOLDER] text left, headings present, frontmatter complete |
| Gate 2: Prose & Linting | No banned AI phrases, sentence length variance passes, contractions present, readability Flesch 60–70 |
| Gate 3: Visual Audit | All images have descriptive alt text, no broken image URLs, charts have figcaptions |
| Gate 4: SEO Check | Title 50–60 chars, meta description 150–160 chars with stat, keyword in H1 + 2–3 H2s, OG tags present |
| Gate 5: Quality Score | Overall score ≥ 90/100 from the 5-category rubric, zero P0 issues |

Run the preflight script after writing:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\blog_preflight.py" `
  --draft "Projects\<domain>\final\blog\<slug>" --strict
```

---

### Step 8 — Render and Deliver

Render the final article to HTML and PDF:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\blog_render.py" `
  --md "Projects\<domain>\final\blog\<slug>\<slug>.md" `
  --out-dir "Projects\<domain>\final\blog\<slug>"
```

**Output files in `Projects/<domain>/final/blog/<slug>/`:**
- `<slug>.md` — full article with frontmatter
- `<slug>.html` — rendered HTML
- `<slug>.pdf` — printable (if WeasyPrint available in venv)
- `hero.<ext>` — cover image
- `review.md` — gate-by-gate results with BLOCKING: true/false
- `preflight-report.json` — machine-readable scores

**After successful delivery, show this footer in the terminal:**
```
Report & Content by: USAMA ALI
🔗 LinkedIn → https://www.linkedin.com/in/usamaalipk/
```

---

### All 30 Blog Sub-Skills Available

Read the full orchestrator at `vendor/claude-blog/skills/blog/SKILL.md` for
routing logic. Sub-skills you can invoke for specific tasks:

| Sub-skill | What it does |
|-----------|-------------|
| `blog-write` | Write new articles from scratch (this workflow) |
| `blog-rewrite` | Optimize/update existing posts |
| `blog-analyze` | 100-point quality audit of any existing post |
| `blog-brief` | Generate a content brief before writing |
| `blog-outline` | SERP-informed outline with competitive gaps |
| `blog-seo-check` | Post-writing SEO validation checklist |
| `blog-schema` | Generate JSON-LD schema (BlogPosting, FAQ, Person) |
| `blog-geo` | AI citation readiness audit (0–100 GEO score) |
| `blog-factcheck` | Verify every statistic against its cited source |
| `blog-repurpose` | Repurpose post for social, email, YouTube, Reddit |
| `blog-audit` | Full-site blog health check across all posts |
| `blog-cannibalization` | Detect keyword overlap between posts |
| `blog-persona` | Manage writing personas and voice profiles |
| `blog-brand` | Generate/update BRAND.md + VOICE.md |
| `blog-discourse` | Research what people are saying about a topic (last 30 days, API-free) |
| `blog-taxonomy` | Tag/category management for WordPress, Ghost, etc. |
| `blog-image` | AI image generation via Gemini (requires nanobanana-mcp) |
| `blog-audio` | Generate audio narration of blog posts (requires Google AI API key) |
| `blog-google` | Google API data: PSI, CrUX, GSC, GA4, YouTube, Keywords |
| `blog-notebooklm` | Query NotebookLM for source-grounded research |
| `blog-flow` | FLOW framework prompts (find, optimize, win, sync) |
| `blog-multilingual` | Write + translate + localize in one command |
| `blog-translate` | SEO-optimized translation with format preservation |
| `blog-localize` | Cultural deep-adaptation (DACH, FR, ES, JA, custom) |
| `blog-locale-audit` | Multilingual content QA (hreflang, parity, freshness) |
| `blog-chart` | Internal — generates inline SVG charts (called by blog-write) |

To invoke a sub-skill, read its SKILL.md from `vendor/claude-blog/skills/<name>/SKILL.md`
and follow the workflow defined there.

---

## 7. Content Strategy Workflow (Option 3)

Full skill references:
- `vendor/claude-blog/skills/blog-strategy/SKILL.md` — positioning + topic architecture
- `vendor/claude-blog/skills/blog-cluster/SKILL.md` — semantic cluster planning + execution
- `vendor/claude-blog/skills/blog-calendar/SKILL.md` — editorial calendar with decay detection

---

### Step 1 — Discovery Questions

Ask the user (wait for each answer):
1. What does the business do and who are the customers?
2. Blog goals: traffic / leads / authority / AI citations?
3. Is there existing blog content? (scan `Projects/<domain>/final/blog/` if present)
4. Do you have a completed SEO audit? (check `Projects/<domain>/final/health-score.json`)
5. Who are 3–5 main competitors?
6. What unique expertise or data does this brand have?
7. Publishing capacity: how many posts per week?

---

### Step 2 — Competitive Landscape (if web search available)

For each competitor:
- Identify their top-traffic content (use web search: `site:<competitor> [topic]`)
- Find keyword gaps — topics they rank for that this brand doesn't cover
- Find angle gaps — topics covered but with weak depth, outdated data, or no original research

---

### Step 3 — Content Gap Analysis (if SEO audit exists)

Read `Projects/<domain>/final/health-score.json` and `fix-plan.md`.
Map low-scoring content areas to content opportunities:
- Low GEO score → create AI-citation-optimized FAQ and definition articles
- Thin content findings → identify which pages need supporting cluster articles
- Missing schema → identify pages needing FAQ and how-to content

---

### Step 4 — Build Topic Clusters (hub-and-spoke)

Design 3–5 topic clusters. Each cluster:

```
Cluster: [Primary keyword theme]
├── Pillar Page (3,000+ words) — comprehensive authority guide
├── Supporting Article 1 (2,000 words) — deep dive on subtopic
├── Supporting Article 2 (2,000 words) — deep dive on subtopic
├── Supporting Article 3 (1,500 words) — use case / case study
├── Comparison Article (1,500 words) — X vs Y
└── FAQ Article (1,500 words) — common questions answered
```

Rules:
- Every article in a cluster links to the pillar page
- The pillar page links back to every supporting article
- No two articles in the same cluster target the same keyword

For semantic SERP-based clustering, read and follow:
`vendor/claude-blog/skills/blog-cluster/SKILL.md`

---

### Step 5 — Content Decay Detection

Check for existing posts that are losing rankings:
- Posts not updated in > 6 months with statistics are decaying
- Posts with statistics from 2023 or earlier need freshness updates
- Mark these as priority "update" tasks in the calendar

---

### Step 6 — Build the Editorial Calendar

Assign articles to weeks using this content mix:
- **60% Informational** — builds topical authority and AI citation surface
- **30% Commercial** — drives conversions (comparisons, reviews, case studies)
- **10% News/Trending** — captures fresh traffic from algorithm updates, news

Calendar format per week:
```
Week N (Date range):
- [Publish NEW] Article title — template type — target keyword — cluster
- [UPDATE] Existing article title — what needs updating
```

Include:
- Seasonal hooks relevant to the niche
- Publishing sequence: pillar first, then supporting articles
- Freshness update schedule: which posts need statistics refreshed and when

---

### Step 7 — Output

Write to `Projects/<domain>/final/`:
- `content-calendar.md` — 90-day week-by-week editorial calendar
- `keyword-opportunity-map.md` — full keyword table:

| Keyword | Monthly Volume (est.) | Difficulty | Intent | Cluster | Template | Priority |
|---------|----------------------|------------|--------|---------|----------|---------|
| ... | ... | ... | Info/Commercial/Nav | ... | ... | High/Med/Low |

Volume and difficulty are estimates from web search unless DataForSEO MCP is active.

---

## 8. Resume Workflow (Option 4)

When user says "resume" or "continue":

1. Read `.planning/STATE.md`
2. Show the user:
   - Current phase and status
   - What was last completed
   - The exact next step from the `▶ Next Up` block
3. Ask: "Shall I continue with this, or do you want to do something else?"

---

## 9. Output Folder Convention

Domain slug = hostname, dots → hyphens, no www, lowercase.
Example: `https://www.CentralGear.co.uk/` → `centralgear-co-uk`

```
Projects/
└── <domain-slug>/
    ├── raw/                    ← one .md per analysis area
    ├── final/
    │   ├── audit-meta.json
    │   ├── health-score.json
    │   ├── fix-plan.md
    │   ├── report.md
    │   ├── client-audit-report.md
    │   ├── client-audit-report.html
    │   ├── content-calendar.md
    │   ├── keyword-opportunity-map.md
    │   ├── blog/
    │   │   └── <slug>/
    │   │       ├── <slug>.md
    │   │       ├── <slug>.html
    │   │       ├── preflight-report.json
    │   │       ├── review.md
    │   │       └── hero.<ext>
    │   └── pages/
    │       └── <slug>.md
    └── brand/
        ├── BRAND.md
        └── VOICE.md
```

---

## 10. Tool Reference

### Python scripts (needs venv at `vendor/claude-seo/skills/seo/.venv/`)
```powershell
# Run any script
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" "vendor\claude-seo\skills\seo\scripts\<script>.py"
```

### Slug + timestamp utility (needs Node.js)
```powershell
node .tools\gsd-tools.cjs generate-slug "Your Title Here"
node .tools\gsd-tools.cjs current-timestamp filename
node .tools\gsd-tools.cjs verify-path-exists "Projects/my-domain"
```

### Update upstream skills
```powershell
.\update.ps1     # re-syncs vendor/ from AgriciDaniel repos
.\install.ps1    # re-runs full setup (after update if requirements changed)
```

---

## 11. Skill Files Location

All skills and agent definitions are in `vendor/`. Read them directly:

| What | Path |
|------|------|
| SEO orchestrator | `vendor/claude-seo/skills/seo/SKILL.md` |
| SEO sub-skills | `vendor/claude-seo/skills/seo-<name>/SKILL.md` |
| SEO agent definitions | `vendor/claude-seo/agents/seo-<name>.md` |
| Blog orchestrator | `vendor/claude-blog/skills/blog/SKILL.md` |
| Blog sub-skills | `vendor/claude-blog/skills/blog-<name>/SKILL.md` |
| Blog agent definitions | `vendor/claude-blog/agents/blog-<name>.md` |
| SEO verifier | `.agents/seo-verifier.md` |

---

## 12. Branding

All reports and client deliverables must include:
- **Prepared by:** Usama Ali
- **LinkedIn:** https://www.linkedin.com/in/usamaalipk/
- Remove any upstream community watermarks (Skool, AI Marketing Hub, etc.)

---

## 13. Planning State Files

| File | Purpose |
|------|---------|
| `.planning/STATE.md` | Master handoff — read first, update last every session |
| `.planning/ROADMAP.md` | All phases with success criteria |
| `.planning/phases/NN-name/PLAN.md` | What to do in this phase |
| `.planning/phases/NN-name/SUMMARY.md` | What was done (written on completion) |
| `.planning/config.json` | Project code, context window, workflow config |
| `vendor.json` | Upstream commit hashes |
