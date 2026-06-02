# GEMINI.md — SEO Operations Platform

This file provides guidance to Gemini CLI / Antigravity when working in
`D:\code\seo\`. Mirrors CLAUDE.md but uses Gemini conventions.

---

## Workspace Purpose

This is a self-contained SEO operations platform. All skills, agents,
scripts, hooks, and project output live inside this folder.
No external installs required after running `install.ps1` once.

Key repos (vendored — read-only, updated via `update.ps1`):
- `vendor/claude-seo/` — 25 SEO skills, 18 agents, Python scripts
- `vendor/claude-blog/` — 30 blog skills, 5 agents, 9 scripts

---

## Session Start Protocol

**FIRST ACTION:** Read `.planning/STATE.md`

Check:
- `current_phase` — which phase is active
- `phase_status` — in_progress / planned / blocked
- `▶ Next Up` block — the exact command to run next

Do not start any work until you have read STATE.md.

---

## Session End Protocol

**LAST ACTION:** Update `.planning/STATE.md`:

1. Set `last_updated` to today's date
2. Set `last_agent` to `gemini-2.5-pro` (or your model)
3. Update `phase_status` if changed
4. Write a new `▶ Next Up` block with exact next command

---

## Skill Paths (Gemini tool: activate_skill)

| Skill | Path |
|-------|------|
| `/seo audit` | `vendor/claude-seo/skills/seo/SKILL.md` |
| `/seo technical` | `vendor/claude-seo/skills/seo-technical/SKILL.md` |
| `/seo schema` | `vendor/claude-seo/skills/seo-schema/SKILL.md` |
| `/seo local` | `vendor/claude-seo/skills/seo-local/SKILL.md` |
| `/seo geo` | `vendor/claude-seo/skills/seo-geo/SKILL.md` |
| `/seo performance` | `vendor/claude-seo/skills/seo-performance/SKILL.md` |
| `/seo content` | `vendor/claude-seo/skills/seo-content/SKILL.md` |
| `/seo cluster` | `vendor/claude-seo/skills/seo-cluster/SKILL.md` |
| `/blog write` | `vendor/claude-blog/skills/blog-write/SKILL.md` |
| `/blog calendar` | `vendor/claude-blog/skills/blog-calendar/SKILL.md` |
| `/blog cluster` | `vendor/claude-blog/skills/blog-cluster/SKILL.md` |
| `/blog brand` | `vendor/claude-blog/skills/blog-brand/SKILL.md` |
| `/blog analyze` | `vendor/claude-blog/skills/blog-analyze/SKILL.md` |
| `/blog strategy` | `vendor/claude-blog/skills/blog-strategy/SKILL.md` |

---

## Agent Paths

| Agent | Path |
|-------|------|
| seo-technical | `vendor/claude-seo/agents/seo-technical.md` |
| seo-content | `vendor/claude-seo/agents/seo-content.md` |
| seo-schema | `vendor/claude-seo/agents/seo-schema.md` |
| seo-performance | `vendor/claude-seo/agents/seo-performance.md` |
| seo-visual | `vendor/claude-seo/agents/seo-visual.md` |
| seo-geo | `vendor/claude-seo/agents/seo-geo.md` |
| seo-local | `vendor/claude-seo/agents/seo-local.md` |
| seo-maps | `vendor/claude-seo/agents/seo-maps.md` |
| seo-sitemap | `vendor/claude-seo/agents/seo-sitemap.md` |
| seo-sxo | `vendor/claude-seo/agents/seo-sxo.md` |
| seo-cluster | `vendor/claude-seo/agents/seo-cluster.md` |
| seo-flow | `vendor/claude-seo/agents/seo-flow.md` |
| seo-backlinks | `vendor/claude-seo/agents/seo-backlinks.md` |
| seo-google | `vendor/claude-seo/agents/seo-google.md` |
| blog-writer | `vendor/claude-blog/agents/blog-writer.md` |
| blog-researcher | `vendor/claude-blog/agents/blog-researcher.md` |
| blog-reviewer | `vendor/claude-blog/agents/blog-reviewer.md` |
| blog-seo | `vendor/claude-blog/agents/blog-seo.md` |
| seo-verifier | `.agents/seo-verifier.md` |

---

## Full SEO Audit Workflow

Entry point: read `vendor/claude-seo/skills/seo/SKILL.md` and follow
the 5-phase workflow defined there.

Output convention:
```
Projects/<domain-slug>/
├── raw/          one .md per agent
└── final/
    ├── health-score.json
    ├── fix-plan.md
    ├── report.md
    ├── client-audit-report.md
    └── client-audit-report.html
```

Domain slug = hostname with dots → hyphens, no www, lowercase.
Example: `https://www.example.com/` → `example-com`

---

## Blog Content Pipeline

Entry: `/blog brand init` → then `/seo write-blog <keyword>`

Output:
```
Projects/<domain>/final/blog/<post-slug>/
├── <post-slug>.md
├── <post-slug>.html
├── preflight-report.json
├── review.md
└── hero.<ext>
```

Quality gate: article must score ≥ 90/100 via
`vendor/claude-blog/scripts/analyze_blog.py`.

---

## Python Scripts

All scripts use the venv at `vendor/claude-seo/skills/seo/.venv/`.

```powershell
# Run a script
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-seo\skills\seo\scripts\<script>.py"
```

---

## Updating Upstreams

```powershell
.\update.ps1
```

Only touches `vendor/`. Never changes `.planning/`, CLAUDE.md, GEMINI.md,
`.hooks/`, `.agents/`.

---

## State Files

| File | Purpose |
|------|---------|
| `.planning/STATE.md` | Master handoff — read first, update last |
| `.planning/ROADMAP.md` | All phases and success criteria |
| `vendor.json` | Upstream commit hashes for audit trail |
