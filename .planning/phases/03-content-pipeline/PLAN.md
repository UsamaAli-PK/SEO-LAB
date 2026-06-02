---
phase: 03-content-pipeline
status: in_progress
started: 2026-06-03
must_haves:
  - "/blog write resolves to vendor/claude-blog/skills/blog-write/SKILL.md"
  - "brand/BRAND.md + brand/VOICE.md exist for centralgear-co-uk"
  - "First blog article in Projects/centralgear-co-uk/final/blog/"
  - "Article score >= 90/100 from analyze_blog.py"
---

# Phase 3: Content Pipeline

## Objective

Wire the blog sub-skills into Claude Code discovery and run the first
end-to-end content generation for centralgear.co.uk.

## Tasks (resume from first unchecked)

- [ ] 3.1 — Confirm `.platform/workflows/content.md` references `vendor/claude-blog/skills/` paths
- [ ] 3.2 — Run `/blog brand init` → write `Projects/centralgear-co-uk/brand/BRAND.md`
- [ ] 3.3 — Write `Projects/centralgear-co-uk/brand/VOICE.md` (local UK gearbox specialist, Wolverhampton, plain English)
- [ ] 3.4 — Research phase for "DSG gearbox warning signs" (8-12 Tier 1-3 stats, images, charts)
- [ ] 3.5 — Write article → `Projects/centralgear-co-uk/final/blog/dsg-gearbox-warning-signs/<slug>.md`
- [ ] 3.6 — Run 5-gate delivery (`blog_preflight.py --strict`), iterate until pass
- [ ] 3.7 — Render HTML/PDF (`blog_render.py`)
- [ ] 3.8 — Run seo-verifier agent to confirm delivery (all 6 files, score >= 90)
- [ ] 3.9 — Append learning: `python .platform/scripts/learn.py add --category content --pattern "..." --source centralgear-co-uk`
- [ ] 3.10 — Generate content calendar → `Projects/centralgear-co-uk/final/content-calendar.md`

## Resume Signal

When all tasks checked, update STATE.md: current_phase 4, phase_status in_progress.

## Reference

Full workflow: `.platform/workflows/content.md`
Contracts: `.platform/contracts.md`
