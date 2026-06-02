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

When user picks Option 2 and provides a topic/keyword:

1. **Brand check** — does `Projects/<domain>/brand/BRAND.md` exist?
   If not, ask the user 5 quick questions to create it:
   - What is the business name and what does it do?
   - Who is the target audience?
   - What tone? (professional / friendly / technical / conversational)
   - Any words or phrases to always avoid?
   - Any competitor sites to be aware of?

2. **Research** — use available web search tools to find:
   - Top 5 ranking pages for the keyword
   - PAA questions (People Also Ask)
   - Related keywords and search intent
   - Any recent statistics or data worth citing

3. **Write** — produce the article following:
   - Answer-first structure (answer in first 100 words)
   - Proper heading hierarchy (H1 → H2 → H3)
   - E-E-A-T signals (cite sources, show expertise)
   - Target word count based on top-ranking competitors
   - Internal linking opportunities from existing content

4. **5-Gate quality check** (run analyze_blog.py if Python available):
   - Gate 1: Structure (headings, intro, conclusion, meta)
   - Gate 2: Prose (no AI slop patterns, readability score)
   - Gate 3: Visual (alt text, image placeholders)
   - Gate 4: SEO (keyword placement, meta description, schema)
   - Gate 5: Score ≥ 90/100

5. **Output** to `Projects/<domain>/final/blog/<slug>/`:
   - `<slug>.md` — article source
   - `<slug>.html` — rendered
   - `review.md` — gate results
   - `preflight-report.json` — scores

---

## 7. Content Strategy Workflow (Option 3)

When user picks Option 3:

1. Ask: "Do you have an existing audit for this site, or shall I start fresh with keyword research?"

2. **If audit exists** — read `Projects/<domain>/final/health-score.json` and `fix-plan.md` to identify content gaps

3. **Cluster plan** — group keywords into hub-and-spoke topics:
   - 1 pillar page per topic cluster
   - 4-6 supporting articles per pillar
   - Internal linking map between them

4. **Calendar** — assign articles to weeks using this mix:
   - 60% — informational (builds authority)
   - 30% — commercial (drives conversions)
   - 10% — news/trending (captures fresh traffic)

5. **Output** to `Projects/<domain>/final/`:
   - `content-calendar.md` — 90-day editorial calendar
   - `keyword-opportunity-map.md` — full keyword table with intent, volume estimates, difficulty

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
