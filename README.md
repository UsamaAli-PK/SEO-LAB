# SEO Lab

A complete SEO and content system built for AI agents. Audit any website, build content strategy, and write ranked articles — all from a single folder that works with Claude, Gemini, or any AI tool you use.

Built by [Usama Ali](https://www.linkedin.com/in/usamaalipk/)

---

## What It Does

**Full-site SEO audits** — drop in a URL and get a complete technical breakdown: crawlability, content quality, schema markup, Core Web Vitals, local SEO, AI search readiness, and backlinks — all analyzed in parallel. Deliverables include a scored health report, a prioritized fix plan, and an interactive HTML dashboard you can hand straight to a client.

**SEO-optimized content** — brief, research, outline, write, and quality-score a full article in one flow. Every piece goes through a 5-gate delivery check before it reaches you: structure, prose, visuals, SEO validation, and a minimum 90/100 quality score. Below that threshold, it rewrites itself.

**Content strategy** — turn audit findings into a 90-day editorial plan. Topic clusters, keyword opportunity maps, hub-and-spoke architecture, and a publishing calendar built from real search data.

**Multi-agent memory** — the system tracks progress in a single state file any AI agent can read. Switch from Claude to Gemini mid-project, resume after a break, or hand off to a teammate — it always knows exactly where you left off and what comes next.

---

## Get Started

```powershell
git clone https://github.com/UsamaAli-PK/SEO-LAB.git
cd SEO-LAB
.\install.ps1
```

Open your AI agent in this folder, then:

```
/seo audit https://yoursite.com
```

---

## Commands

### Audit
| Command | What it does |
|---------|-------------|
| `/seo audit <url>` | Full parallel site audit |
| `/seo technical <url>` | Crawlability, redirects, canonicals |
| `/seo content <url>` | E-E-A-T, readability, thin content |
| `/seo schema <url>` | Schema detection and generation |
| `/seo local <url>` | GBP, citations, local pack |
| `/seo geo <url>` | AI Overviews and GEO readiness |
| `/seo performance <url>` | Core Web Vitals (LCP, INP, CLS) |
| `/seo cluster <keyword>` | Topic cluster architecture |

### Content
| Command | What it does |
|---------|-------------|
| `/seo write-blog <keyword>` | Full article with 5-gate delivery |
| `/seo write-page <topic>` | Landing page content |
| `/seo content-plan <url>` | 90-day editorial calendar |
| `/seo keyword-research <seed>` | Keyword opportunity map |
| `/blog brand init` | Set brand voice for a client |

---

## How It Works

Every session starts by reading `.planning/STATE.md` — a plain file that records what's been done, what's active, and what comes next. Any agent picks up from exactly that point. No re-explaining context, no starting over.

Audits run up to 14 specialist agents in parallel, each writing a structured report to its own file. A validation gate checks all required outputs exist before scoring begins. Results roll up into a health score, a fix plan, and a client-ready HTML dashboard — all in `Projects/<domain>/`.

Content goes through a research phase (8–12 sourced statistics, images, charts), a structured writing phase following the FLOW evidence framework, and an automated 5-gate preflight before delivery. If any gate fails, it iterates — up to 3 times — before escalating to you.

Everything stays local. Client data never leaves your machine.

---

## Keeping It Current

When new skill versions release:

```powershell
.\update.ps1
```

Your audits, content, state, and configuration are never touched — only the underlying skills update.

---

## License

MIT — [Usama Ali](https://www.linkedin.com/in/usamaalipk/)

Powered by [claude-seo](https://github.com/AgriciDaniel/claude-seo) and [claude-blog](https://github.com/AgriciDaniel/claude-blog), both MIT licensed.
