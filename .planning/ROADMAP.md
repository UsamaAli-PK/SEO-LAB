# SEO Lab — Roadmap

**Project:** SEO-LAB | **Owner:** Usama Ali | **Started:** 2026-06-02

---

## Milestone v1.0 — Full Audit + Content Pipeline

### Phase 1: SEO Audit Engine ✅ COMPLETE
**Goal:** Full-scale parallel SEO audit system operational.

- [x] 25 seo-* skills in `vendor/claude-seo/skills/`
- [x] 18 seo-* agents in `vendor/claude-seo/agents/`
- [x] Python venv + all dependencies installed
- [x] First real client audit delivered (score 46/F) — stored locally in gitignored `Projects/`
- [x] All 5 deliverables: health-score.json, fix-plan.md, report.md, client-audit-report.md, client-audit-report.html

### Phase 2: Blog Engine Install ✅ COMPLETE
**Goal:** claude-blog content engine source present and structured.

- [x] `vendor/claude-blog/` — 30 skills, 5 agents, 9 scripts
- [x] Branding: Usama Ali + LinkedIn credits in all SKILL.md files
- [x] CLAUDE.md updated with Command Bridge + Unified Pipeline

### Phase 3: Content Pipeline 🔄 IN PROGRESS
**Goal:** End-to-end content generation: `/seo write-blog` produces a
complete article from a client's audit findings.

- [ ] CLAUDE.md skill discovery points to `vendor/claude-blog/skills/`
- [ ] `/blog brand init` → `Projects/<domain-slug>/brand/BRAND.md` + `VOICE.md`
- [ ] First blog article → `Projects/<domain-slug>/final/blog/`
- [ ] Article score ≥ 90/100 via analyze_blog.py
- [ ] Content calendar → `Projects/<domain-slug>/final/content-calendar.md`

### Phase 4: GSD Optimization 📋 PLANNED
**Goal:** Context safety, prompt injection protection, goal-backward verification.

- [ ] `.hooks/gsd-context-monitor.js` fires at ≤35% context remaining
- [ ] `.hooks/gsd-prompt-guard.js` blocks injection on .planning/ writes
- [ ] `node .tools/gsd-tools.cjs generate-slug "test"` → `test`
- [ ] `.agents/seo-verifier.md` verifies blog delivery goal-backward
- [ ] SESSION protocol: STATE.md read first + updated last every session

### Phase 5: GitHub Repo ✅ COMPLETE
**Goal:** Repo is public, installable, updatable by others.

- [x] `git init` + `.gitignore`
- [x] `vendor.json` tracks upstream commit hashes
- [x] `install.ps1` — one-command full setup on new machine
- [x] `update.ps1` — re-syncs vendor/ from upstreams
- [x] `README.md` — attribution, quick start, contribution credits

---

## Milestone v2.0 — Execution Engine (Future)

### Phase 6: Write-Enabled seo-coder Agent
- [ ] `seo-coder` agent with scoped file-write access
- [ ] Auto-inject JSON-LD schema, fix robots.txt, update redirects

### Phase 7: Analytics Loop
- [ ] SQLite `seo_history.db` — weekly GSC/GA4 data
- [ ] `seo-drift` monitor running weekly comparisons

### Phase 8: Self-Improving Loop
- [ ] Pre/post fix impact tracker (30/60/90 day)
- [ ] Dynamic rule tuning from ranking outcomes
