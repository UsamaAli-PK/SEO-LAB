---
phase: 03-content-pipeline
status: in_progress
started: 2026-06-03
must_haves:
  - "/blog write resolves to vendor/claude-blog/skills/blog-write/SKILL.md"
  - "brand/BRAND.md + brand/VOICE.md exist for the active client"
  - "First blog article in Projects/<domain-slug>/final/blog/"
  - "Article score >= 90/100 from analyze_blog.py"
---

# Phase 3: Content Pipeline

## Objective

Wire the blog sub-skills into agent discovery and run the first
end-to-end content generation for the active client.

`<domain-slug>` = the active client's domain slug (see slug rule in
`.platform/contracts.md`). Real client folders live in gitignored `Projects/`.

## Tasks (resume from first unchecked)

- [ ] 3.1 — Confirm `.platform/workflows/content.md` references `vendor/claude-blog/skills/` paths
- [ ] 3.2 — Run `/blog brand init` → write `Projects/<domain-slug>/brand/BRAND.md`
- [ ] 3.3 — Write `Projects/<domain-slug>/brand/VOICE.md` (audience, tone, taboo terms)
- [ ] 3.4 — Research phase for the target keyword (8-12 Tier 1-3 stats, images, charts)
- [ ] 3.5 — Write article → `Projects/<domain-slug>/final/blog/<slug>/<slug>.md`
- [ ] 3.6 — Run 5-gate delivery (`blog_preflight.py --strict`), iterate until pass
- [ ] 3.7 — Render HTML/PDF (`blog_render.py`)
- [ ] 3.8 — Run seo-verifier agent to confirm delivery (all 6 files, score >= 90)
- [ ] 3.9 — Append learning: `python .platform/scripts/learn.py add --category content --pattern "..." --source <domain-slug>`
- [ ] 3.10 — Generate content calendar → `Projects/<domain-slug>/final/content-calendar.md`

## Resume Signal

When all tasks checked, update STATE.md: current_phase 4, phase_status in_progress.

## Reference

Full workflow: `.platform/workflows/content.md`
Contracts: `.platform/contracts.md`
