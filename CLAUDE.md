# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workspace Purpose

This workspace is the SEO audit operations hub. It contains:
- `claude-seo/` — the installed skill source (v1.9.9, 25 skills, 18 agents). Do not edit files here; run `install.ps1` to re-install into `~/.claude/`.
- `Projects/` — all audit output. Every website gets its own folder. **Nothing writes outside `D:\code\seo\Projects\`.**
- `old/` — archived reports from before this workflow was established. Reference only.

---

## Full-Scale SEO Audit Workflow

Run this when a user provides a URL for auditing. The entry point is `/seo audit <url>`.

### Phase 0 — Brainstorm (`superpowers:brainstorming`)

Fetch the homepage via `mcp__fetch__get_markdown`. Detect business type (SaaS / e-commerce / local / publisher / agency / portfolio). Identify which Tier C agents apply. Write findings to `Projects/<domain>/raw/brainstorm.md`.

### Phase 1 — Plan (`superpowers:writing-plans`)

Create the output folder structure (PowerShell):
```powershell
New-Item -ItemType Directory -Force "D:\code\seo\Projects\<domain-slug>\raw"
New-Item -ItemType Directory -Force "D:\code\seo\Projects\<domain-slug>\final"
```
Write `final/audit-meta.json` with url, timestamp, detected business type, and skill list.

### Phase 2 — Parallel Execution (`superpowers:dispatching-parallel-agents`)

**Tier A — always run (8 agents in parallel):**

| Agent | Writes To |
|-------|-----------|
| seo-technical | `raw/technical.md` |
| seo-content | `raw/content.md` |
| seo-schema | `raw/schema.md` |
| seo-sitemap | `raw/sitemap.md` |
| seo-geo | `raw/geo.md` |
| seo-performance | `raw/performance.md` |
| seo-visual | `raw/visual.md` |
| seo-sxo | `raw/sxo.md` |

**Tier B — MCP-powered data agents (3 agents in parallel):**

| Agent | MCPs / Scripts | Writes To |
|-------|---------------|-----------|
| seo-google | gsc MCP, google-analytics MCP, `gsc_query.py`, `ga4_report.py`, `crux_history.py` | `raw/google.md` |
| seo-backlinks | `moz_api.py`, `bing_webmaster.py`, `commoncrawl_graph.py` | `raw/backlinks.md` |
| seo-dataforseo | DataForSEO MCP (skip if no API key) | `raw/dataforseo.md` |

**Tier C — conditional (run in parallel, only if signals detected):**

| Condition | Agent | Writes To |
|-----------|-------|-----------|
| Local business signals | seo-local | `raw/local.md` |
| Products / prices detected | seo-ecommerce | `raw/ecommerce.md` |
| Physical location detected | seo-maps | `raw/maps.md` |
| Always | seo-cluster | `raw/cluster.md` |
| Always | seo-flow | `raw/flow.md` |

### Phase 3 — Review (`superpowers:verification-before-completion`)

Read all files in `raw/`. Deduplicate issues. Compute per-category scores (0–100): Technical Health, Content Quality, Schema Coverage, Link Authority, Performance (CWV), Local Presence, E-E-A-T, GEO Readiness. Compute composite SEO Health Score. Write `final/health-score.json`.

### Phase 4 — Fix Plan

Write `final/fix-plan.md` with issues grouped as:
- 🔴 Critical (fix within 1 week)
- 🟠 High (fix within 1 month)
- 🟡 Medium (fix within quarter)
- 🟢 Low / Nice-to-have

Each issue must reference the `raw/` file it came from and include an effort estimate.

### Phase 5 — Final Report & Dashboard

Write three final deliverables in `final/`:
1. **`report.md`**: Summary report (Executive Summary → Health Score card → Top 10 quick wins → Detailed findings by category → Competitive positioning → GEO/AI readiness → 90-day roadmap → Appendix).
2. **`client-audit-report.md`**: Master client audit document. Replaces community watermarks with **Usama Ali** credits. Uses a clean Markdown table for the 90-Day Execution Roadmap.
3. **`client-audit-report.html`**: A standalone, premium, interactive light-themed HTML dashboard representing the audit.

#### Interactive HTML Dashboard Guidelines:
- **Visual Design:**
  - Standard light theme (clean white `#FFFFFF` cards, soft grey `#F8FAFC` background, deep slate `#0F172A` text, and glowing accent borders).
  - Modern typography using Google Fonts (Outfit & Inter) and native SVG Lucide icons.
  - No external JS dependency for rendering (no Mermaid or complex workflow graphs).
- **Branding & Credits:**
  - Remove all community watermark links (Skool etc.).
  - Include a styled report credit signature footer: "Report Prepared By: USAMA ALi" with a LinkedIn profile link (`https://www.linkedin.com/in/usamaalipk/`).
- **Sidebar & Core Score Integration:**
  - Sidebar contains logo/title, navigation tabs, credit signature, and a **radial progress widget** representing the health score (Grade A/B/C/F).
  - Score dynamically scales from the baseline (**46 / 100**) up to **100 / 100** based on the Action Planner checkbox counts.
- **SPA Tab Navigation & Structure:**
  - **Overview Tab:** Shows baseline stats, category score comparisons (March vs June 2026), and a native visual directory tree of site architecture.
  - **Audit Findings Tab:** Features subtabs for the 10 audit categories. Inside, findings are rendered inside collapsible `<details>` cards separating "Detailed Findings" from numbered "Step-by-Step Fix Guides".
  - **Action Planner Tab:** A checklist of all 36 audit tasks (Critical = 2.50, High = 1.40, Medium = 0.55 weights). Selections must persist across browser refreshes via `localStorage`. Includes a "Reset Planner" button.
  - **Developer Assets Tab:** Houses copyable config files (robots.txt, llms.txt, schema JSON-LD, redirection scripts) with instant "Copy Snippet" clipboards.
- **Roadmap Styling:**
  - 90-Day Execution Roadmap must be rendered as a native card grid of milestone phases (`.roadmap-grid` and `.roadmap-phase-card` styles) with custom icon badges (alert-circle, map-pin, terminal, etc.) instead of flowcharts or vertical/horizontal timeline connecting lines.

Generate PDF:
```powershell
& "$env:USERPROFILE\.claude\skills\seo\.venv\Scripts\python.exe" `
  "$env:USERPROFILE\.claude\skills\seo\scripts\google_report.py" `
  "D:\code\seo\Projects\<domain>\final\report.md" `
  "D:\code\seo\Projects\<domain>\final\report.pdf"
```

---

## Advanced SEO Specialist Workflows

To support end-to-end SEO strategy and content production without requiring server-side script execution, follow these specific workflows to output strategy blueprints, calendars, and copy-ready Markdown drafts.

### 1. Keyword Research & Opportunity Mapping (`/seo keyword-research <seed>`)
- **Skills Used:** `seo-keyword-strategist`, `seo-cluster`, `seo-competitor-pages`
- **Output File:** `final/keyword-opportunity-map.md`
- **Requirements:**
  - Standardized table mapping target keywords, search volume, difficulty, and intent (Transactional, Navigational, Informational, Commercial).
  - Grouping of keywords into semantic silos (primary topics vs. secondary support terms).
  - Competitive gap listings showing what terms direct competitors rank for that the client lacks.

### 2. 90-Day Content Strategy & Calendar (`/seo content-plan <url_or_niche>`)
- **Command Bridge:** Delegates to `/blog calendar` + `/blog cluster` with project context.
- **Output File:** `final/content-calendar.md`
- **Requirements:** Delegates content calendar execution to the blog content engine to ensure decay detection, 60/30/10 content mix, and keyword mapping.

### 3. Webpage Content Writing (`/seo write-page <topic_or_url> <keywords>`)
- **Command Bridge:** Delegates to `/blog write` in page-mode with target keywords and layout templates.
- **Output File:** `final/pages/<page-slug>.md`
- **Requirements:** Injects custom metadata, schema markup, heading hierarchy, and target E-E-A-T hooks.

### 4. Search-Optimized Blog Article Writing (`/seo write-blog <keyword_or_brief>`)
- **Command Bridge:** Delegates to `/blog write <topic>` with keyword research and brand voice.
- **Output File:** `final/blog/<post-slug>/`
- **Requirements:** Writes full blog articles subject to the 5-gate delivery contract (pre-flight checks, SEO check, 100-point quality audit, PDF/HTML rendering, hero image).

---

## Blog Content Engine (claude-blog Integration)

The blog content engine (`claude-blog`) operates as our primary content creation and optimization engine, bridging `/seo` content commands to the specialized `/blog` skills.

### Command Bridge Mapping

| /seo command | Delegated /blog command | Output / Purpose |
|--------------|-------------------------|------------------|
| `/seo content-plan` | `/blog calendar` + `/blog cluster` | Produces `final/content-calendar.md` and hub-and-spoke plan |
| `/seo write-page` | `/blog write` (page mode) | Produces `final/pages/<page-slug>.md` |
| `/seo write-blog` | `/blog write` (article mode) | Produces `final/blog/<post-slug>/` (article + assets) |

### Core /blog Commands
- `/blog write <topic>`: Generates a complete blog post utilizing appropriate template, structured research, and E-E-A-T signals. Enforces 5-gate delivery contract.
- `/blog rewrite <file>`: Optimizes existing drafts for flow, readability, and AI-content detection.
- `/blog analyze <file>`: Audits drafts and returns 0-100 quality score across 5 categories.
- `/blog calendar`: Creates an editorial calendar using search volume, keyword difficulty, and decay metrics.
- `/blog cluster <seed>`: Constructs hub-and-spoke topic structures for search authority.
- `/blog brand init`: Initializes client-specific brand context.

### Brand & Voice Setup
Before writing client content, set up the brand voice:
1. Run `/blog brand init` in the project directory.
2. This generates `brand/BRAND.md` (audience, positioning, taboo terms) and `brand/VOICE.md` (tone, pronoun stance, formatting).
3. The blog engine automatically loads this context using `load_untrusted_root.py` to prevent prompt injection.

### Quality Gates & Delivery Contract
Every blog draft generated via `/blog write` is subject to the **5-gate delivery contract**:
- **Gate 1: Pre-flight Checks** (Structure, placeholders, headings).
- **Gate 2: Prose & Linting** (Anti-AI patterns, readability, word limits).
- **Gate 3: Visual Audit** (Alt text, placeholders, responsive layout).
- **Gate 4: SEO Check** (Keyword placement, meta tags, schema).
- **Gate 5: Quality Audit** (Requires scorecard rating of 90+ out of 100).
If any gate fails, the draft is rejected and sent back to the writer agent for iteration (max 3 times).

---

## Unified Audit → Content Pipeline

The end-to-end SEO workflow bridges technical audits directly into structured content creation:

```
/seo audit <url>
  → Produces: health-score.json, fix-plan.md, raw/*.md
  → Feeds into:
/blog strategy <niche>
  → Uses audit findings to identify content gaps
  → Produces: strategy plan with topic clusters
  → Feeds into:
/blog cluster plan <seed-keyword>
  → Creates hub-and-spoke content architecture
  → Feeds into:
/blog calendar
  → 90-day editorial calendar from cluster plan
  → Feeds into:
/blog write <topic>
  → Full article with 5-gate delivery contract
  → Output: final/blog/<post-slug>/
```

---

## Output Folder Convention

```
D:\code\seo\Projects\
└── <domain-slug>\          e.g. example-com\
    ├── raw\                 one .md per agent, written during Phase 2
    ├── final\
    │   ├── report.md
    │   ├── report.pdf
    │   ├── client-audit-report.html
    │   ├── fix-plan.md
    │   ├── health-score.json
    │   ├── audit-meta.json
    │   ├── content-calendar.md        ← NEW (from /blog calendar)
    │   ├── keyword-opportunity-map.md ← NEW (from /seo keyword-research)
    │   ├── blog\                      ← NEW (from /blog write)
    │   │   └── <post-slug>\
    │   │       ├── <post-slug>.md
    │   │       ├── <post-slug>.html
    │   │       ├── <post-slug>.pdf
    │   │       ├── hero.<ext>
    │   │       ├── review.md
    │   │       └── preflight-report.json
    │   └── pages\                     ← NEW (from /seo write-page)
    │       └── <page-slug>.md
    └── brand\                         ← NEW
        ├── BRAND.md
        └── VOICE.md
```

Domain slug = hostname with dots replaced by hyphens, no `www`, lowercase. E.g. `https://www.Example.com/` → `example-com`.

---

## Skill & Agent Reference

Installed skills live at `~/.claude/skills/seo-*/SKILL.md`. Source is `claude-seo/skills/`. All Python scripts are at `~/.claude/skills/seo/scripts/` with the venv at `~/.claude/skills/seo/.venv/`.

Agents live at `~/.claude/agents/seo-*.md`. Non-SEO agents are disabled in `~/.claude/agents/disabled/`.

Active MCPs for this workspace: `firecrawl`, `duckduckgo-search`, `fetch`, `gsc`, `google-analytics`. Disabled: `notion`, `wordpress`, `wp-mcp-ultimate`, `shadcn`, `serper`.

---

## Superpowers Chain

Every audit must invoke superpowers in this order via the `Skill` tool — never improvised inline:

```
superpowers:brainstorming
  → superpowers:writing-plans
  → superpowers:dispatching-parallel-agents
  → superpowers:verification-before-completion
```

---

## Updating Upstream Skills

If AgriciDaniel ships a new version of claude-seo or claude-blog, sync it:
```powershell
cd D:\code\seo
.\update.ps1
```
This re-vendors only `skills/`, `agents/`, `scripts/` from upstream.
Your `.planning/`, `.hooks/`, `.agents/`, `CLAUDE.md` are never touched.

---

## Session Start Protocol

**FIRST ACTION every session:** Read `.planning\STATE.md`.

Check:
- `current_phase` — which phase is active
- `phase_status` — in_progress / planned / blocked
- `active_plan` — the PLAN.md to follow
- `blocked` — if true, read `blocked_reason` before doing anything

Follow the `▶ Next Up` block — it has the exact command to run.

---

## Session End Protocol

**LAST ACTION every session:** Update `.planning\STATE.md`:

1. Set `last_updated` to today's date (YYYY-MM-DD)
2. Set `last_agent` to your model name
3. Update `phase_status` if it changed
4. Write a new `▶ Next Up` block with exact next command:

```
## ▶ Next Up — [SEO-OPS] SEO Operations Platform

**Phase N: Name** — one-line description

`/clear` then:

`/the-exact-command`

**Also available:**
- alternative 1
- alternative 2
```

---

## Local Skill & Agent Paths

All skills and agents load from `vendor/` — no global install needed:

| Component | Path |
|-----------|------|
| SEO orchestrator | `vendor/claude-seo/skills/seo/SKILL.md` |
| SEO sub-skills | `vendor/claude-seo/skills/seo-*/SKILL.md` |
| SEO agents | `vendor/claude-seo/agents/seo-*.md` |
| Blog orchestrator | `vendor/claude-blog/skills/blog/SKILL.md` |
| Blog sub-skills | `vendor/claude-blog/skills/blog-*/SKILL.md` |
| Blog agents | `vendor/claude-blog/agents/blog-*.md` |
| SEO verifier | `.agents/seo-verifier.md` |
| Slug/timestamp tool | `.tools/gsd-tools.cjs` |

When invoking `/blog write`, `/blog calendar`, `/blog cluster` —
skills resolve from `vendor/claude-blog/skills/`.

When invoking `/seo audit`, `/seo schema`, `/seo technical` —
skills resolve from `vendor/claude-seo/skills/`.

---

## State & Planning Files

| File | Purpose |
|------|---------|
| `.planning/STATE.md` | Master handoff — read first, update last |
| `.planning/ROADMAP.md` | All phases and success criteria |
| `.planning/phases/NN-name/PLAN.md` | What to do this phase |
| `.planning/phases/NN-name/SUMMARY.md` | What was done (after completion) |
| `.planning/config.json` | Context window, project code, workflow config |
| `vendor.json` | Upstream repo versions + commit hashes |
