
<div align="center">

<img src="assets/banner.svg" alt="SEO Lab — AI-powered SEO audit, strategy and content system. Animated terminal-style banner with SEO LAB figlet wordmark in orange gradient, scanning command palette, and pulsing status indicators." width="100%">

</div>

---

<div align="center">

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10+-blue.svg)](https://www.python.org/)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-blueviolet.svg)](https://claude.ai)
[![Works with Gemini](https://img.shields.io/badge/Works%20with-Gemini-orange.svg)](https://gemini.google.com)
[![Built by Usama Ali](https://img.shields.io/badge/Built%20by-Usama%20Ali-0077B5?logo=linkedin)](https://www.linkedin.com/in/usamaalipk/)

</div>

---

## The Pipeline

```
         Any URL or Keyword
                 │
                 ▼
    ┌────────────────────┐      ┌────────────────────┐      ┌────────────────────┐
    │    🔍  Audit        │─────▶│   📅  Strategy      │─────▶│   ✍️  Content      │
    │                    │      │                    │      │                    │
    │  14 agents run     │      │  Topic clusters,   │      │  Research →        │
    │  in parallel.      │      │  keyword maps,     │      │  Write →           │
    │  Every dimension   │      │  90-day editorial  │      │  5-gate QA →       │
    │  of SEO covered.   │      │  calendar built    │      │  Ship ≥ 90/100     │
    │                    │      │  from audit data.  │      │                    │
    └────────────────────┘      └────────────────────┘      └────────────────────┘
                 │                                                     │
                 ▼                                                     ▼
       health-score.json                                    article.md + .html + .pdf
       fix-plan.md                                          preflight-report.json
       client-audit-report.html                             review.md (all gates passed)
```

---

## What You Get

### 🔍 Audit — Full Site Analysis

14 specialist agents run in parallel. Every dimension of SEO covered in one pass.

<table>
<tr>
<td width="25%" valign="top">

**Technical**
- Crawlability & indexability
- Redirects & canonical tags
- robots.txt & sitemap gaps
- HTTPS & security headers
- JavaScript rendering (CSR vs SSR)

</td>
<td width="25%" valign="top">

**Content & On-Page**
- E-E-A-T signals
- Thin & duplicate content
- Heading hierarchy
- Readability scoring
- Internal linking gaps

</td>
<td width="25%" valign="top">

**Performance**
- Core Web Vitals (LCP, INP, CLS)
- Above-fold rendering
- Mobile responsiveness
- Screenshot capture
- Layout shift detection

</td>
<td width="25%" valign="top">

**Schema & Structure**
- JSON-LD detection & validation
- Google-supported type check
- Schema generation
- Sitemap analysis
- Hreflang validation

</td>
</tr>
<tr>
<td width="25%" valign="top">

**Local SEO**
- Google Business Profile audit
- NAP consistency
- Citation analysis
- Review signals
- Geo-grid rank tracking

</td>
<td width="25%" valign="top">

**GEO & AI Search**
- AI Overviews readiness
- ChatGPT & Perplexity signals
- llms.txt compliance
- Passage-level citability
- AI crawler accessibility

</td>
<td width="25%" valign="top">

**Backlinks & Authority**
- Moz, Bing & Common Crawl data
- Link quality scoring
- Competitor gap analysis
- Toxic link detection
- Anchor text diversity

</td>
<td width="25%" valign="top">

**Deliverables**
- `health-score.json` (0–100)
- `fix-plan.md` (Critical → Low)
- `client-audit-report.html`
  ↳ action planner + score
  ↳ copy-paste dev assets

</td>
</tr>
</table>

---

### ✍️ Content — Research to Delivery

One conversation. Fully automated from research through quality-gated delivery.

<table>
<tr>
<td width="25%" valign="top">

**Research**
- 8–12 sourced statistics
- Tier 1–3 source only
- SERP competitor analysis
- PAA question mining
- Stock images sourced

</td>
<td width="25%" valign="top">

**Writing**
- 12 content templates
- Answer-first formatting
- E-E-A-T signals built in
- Citation capsules
- Information gain markers

</td>
<td width="25%" valign="top">

**Quality Gates (5)**
- Structure & placeholders
- Prose & anti-AI patterns
- Visual audit & alt text
- SEO check (title, meta, schema)
- Score ≥ 90/100 required

</td>
<td width="25%" valign="top">

**Deliverables**
- `article.md` (full source)
- `article.html` (rendered)
- `article.pdf`
- `hero.<ext>` (cover image)
- `preflight-report.json`

</td>
</tr>
</table>

---

### 📅 Strategy — Audit Findings to Content Plan

<table>
<tr>
<td width="33%" valign="top">

**Topic Clustering**
- SERP-based keyword grouping
- Hub-and-spoke architecture
- Pillar + supporting article map
- Internal link matrix
- Cannibalization detection

</td>
<td width="33%" valign="top">

**Editorial Calendar**
- 90-day week-by-week schedule
- 60/30/10 content mix
- Content decay detection
- Seasonal hook mapping
- Freshness update plan

</td>
<td width="33%" valign="top">

**Keyword Research**
- Semantic keyword expansion
- Intent classification
- Difficulty & volume estimates
- Competitor gap analysis
- `keyword-opportunity-map.md`

</td>
</tr>
</table>

---

### 🤖 &nbsp; 🔒 &nbsp; ⚡ Platform

<table>
<tr>
<td width="33%" valign="top">

**Any AI Agent**
Works with Claude, Gemini, GPT, or any future tool — through natural conversation. A shared state file means any agent picks up exactly where the last one stopped.

</td>
<td width="33%" valign="top">

**Fully Local**
Client data never leaves your machine. No subscriptions, no per-seat pricing. Cross-session memory builds — client 10 benefits from everything learned on clients 1 through 9.

</td>
<td width="33%" valign="top">

**One Command Setup**
Clone, run `install.ps1`, ready. Python venv, Playwright, and all dependencies handled. `update.ps1` syncs new skill versions without touching your data or config.

</td>
</tr>
</table>

---

## How You Work With It

SEO Lab is conversation-driven. You open the folder in your AI agent of choice, describe what you need, and the system handles the rest. No memorizing syntax. No switching tools.

**Audit a site**
> "Audit https://example.com and tell me what's hurting its rankings most"

The agent reads the workflow, fetches the page once, runs all analysis in parallel, scores every category, and delivers a prioritized fix plan with an interactive HTML dashboard.

**Write content**
> "Write a blog post targeting 'best CRM for small business' — use the audit findings for context"

The agent researches 8–12 current statistics from Tier 1 sources, builds an outline, writes with E-E-A-T signals baked in, runs a 5-gate quality check, and delivers a complete article with rendered HTML and PDF. If the quality score is below 90/100, it rewrites — you never see a draft that hasn't passed.

**Build a strategy**
> "Build a 90-day content calendar from the audit findings"

The agent maps keyword gaps, groups topics into hub-and-spoke clusters, and produces a week-by-week editorial calendar ready to execute.

**Resume work**
> "What were we working on? Continue from where we left off."

The agent reads `.planning/STATE.md`, shows you the current phase, and picks up from the exact next step — whether that session was yesterday or three weeks ago, and whether it was you, Claude, or Gemini who left off last.

---

## Why SEO Lab Over claude-seo or claude-blog Alone

claude-seo and claude-blog are excellent standalone tools. SEO Lab is built on top of them — and adds the layer that makes them actually usable as a professional operation.

```
┌─────────────────────────────┬──────────────┬──────────────┬──────────────┐
│                             │  claude-seo  │  claude-blog │   SEO Lab    │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Works with any AI agent     │      ✗       │      ✗       │      ✅      │
│ (Claude, Gemini, GPT…)      │  Claude Code │  Claude Code │  Any tool    │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Audit → Content pipeline    │      ✗       │      ✗       │      ✅      │
│ (connected end-to-end)      │  audit only  │ content only │   unified    │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Cross-session memory        │      ✗       │      ✗       │      ✅      │
│ (knows what was done before)│  forgets     │  forgets     │  STATE.md    │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Cross-client learning       │      ✗       │      ✗       │      ✅      │
│ (patterns from past clients)│      —       │      —       │  JSONL store │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Conversation-first workflow │      ✗       │      ✗       │      ✅      │
│ (no slash commands needed)  │ slash cmds   │ slash cmds   │  plain prose │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Self-contained folder       │      ✗       │      ✗       │      ✅      │
│ (no global install needed)  │ ~/.claude/   │ ~/.claude/   │  repo only   │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Cost-aware model routing    │      ✗       │      ✗       │      ✅      │
│ (budget vs quality per task)│  one model   │  one model   │  tiered      │
├─────────────────────────────┼──────────────┼──────────────┼──────────────┤
│ Audit quality gate          │      ✗       │      ✅      │      ✅      │
│ (validates output before    │  no gate     │  blog only   │  audit +     │
│  scoring begins)            │              │              │  blog gates  │
└─────────────────────────────┴──────────────┴──────────────┴──────────────┘
```

---

## Get Started

```powershell
git clone https://github.com/UsamaAli-PK/SEO-LAB.git
cd SEO-LAB
.\install.ps1
```

Open your AI agent in this folder. It reads `.planning/STATE.md` first and tells you exactly where to begin.

---

## Keeping It Current

```powershell
.\update.ps1   # pulls latest skill versions — your data and config are never touched
```

---

<details>
<summary>Quick command reference (for Claude Code users)</summary>

**Audit:** `/seo audit <url>` · `/seo technical` · `/seo content` · `/seo schema` · `/seo local` · `/seo geo` · `/seo performance` · `/seo cluster <keyword>`

**Content:** `/seo write-blog <keyword>` · `/seo write-page <topic>` · `/seo content-plan <url>` · `/seo keyword-research <seed>` · `/blog brand init`

</details>

---

<div align="center">

Built by [Usama Ali](https://www.linkedin.com/in/usamaalipk/) &nbsp;·&nbsp; MIT License

Powered by [claude-seo](https://github.com/AgriciDaniel/claude-seo) and [claude-blog](https://github.com/AgriciDaniel/claude-blog)

</div>
