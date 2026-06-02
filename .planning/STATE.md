---
project: SEO Operations Platform
project_code: SEO-OPS
last_updated: 2026-06-03
last_agent: claude-sonnet-4-6
current_phase: 3
current_phase_name: content-pipeline
phase_status: in_progress
active_plan: .planning/phases/03-content-pipeline/PLAN.md
blocked: false
blocked_reason: null
---

# SEO-OPS State

## What This Project Is

A self-contained SEO operations platform at `D:\code\seo\` (local) /
`github.com/usamaali/seo-ops` (remote). All source repos, agents, skills,
scripts, hooks, and project output live here. No global `~/.claude/`
dependency. Any AI agent (Claude, Gemini, future) reads this file first
to resume work.

## Repo Layout

| Path | Purpose |
|------|---------|
| `vendor/claude-seo/` | 25 SEO skills, 18 agents, 30+ Python scripts |
| `vendor/claude-blog/` | 30 blog skills, 5 agents, 9 scripts |
| `gsd-core-next/` | Reference only — do not edit |
| `.planning/` | State, roadmap, phase plans/summaries |
| `.hooks/` | gsd-context-monitor.js, gsd-prompt-guard.js |
| `.tools/` | gsd-tools.cjs (slug, timestamp utilities) |
| `.agents/` | seo-verifier.md |
| `Projects/` | Client audit output (gitignored) |

## Phase Status

| # | Phase | Status | Key Output |
|---|-------|--------|------------|
| 1 | SEO Audit Engine | ✅ DONE | 25 skills + 18 agents, centralgear audit delivered |
| 2 | Blog Engine Install | ✅ DONE | 30 blog skills + 5 agents in vendor/ |
| 3 | Content Pipeline | 🔄 IN PROGRESS | Wire blog skills, brand init, first article |
| 4 | GSD Optimization | 📋 PLANNED | Hooks wired, verifier, tools tested |
| 5 | GitHub Repo | ✅ DONE | install.ps1, update.ps1, README, vendor.json |

## Active Work

Phase 3: Wire blog sub-skills so `/blog write`, `/blog calendar`,
`/blog cluster` resolve from `vendor/claude-blog/skills/`. Run
`/blog brand init` for centralgear-co-uk. Generate first article.

## ▶ Next Up — [SEO-OPS] SEO Operations Platform

**Phase 3: Content Pipeline** — Init brand voice then generate first blog article

`/clear` then:

`/blog brand init`

**After brand init completes, run:**
`/seo write-blog "DSG gearbox warning signs"`

**Also available:**
- `/seo content-plan centralgear.co.uk` — full content calendar
- `/seo audit <url>` — audit a new client site
- Review `.planning/phases/03-content-pipeline/PLAN.md` for full task list
