# SEO Operations Platform

> A self-contained, AI-agent-ready SEO audit and content production platform.
> Built and maintained by **[Usama Ali](https://www.linkedin.com/in/usamaalipk/)**.

---

## What This Is

A complete SEO operations stack that lives in a single folder. Any AI agent —
Claude Code, Gemini CLI, or any future tool — can open this repo, read
`.planning/STATE.md`, and immediately know what has been done, what is active,
and exactly what command to run next.

**What it does:**
- Full-scale parallel SEO audits (technical, content, schema, performance, local, GEO, backlinks)
- Interactive HTML client dashboards with action planners
- Blog content generation with 5-gate quality enforcement (score ≥ 90/100)
- Editorial calendar and hub-and-spoke content architecture
- Context-safe sessions with prompt injection protection

---

## Quick Start

### New machine setup (one command)

```powershell
git clone https://github.com/usamaali/seo-ops
cd seo-ops
.\install.ps1
```

Then open Claude Code or Gemini CLI in this folder. The agent reads
`.planning/STATE.md` and picks up exactly where work left off.

### Run your first audit

```
/seo audit https://yoursite.com
```

### Write a blog article

```
/blog brand init
/seo write-blog "your target keyword"
```

---

## Platform Architecture

```
seo-ops/
├── .planning/              State system — any agent reads this first
│   ├── STATE.md            Master resume file (current phase, next command)
│   ├── ROADMAP.md          All phases with success criteria
│   └── phases/             Per-phase PLAN.md and SUMMARY.md
│
├── .hooks/                 Session safety (from gsd-core)
│   ├── gsd-context-monitor.js    Warns agent at ≤35% context remaining
│   └── gsd-prompt-guard.js       Blocks prompt injection in .planning/ writes
│
├── .tools/
│   └── gsd-tools.cjs       Slug generation, timestamps (from gsd-core)
│
├── .agents/
│   └── seo-verifier.md     Goal-backward blog delivery verification
│
├── vendor/
│   ├── claude-seo/         25 SEO skills, 18 agents, Python scripts
│   └── claude-blog/        30 blog skills, 5 agents, 9 scripts
│
├── Projects/               Client audit output (gitignored)
│
├── vendor.json             Upstream commit hashes for audit trail
├── install.ps1             One-command full setup
├── update.ps1              Re-sync vendor/ from upstreams
├── CLAUDE.md               Claude Code workflow + session protocols
└── GEMINI.md               Gemini CLI workflow + session protocols
```

---

## Platform Layer (by Usama Ali)

Everything outside `vendor/` is original work:

| Component | What it does |
|-----------|-------------|
| `.planning/` | GSD-inspired state system — phases, STATE.md, ROADMAP.md |
| `.hooks/` | Context safety + prompt injection protection |
| `.agents/seo-verifier.md` | Goal-backward delivery verification agent |
| `CLAUDE.md` | Full workflow orchestration, session start/end protocol |
| `GEMINI.md` | Same for Gemini/Antigravity — shared STATE.md handoff |
| `install.ps1` | Idempotent setup script (Python venv, Playwright, Node check) |
| `update.ps1` | Sparse upstream sync with vendor.json audit trail |
| `vendor.json` | Dependency pinning with upstream commit tracking |

---

## Keeping Skills Updated

When upstream repos (claude-seo, claude-blog) release new versions:

```powershell
.\update.ps1
```

This re-vendors only `skills/`, `agents/`, `scripts/` from upstream.
Your `.planning/`, hooks, agents, and both `CLAUDE.md` / `GEMINI.md`
are **never touched**.

If requirements changed, run `.\install.ps1` afterwards to update the venv.

---

## Multi-Agent Handoff

This platform is designed for any AI agent to pick up another's work:

1. **Session starts** → agent reads `.planning/STATE.md`
2. **Finds** `current_phase`, `phase_status`, `▶ Next Up` block
3. **Runs** the exact command from the Next Up block
4. **Session ends** → agent updates STATE.md with new status + Next Up

Claude Code and Gemini/Antigravity share the same STATE.md file —
they hand off work to each other through the filesystem.

---

## Commands Reference

### SEO Audit
| Command | Description |
|---------|-------------|
| `/seo audit <url>` | Full parallel audit — all 14 agents |
| `/seo technical <url>` | Technical SEO only |
| `/seo content <url>` | Content quality + E-E-A-T |
| `/seo schema <url>` | Schema detection + generation |
| `/seo local <url>` | Local SEO + GBP |
| `/seo geo <url>` | AI Overviews / GEO optimization |
| `/seo performance <url>` | Core Web Vitals |
| `/seo cluster <keyword>` | Hub-and-spoke topic architecture |

### Content Production
| Command | Description |
|---------|-------------|
| `/blog brand init` | Initialize brand voice for current project |
| `/seo write-blog <keyword>` | Full article with 5-gate delivery |
| `/seo write-page <topic>` | Landing page content |
| `/seo content-plan <url>` | 90-day editorial calendar |
| `/seo keyword-research <seed>` | Keyword opportunity map |

---

## Credits & Attribution

**Platform orchestration, state system, installation scripts:**
Usama Ali — [linkedin.com/in/usamaalipk](https://www.linkedin.com/in/usamaalipk/)

**SEO skills engine (`vendor/claude-seo/`):**
[AgriciDaniel/claude-seo](https://github.com/AgriciDaniel/claude-seo) — MIT License

**Blog content engine (`vendor/claude-blog/`):**
[AgriciDaniel/claude-blog](https://github.com/AgriciDaniel/claude-blog) — MIT License

**Context hooks + tools (`.hooks/`, `.tools/`):**
[opengsd/gsd-core](https://github.com/opengsd/gsd-core) — cherry-picked

---

## License

Platform layer (everything outside `vendor/`): MIT
Vendored components: see their respective upstream licenses.
