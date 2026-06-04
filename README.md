
<div align="center">

<img src="assets/banner.svg" alt="SEO Lab — AI-powered SEO audit, strategy and content system. Animated terminal-style banner with SEO LAB figlet wordmark in orange gradient, scanning command palette, and pulsing status indicators." width="100%">

</div>

---

<div align="center">

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║    ⚗  SEO Lab                                                   ║
║                                                                  ║
║    Audit  ·  Strategize  ·  Write                               ║
║    AI-powered SEO — any agent, any site, fully local            ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

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

<table>
<tr>
<td width="33%" valign="top">

### 🔍 Full Site Audit

Technical health, content quality, schema markup, Core Web Vitals, local SEO, AI search readiness, and backlinks — all analyzed in parallel by specialist agents.

Delivers a **scored health report**, a prioritized fix plan grouped by urgency, and an **interactive HTML dashboard** ready to hand to a client.

</td>
<td width="33%" valign="top">

### ✍️ Ranked Content

Brief → research → outline → write → quality-score → deliver. Every article goes through a **5-gate preflight** — structure, prose, visuals, SEO, and a minimum **90/100 quality score**.

Below threshold it rewrites itself — up to 3 iterations — before it ever reaches you.

</td>
<td width="33%" valign="top">

### 📅 Content Strategy

Turn one audit into a full content operation. Topic clusters, keyword opportunity maps, hub-and-spoke architecture, and a **90-day editorial calendar** — all built from your audit findings, not guesswork.

</td>
</tr>
<tr>
<td width="33%" valign="top">

### 🤖 Any AI Agent

Works with Claude Code, Gemini CLI, or any AI tool. A shared state file tracks every session — switch agents mid-project, resume after weeks away, or hand off between tools without losing context.

</td>
<td width="33%" valign="top">

### 🔒 Fully Local

Everything runs on your machine. Client data never leaves. No subscriptions, no per-seat pricing, no data sent to third-party dashboards. The system remembers your work across sessions through plain files.

</td>
<td width="33%" valign="top">

### ⚡ One Command Setup

Clone, run `install.ps1`, and you're ready. Python venv, Playwright, and all dependencies handled automatically. When new skill versions release, `update.ps1` syncs them without touching your data.

</td>
</tr>
</table>

---

## Quick Start

```powershell
git clone https://github.com/UsamaAli-PK/SEO-LAB.git
cd SEO-LAB
.\install.ps1
```

Open your AI agent in this folder, then run your first audit:

```
/seo audit https://yoursite.com
```

---

## Commands

### 🔍 Audit

| Command | What it does |
|---------|-------------|
| `/seo audit <url>` | Full parallel site audit — all agents |
| `/seo technical <url>` | Crawlability, redirects, canonicals, security |
| `/seo content <url>` | E-E-A-T, readability, thin content detection |
| `/seo schema <url>` | Schema markup detection and generation |
| `/seo local <url>` | GBP, citations, local pack analysis |
| `/seo geo <url>` | AI Overviews and GEO readiness |
| `/seo performance <url>` | Core Web Vitals — LCP, INP, CLS |
| `/seo cluster <keyword>` | Hub-and-spoke topic architecture |

### ✍️ Content

| Command | What it does |
|---------|-------------|
| `/seo write-blog <keyword>` | Full article with 5-gate delivery |
| `/seo write-page <topic>` | Landing page content |
| `/seo content-plan <url>` | 90-day editorial calendar |
| `/seo keyword-research <seed>` | Keyword opportunity map |
| `/blog brand init` | Set brand voice and tone for a client |

---

## How It Works

Every session starts by reading `.planning/STATE.md` — a plain file that records what's done, what's active, and exactly what comes next. Any agent reads it, picks up from that point, and updates it on the way out. Audits run up to 14 specialist agents in parallel, each producing a structured report. A validation gate checks all outputs exist before scoring begins. Content goes through automated research, structured writing, and a 5-gate preflight — structure, prose, visuals, SEO validation, quality score — before it's ever shown to you.

---

## Keeping It Current

```powershell
.\update.ps1   # pulls latest skill versions — your data and config are never touched
```

---

<div align="center">

Built by [Usama Ali](https://www.linkedin.com/in/usamaalipk/) &nbsp;·&nbsp; MIT License

Powered by [claude-seo](https://github.com/AgriciDaniel/claude-seo) and [claude-blog](https://github.com/AgriciDaniel/claude-blog)

</div>
