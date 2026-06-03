---
project: SEO Operations Platform
project_code: SEO-OPS
last_updated: 2026-06-03
last_agent: claude-opus-4-8
current_phase: 3
current_phase_name: content-pipeline
phase_status: in_progress
active_plan: .planning/phases/03-content-pipeline/PLAN.md
blocked: false
blocked_reason: null
---

# SEO-OPS State

## What This Project Is

A self-contained, portable SEO operations platform. The repo root is wherever
this folder is cloned — all paths in the system are relative to it, nothing is
hardcoded. All vendored skills, agents, scripts, hooks, and project output live
inside the repo. No global `~/.claude/` dependency. Any AI agent (Claude,
Gemini, future) reads this file first to resume work.

## Repo Layout

| Path | Purpose |
|------|---------|
| `vendor/claude-seo/` | 25 SEO skills, 18 agents, 30+ Python scripts |
| `vendor/claude-blog/` | 30 blog skills, 5 agents, 9 scripts |
| `deletable/` | Superseded clones + reference repos — safe to delete |
| `.planning/` | State, roadmap, phase plans/summaries |
| `.platform/` | KERNEL: workflows/, scripts/, model-policy.md, contracts.md |
| `.hooks/` | gsd-context-monitor.js, gsd-prompt-guard.js |
| `.tools/` | gsd-tools.cjs (slug, timestamp utilities) |
| `.agents/` | seo-verifier.md |
| `Projects/` | Client audit output (gitignored), `_learnings/learnings.jsonl` |

## Platform Kernel (added 2026-06-03, Phase 6)

The architecture hardening that took the stress-test ratings to A-tier:
- **Router**: `AGENTS.md` is now 159 lines (was 705). Loads ONE workflow on demand.
- **Workflows**: `.platform/workflows/{audit,content,strategy,resume}.md`
- **Scripts**: `.platform/scripts/` — `fetch_cache.py` (fetch once),
  `collect_findings.py` (frontmatter summaries not bodies),
  `audit_preflight.py` (validation gate), `learn.py` (cross-client JSONL memory)
- **Policy**: `.platform/model-policy.md` (budget/quality tiering),
  `.platform/contracts.md` (artifact handoff contracts)

## Phase Status

| # | Phase | Status | Key Output |
|---|-------|--------|------------|
| 1 | SEO Audit Engine | ✅ DONE | 25 skills + 18 agents, first client audit delivered |
| 2 | Blog Engine Install | ✅ DONE | 30 blog skills + 5 agents in vendor/ |
| 3 | Content Pipeline | 🔄 IN PROGRESS | Wire blog skills, brand init, first article |
| 4 | GSD Optimization | 📋 PLANNED | Hooks wired, verifier, tools tested |
| 5 | GitHub Repo | ✅ DONE | install.ps1, update.ps1, README, vendor.json |
| 6 | Architecture Hardening | ✅ DONE | Kernel: router, workflows, scripts, policy, contracts |

## Active Work

Phase 3: Wire blog sub-skills so `/blog write`, `/blog calendar`,
`/blog cluster` resolve from `vendor/claude-blog/skills/`. Run
`/blog brand init` for the active client. Generate first article.

## ▶ Next Up — [SEO-OPS] SEO Operations Platform

**Phase 3: Content Pipeline** — resume at first unchecked task in the PLAN

`/clear` then read `.planning/phases/03-content-pipeline/PLAN.md` and resume
at task 3.1 (the first unchecked `- [ ]`). The kernel is now in place, so:
- Fetch pages via `python .platform/scripts/fetch_cache.py`
- Follow `.platform/workflows/content.md` for the blog build
- Apply model tiering from `.platform/model-policy.md`

**Also available:**
- `/seo audit <url>` — audit a new client (follows `.platform/workflows/audit.md`)
- Review `.planning/phases/06-architecture-hardening/SUMMARY.md` for what just shipped
