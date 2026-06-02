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

Wire the 30 blog sub-skills into Claude Code discovery. Run first
end-to-end content generation for centralgear.co.uk.

## Tasks

### 3.1 — Verify CLAUDE.md skill paths point to vendor/
CLAUDE.md must reference `vendor/claude-blog/skills/` and
`vendor/claude-seo/skills/`. Check Local Skill Paths section.

### 3.2 — Brand init for centralgear-co-uk
Run `/blog brand init` in project context.
Output: `Projects/centralgear-co-uk/brand/BRAND.md` + `VOICE.md`
Brand voice: local UK gearbox specialist, Wolverhampton,
plain English, trusted mechanic tone.

### 3.3 — First article
Run `/seo write-blog "DSG gearbox warning signs"`
Output: `Projects/centralgear-co-uk/final/blog/dsg-gearbox-warning-signs/`
Verify with seo-verifier agent after completion.

### 3.4 — Content calendar
Run `/seo content-plan centralgear.co.uk`
Output: `Projects/centralgear-co-uk/final/content-calendar.md`
