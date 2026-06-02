# Self-Contained SEO Platform Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform `D:\code\seo\` into a fully self-contained SEO operations platform where any AI agent can open this folder, read `.planning/STATE.md`, and immediately know what exists, what is done, and exactly what to do next — no global `~/.claude/` dependency, no installs required.

**Architecture:** A GSD-inspired `.planning/` state system lives at the root of `D:\code\seo\`. It contains `STATE.md` (machine-readable frontmatter + human prose), `ROADMAP.md` (all phases with success criteria), and per-phase folders tracking what each phase did and verified. Two hooks from `gsd-core-next` (context monitor + prompt guard) are copied into `.hooks\` and wired into `.claude\settings.local.json`. Skills and agents are loaded directly from source repos (`claude-seo\`, `claude-blog\`) via a local CLAUDE.md that overrides global paths. A `.agents\` folder holds the seo-verifier agent adapted from gsd-verifier for our pipeline. `gsd-tools.cjs` lives in `.tools\` for slug/timestamp utilities.

**Tech Stack:** Plain Markdown (STATE.md, ROADMAP.md), JSON (config.json, settings.local.json), Node.js (gsd-tools.cjs — already on system), Python 3.13 (already installed, venv at `claude-seo\skills\seo\.venv`), PowerShell (Windows).

---

## File Map

| Action | Path | Purpose |
|--------|------|---------|
| Create | `.planning\STATE.md` | Master resume file — any agent reads this first |
| Create | `.planning\ROADMAP.md` | All phases, goals, success criteria, status |
| Create | `.planning\config.json` | Planning config (commit_docs: false, no git needed) |
| Create | `.planning\phases\01-seo-audit-engine\SUMMARY.md` | Phase 1 already done — document it |
| Create | `.planning\phases\02-blog-engine-install\SUMMARY.md` | Phase 2 already done — document it |
| Create | `.planning\phases\03-content-pipeline\PLAN.md` | Phase 3 active — blog sub-skills install + first run |
| Create | `.planning\phases\04-gsd-optimization\PLAN.md` | Phase 4 planned — hooks, verifier, tools |
| Copy | `.hooks\gsd-context-monitor.js` | From gsd-core-next\hooks\ |
| Copy | `.hooks\gsd-prompt-guard.js` | From gsd-core-next\hooks\ |
| Copy | `.tools\gsd-tools.cjs` | From gsd-core-next\get-shit-done\bin\ |
| Create | `.tools\README.md` | Docs for gsd-tools usage in this project |
| Copy | `.agents\seo-verifier.md` | Adapted from gsd-core-next\agents\gsd-verifier.md |
| Modify | `.claude\settings.local.json` | Wire hooks + allow skill paths from local source |
| Modify | `CLAUDE.md` | Add mandatory STATE.md read rule + local skill paths |

---

## Task 1: Create the `.planning\` skeleton

**Files:**
- Create: `.planning\config.json`
- Create: `.planning\STATE.md`
- Create: `.planning\ROADMAP.md`

- [ ] **Step 1: Create `.planning\config.json`**

```json
{
  "commit_docs": false,
  "context_window": 200000,
  "project_code": "SEO-OPS",
  "project_title": "SEO Operations Platform",
  "workflow": {
    "human_verify_mode": "end-of-phase"
  }
}
```

Save to `D:\code\seo\.planning\config.json`.

- [ ] **Step 2: Create `.planning\STATE.md`**

This is the master handoff file. Every agent reads this before doing anything else. Every session ends by updating it.

```markdown
---
project: SEO Operations Platform
project_code: SEO-OPS
last_updated: 2026-06-03
last_agent: Claude (claude-sonnet-4-6)
current_phase: 3
current_phase_name: content-pipeline
phase_status: in_progress
active_plan: 03-content-pipeline/PLAN.md
blocked: false
blocked_reason: null
---

# SEO-OPS State

## What This Project Is

A self-contained SEO operations platform at `D:\code\seo\`. All source repos,
agents, skills, scripts, hooks, and project output live here. No global
`~/.claude/` dependency. Any AI agent (Claude, Gemini, future) reads this file
first to resume work.

## Repos In This Folder

| Repo | Purpose | Status |
|------|---------|--------|
| `claude-seo\` | 25 SEO skills, 18 agents, 30+ Python scripts | ✅ Installed source |
| `claude-blog\` | 30 blog skills, 5 agents, 9 scripts | ✅ Source present, sub-skills not yet wired |
| `gsd-core-next\` | Reference only — cherry-pick hooks/tools/agents | 🔖 Reference |
| `Projects\` | Client audit output (`centralgear-co-uk\` done) | ✅ Active |

## Phase Status

| # | Phase | Status | Output |
|---|-------|--------|--------|
| 1 | SEO Audit Engine | ✅ DONE | 25 skills + 18 agents working, centralgear audit delivered |
| 2 | Blog Engine Install | ✅ DONE | 5 blog agents + main blog skill installed |
| 3 | Content Pipeline | 🔄 IN PROGRESS | Install 30 blog sub-skills, wire to /seo commands, first run |
| 4 | GSD Optimization | 📋 PLANNED | Hooks, verifier agent, gsd-tools, STATE.md discipline |

## Active Work

Phase 3: Install blog sub-skills from `claude-blog\skills\` directly into
`CLAUDE.md` skill discovery path. Wire `/seo write-blog`, `/seo content-plan`,
`/seo write-page` commands. Run first end-to-end content generation for
`centralgear-co-uk`.

## ▶ Next Up — [SEO-OPS] SEO Operations Platform

**Phase 3: Content Pipeline** — Install 30 blog sub-skills and run first content generation

`/clear` then:

`/seo content-plan centralgear.co.uk`

**Also available:**
- `/blog write "DSG gearbox repair wolverhampton"` — test blog writing directly
- `/blog brand init` — set up brand voice for centralgear first
- Review `.planning\phases\03-content-pipeline\PLAN.md` for full task list

## Key Files

- Audit output: `Projects\centralgear-co-uk\final\client-audit-report.html`
- Health score: `Projects\centralgear-co-uk\final\health-score.json` (46/F)
- Fix plan: `Projects\centralgear-co-uk\final\fix-plan.md`
- Blog skills source: `claude-blog\skills\`
- SEO skills source: `claude-seo\skills\`
- CLAUDE.md: `D:\code\seo\CLAUDE.md`
```

- [ ] **Step 3: Create `.planning\ROADMAP.md`**

```markdown
# SEO Operations Platform — Roadmap

## Milestone: v1.0 — Full Audit + Content Pipeline

### Phase 1: SEO Audit Engine ✅ COMPLETE

**Goal:** Full-scale parallel SEO audit system operational.

**Success Criteria:**
- [x] 25 seo-* skills discoverable from `claude-seo\skills\`
- [x] 18 seo-* agents loaded from `claude-seo\agents\`
- [x] Python venv at `claude-seo\skills\seo\.venv` with all dependencies
- [x] First real audit delivered: `Projects\centralgear-co-uk\` (score 46/F)
- [x] All 5 deliverables: health-score.json, fix-plan.md, report.md, client-audit-report.md, client-audit-report.html

### Phase 2: Blog Engine Install ✅ COMPLETE

**Goal:** claude-blog content engine source present and base skill installed.

**Success Criteria:**
- [x] `claude-blog\` source repo present at `D:\code\seo\claude-blog\`
- [x] 5 blog-* agents present in `claude-blog\agents\`
- [x] Main `blog\SKILL.md` orchestrator present
- [x] 30 blog-* sub-skill directories present in `claude-blog\skills\`
- [x] 9 blog scripts present in `claude-blog\scripts\`
- [x] Branding: Usama Ali credits in source SKILL.md files

### Phase 3: Content Pipeline 🔄 IN PROGRESS

**Goal:** End-to-end content generation working: `/seo write-blog` produces
a complete blog article from centralgear.co.uk audit findings.

**Success Criteria:**
- [ ] CLAUDE.md skill discovery includes `claude-blog\skills\` path
- [ ] `/blog write` command resolves to `claude-blog\skills\blog-write\SKILL.md`
- [ ] `/blog calendar` command resolves to `claude-blog\skills\blog-calendar\SKILL.md`
- [ ] `/blog brand init` creates `Projects\centralgear-co-uk\brand\BRAND.md`
- [ ] `/blog brand init` creates `Projects\centralgear-co-uk\brand\VOICE.md`
- [ ] First blog article produced at `Projects\centralgear-co-uk\final\blog\`
- [ ] Article passes 5-gate delivery contract (score ≥ 90/100)

### Phase 4: GSD Optimization 📋 PLANNED

**Goal:** Context safety, prompt injection protection, and goal-backward
verification wired into the platform. Any agent session self-manages context.

**Success Criteria:**
- [ ] `.hooks\gsd-context-monitor.js` wired in `.claude\settings.local.json`
- [ ] `.hooks\gsd-prompt-guard.js` wired in `.claude\settings.local.json`
- [ ] `.tools\gsd-tools.cjs` available for slug/timestamp generation
- [ ] `.agents\seo-verifier.md` adapted from gsd-verifier for blog 5-gate check
- [ ] Context warning fires at ≤35% remaining (tested)
- [ ] Prompt injection attempt blocked on `.planning\` write (tested)
- [ ] STATE.md updated at end of every session (disciplined handoff)

### Phase 5: Growth Plan — Execution Engine 📋 FUTURE

**Goal:** Write-enabled `seo-coder` agent that applies fixes directly to client
sites, SQLite drift history, competitive intelligence module.

**Success Criteria:** (To be defined when Phase 4 complete)
- [ ] `seo-coder` agent with scoped write access
- [ ] SQLite `seo_history.db` tracking GSC/GA4 weekly
- [ ] Competitor SERP scraping pipeline
- [ ] Self-improving rule tuning loop
```

- [ ] **Step 4: Create phase directories**

```powershell
New-Item -ItemType Directory -Force "D:\code\seo\.planning\phases\01-seo-audit-engine"
New-Item -ItemType Directory -Force "D:\code\seo\.planning\phases\02-blog-engine-install"
New-Item -ItemType Directory -Force "D:\code\seo\.planning\phases\03-content-pipeline"
New-Item -ItemType Directory -Force "D:\code\seo\.planning\phases\04-gsd-optimization"
```

Expected: four directories created, no errors.

---

## Task 2: Document completed phases (1 & 2)

**Files:**
- Create: `.planning\phases\01-seo-audit-engine\SUMMARY.md`
- Create: `.planning\phases\02-blog-engine-install\SUMMARY.md`

- [ ] **Step 1: Create Phase 1 SUMMARY**

```markdown
---
phase: 01-seo-audit-engine
status: complete
completed: 2026-06-02
agent: Claude + Gemini (Antigravity)
key_files:
  - claude-seo/skills/seo/SKILL.md
  - claude-seo/agents/seo-technical.md
  - Projects/centralgear-co-uk/final/client-audit-report.html
  - Projects/centralgear-co-uk/final/health-score.json
---

# Phase 1: SEO Audit Engine — COMPLETE

## What Was Built

Full-scale parallel SEO audit system. 25 skills + 18 agents operational.
Python 3.13 venv configured with all dependencies.

## First Client Audit: centralgear.co.uk

- **Score:** 46/100 (Grade F)
- **Output:** `Projects\centralgear-co-uk\` — all 5 deliverables present
- **Top critical issues:** 404 booking page, counter bug showing "1%", dual
  URL structure (/service/ vs /services/), missing AutoRepair schema
- **Delivered:** health-score.json, fix-plan.md, report.md,
  client-audit-report.md, client-audit-report.html (interactive SPA dashboard)

## Skills Installed

All 25 seo-* skills in `claude-seo\skills\`. All 18 agents in
`claude-seo\agents\`. Python scripts at `claude-seo\skills\seo\scripts\`.

## Notes

- Branding: community watermarks replaced with Usama Ali + LinkedIn credits
- CLAUDE.md written with full 5-phase audit workflow
- HTML dashboard features: radial score widget, Action Planner with
  localStorage persistence, Developer Assets tab with copy snippets
```

Save to `D:\code\seo\.planning\phases\01-seo-audit-engine\SUMMARY.md`.

- [ ] **Step 2: Create Phase 2 SUMMARY**

```markdown
---
phase: 02-blog-engine-install
status: complete
completed: 2026-06-02
agent: Gemini (Antigravity session 779a2e51)
key_files:
  - claude-blog/skills/blog/SKILL.md
  - claude-blog/agents/blog-writer.md
  - claude-blog/scripts/analyze_blog.py
---

# Phase 2: Blog Engine Install — COMPLETE

## What Was Built

claude-blog content engine source cloned to `D:\code\seo\claude-blog\`.
Base blog orchestrator skill present. 5 blog agents present.
30 blog sub-skill directories present in `claude-blog\skills\`.

## What Is Still Needed (Phase 3)

The 30 blog sub-skills exist in source (`claude-blog\skills\blog-write\`,
`claude-blog\skills\blog-calendar\`, etc.) but are NOT yet discoverable by
Claude Code because CLAUDE.md does not point to `claude-blog\skills\`.
Phase 3 wires this.

## Skills Present in Source

30 sub-skills: blog-write, blog-analyze, blog-audio, blog-audit, blog-brand,
blog-brief, blog-calendar, blog-cannibalization, blog-chart, blog-cluster,
blog-discourse, blog-factcheck, blog-flow, blog-geo, blog-google, blog-image,
blog-locale-audit, blog-localize, blog-multilingual, blog-notebooklm,
blog-outline, blog-persona, blog-repurpose, blog-rewrite, blog-schema,
blog-seo-check, blog-strategy, blog-taxonomy, blog-translate.

## Agents Present in Source

blog-researcher.md, blog-reviewer.md, blog-seo.md, blog-translator.md,
blog-writer.md — all in `claude-blog\agents\`.

## Notes

- Branding: Usama Ali + LinkedIn credits in source SKILL.md
- CLAUDE.md updated with Command Bridge, Unified Pipeline docs
- `claude-blog\scripts\analyze_blog.py --help` verified working
```

Save to `D:\code\seo\.planning\phases\02-blog-engine-install\SUMMARY.md`.

---

## Task 3: Write Phase 3 and Phase 4 PLANs

**Files:**
- Create: `.planning\phases\03-content-pipeline\PLAN.md`
- Create: `.planning\phases\04-gsd-optimization\PLAN.md`

- [ ] **Step 1: Create Phase 3 PLAN**

```markdown
---
phase: 03-content-pipeline
status: in_progress
started: 2026-06-03
must_haves:
  truths:
    - "/blog write resolves to claude-blog\\skills\\blog-write\\SKILL.md"
    - "brand/BRAND.md and brand/VOICE.md created for centralgear-co-uk"
    - "At least one blog article produced in Projects\\centralgear-co-uk\\final\\blog\\"
    - "Article score ≥ 90/100 from analyze_blog.py"
  artifacts:
    - path: "claude-blog\\skills\\blog-write\\SKILL.md"
      provides: "Blog writing skill"
    - path: "Projects\\centralgear-co-uk\\brand\\BRAND.md"
      provides: "Client brand voice"
    - path: "Projects\\centralgear-co-uk\\final\\blog"
      provides: "First delivered blog article"
---

# Phase 3: Content Pipeline

## Objective

Wire the 30 blog sub-skills from `claude-blog\skills\` into the platform so
Claude Code discovers them. Run first end-to-end content generation for
centralgear.co.uk.

## Tasks

### 3.1 — Update CLAUDE.md to discover blog sub-skills

CLAUDE.md currently only references `claude-seo\` source. Add a skills
discovery section pointing Claude Code at `claude-blog\skills\` so all
30 sub-skills and 5 agents are loaded from source.

**How Claude Code discovers local skills:** Add a `## Local Skills` section
to CLAUDE.md that lists the local paths. Claude Code reads CLAUDE.md at
session start and the Skill tool will resolve local paths.

Add to CLAUDE.md under a new `## Local Skill Paths` section:

```
## Local Skill Paths

Skills and agents load directly from source — no install step needed:

- SEO skills: `D:\code\seo\claude-seo\skills\`
- Blog skills: `D:\code\seo\claude-blog\skills\`
- SEO agents: `D:\code\seo\claude-seo\agents\`
- Blog agents: `D:\code\seo\claude-blog\agents\`
- Verifier agent: `D:\code\seo\.agents\`
```

Also update `.claude\settings.local.json` to allow Skill invocations for
all blog-* skills.

### 3.2 — Brand init for centralgear-co-uk

Run `/blog brand init` in the context of the centralgear project. This
creates `Projects\centralgear-co-uk\brand\BRAND.md` and `brand\VOICE.md`.
The brand voice should reflect: local UK gearbox specialist, Wolverhampton,
plain English, trusted mechanic tone.

### 3.3 — First content generation

Run `/seo write-blog "DSG gearbox warning signs"` which delegates to
`/blog write`. Output goes to:
`Projects\centralgear-co-uk\final\blog\dsg-gearbox-warning-signs\`

Verify: article file exists, score ≥ 90/100 via analyze_blog.py.

### 3.4 — Generate content calendar

Run `/seo content-plan centralgear.co.uk` which delegates to
`/blog calendar` + `/blog cluster`. Output:
`Projects\centralgear-co-uk\final\content-calendar.md`

## Resume Signal

When all must_haves are met, update STATE.md:
- `current_phase: 4`
- `current_phase_name: gsd-optimization`
- `phase_status: in_progress`
```

Save to `D:\code\seo\.planning\phases\03-content-pipeline\PLAN.md`.

- [ ] **Step 2: Create Phase 4 PLAN**

```markdown
---
phase: 04-gsd-optimization
status: planned
must_haves:
  truths:
    - "Context monitor hook fires warning when context ≤ 35%"
    - "Prompt guard scans writes to .planning\\ for injection patterns"
    - "gsd-tools.cjs generate-slug produces correct URL slugs"
    - "seo-verifier agent runs goal-backward check on blog delivery"
    - "STATE.md updated with Next Up block at end of session"
  artifacts:
    - path: ".hooks\\gsd-context-monitor.js"
      provides: "Context window warning injection"
    - path: ".hooks\\gsd-prompt-guard.js"
      provides: "Prompt injection scanning"
    - path: ".tools\\gsd-tools.cjs"
      provides: "Slug and timestamp utilities"
    - path: ".agents\\seo-verifier.md"
      provides: "Goal-backward delivery verification"
---

# Phase 4: GSD Optimization

## Objective

Copy 3 files from `gsd-core-next`, wire 2 hooks, create adapted verifier
agent. Add STATE.md update discipline to CLAUDE.md.

## Tasks

### 4.1 — Copy hooks from gsd-core-next

Copy exactly:
- `gsd-core-next\hooks\gsd-context-monitor.js` → `.hooks\gsd-context-monitor.js`
- `gsd-core-next\hooks\gsd-prompt-guard.js` → `.hooks\gsd-prompt-guard.js`

No modifications needed. These are standalone Node.js hooks.

### 4.2 — Copy gsd-tools.cjs

Copy `gsd-core-next\get-shit-done\bin\gsd-tools.cjs` → `.tools\gsd-tools.cjs`

Test: `node D:\code\seo\.tools\gsd-tools.cjs generate-slug "DSG Gearbox Warning Signs"`
Expected output: `dsg-gearbox-warning-signs`

### 4.3 — Wire hooks into settings.local.json

Add PostToolUse and PreToolUse hooks to `.claude\settings.local.json`:

```json
{
  "permissions": { ... existing ... },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "node D:\\code\\seo\\.hooks\\gsd-prompt-guard.js"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "node D:\\code\\seo\\.hooks\\gsd-context-monitor.js"
          }
        ]
      }
    ]
  }
}
```

### 4.4 — Create seo-verifier agent

Adapt `gsd-core-next\agents\gsd-verifier.md` for our blog delivery pipeline.
The SEO verifier checks: did `/blog write` actually produce all 6 required
files (article.md, article.html, article.pdf, hero.ext, review.md,
preflight-report.json)? Did it score ≥ 90/100? Were all 5 gates passed?

Save as `.agents\seo-verifier.md`.

### 4.5 — Add STATE.md discipline to CLAUDE.md

Add a mandatory section to CLAUDE.md:

```
## Session Start Protocol

FIRST ACTION every session: Read `.planning\STATE.md`.
Check `current_phase`, `phase_status`, `active_plan`, `blocked`.
Follow the `▶ Next Up` block for the exact next command.

## Session End Protocol

LAST ACTION every session: Update `.planning\STATE.md`:
1. Set `last_updated` to today's date
2. Set `last_agent` to your model name
3. Update `phase_status` if it changed
4. Write a new `▶ Next Up` block with the exact next command
```

## Resume Signal

When all must_haves are met, update STATE.md:
- `current_phase: 5` (or mark v1.0 complete if growth plan not started)
- Write milestone completion note
```

Save to `D:\code\seo\.planning\phases\04-gsd-optimization\PLAN.md`.

---

## Task 4: Copy GSD components into the platform

**Files:**
- Copy: `.hooks\gsd-context-monitor.js` (from gsd-core-next)
- Copy: `.hooks\gsd-prompt-guard.js` (from gsd-core-next)
- Copy: `.tools\gsd-tools.cjs` (from gsd-core-next)
- Create: `.tools\README.md`

- [ ] **Step 1: Create `.hooks\` and `.tools\` directories**

```powershell
New-Item -ItemType Directory -Force "D:\code\seo\.hooks"
New-Item -ItemType Directory -Force "D:\code\seo\.tools"
```

- [ ] **Step 2: Copy hook files**

```powershell
Copy-Item "D:\code\seo\gsd-core-next\hooks\gsd-context-monitor.js" `
          "D:\code\seo\.hooks\gsd-context-monitor.js"

Copy-Item "D:\code\seo\gsd-core-next\hooks\gsd-prompt-guard.js" `
          "D:\code\seo\.hooks\gsd-prompt-guard.js"
```

Verify:
```powershell
Test-Path "D:\code\seo\.hooks\gsd-context-monitor.js"  # True
Test-Path "D:\code\seo\.hooks\gsd-prompt-guard.js"     # True
```

- [ ] **Step 3: Copy gsd-tools.cjs**

```powershell
Copy-Item "D:\code\seo\gsd-core-next\get-shit-done\bin\gsd-tools.cjs" `
          "D:\code\seo\.tools\gsd-tools.cjs"
```

- [ ] **Step 4: Verify gsd-tools works**

```powershell
node "D:\code\seo\.tools\gsd-tools.cjs" generate-slug "DSG Gearbox Warning Signs"
```

Expected output: `dsg-gearbox-warning-signs`

```powershell
node "D:\code\seo\.tools\gsd-tools.cjs" current-timestamp filename
```

Expected output: something like `2026-06-03_142310`

- [ ] **Step 5: Create `.tools\README.md`**

```markdown
# .tools

Utility scripts for the SEO Operations Platform.

## gsd-tools.cjs

Adapted from [gsd-core-next](../gsd-core-next/get-shit-done/bin/gsd-tools.cjs).
Used for: slug generation, timestamp formatting, path verification.

### Commands used in this project

```powershell
# Generate URL-safe slug for blog post filenames
node .tools\gsd-tools.cjs generate-slug "Your Blog Post Title"
# Output: your-blog-post-title

# Get filename-safe timestamp
node .tools\gsd-tools.cjs current-timestamp filename
# Output: 2026-06-03_142310

# Check a path exists
node .tools\gsd-tools.cjs verify-path-exists "Projects\centralgear-co-uk"
# Output: exists or not-found
```
```

---

## Task 5: Create the seo-verifier agent

**Files:**
- Create: `.agents\seo-verifier.md`

- [ ] **Step 1: Create `.agents\` directory**

```powershell
New-Item -ItemType Directory -Force "D:\code\seo\.agents"
```

- [ ] **Step 2: Create the agent file**

```markdown
---
name: seo-verifier
description: Verifies that a blog article delivery actually meets the 5-gate contract. Checks all 6 required files exist, score ≥ 90/100, and all gates passed. Goal-backward: task complete ≠ goal achieved. Spawned after /blog write completes.
tools: Read, Bash, Grep, Glob
color: green
---

<role>
Verify that a `/blog write` delivery actually met the 5-gate contract.
Do NOT trust "gates passed" claims in prose. Read the actual files.

Goal-backward verification:
1. What must be TRUE for the blog delivery to be complete?
2. What files must EXIST?
3. What scores must be MET?

Start from the required outcome, verify backwards into the file system.
</role>

<required_truths>
For a blog delivery at `Projects\<domain>\final\blog\<slug>\` to be COMPLETE:

1. `<slug>.md` exists and is > 800 words (not a stub)
2. `<slug>.html` exists and is > 5000 bytes (rendered, not empty)
3. `preflight-report.json` exists and has `overall_score >= 90`
4. `review.md` exists and lists all 5 gates as PASSED
5. `hero.<ext>` exists (any image extension)
6. Brand voice loaded: `Projects\<domain>\brand\BRAND.md` exists
</required_truths>

<verification_steps>

## Step 1: Locate the delivery

```powershell
$slug = "<slug>"
$domain = "<domain>"
$base = "D:\code\seo\Projects\$domain\final\blog\$slug"
Get-ChildItem $base -ErrorAction SilentlyContinue
```

If the directory does not exist: FAILED — delivery not found.

## Step 2: Check required files

For each required file:
- Exists? ✓ / ✗
- Substantive? (not empty/stub)

```powershell
# Word count of article
(Get-Content "$base\$slug.md" | Measure-Object -Word).Words

# HTML size
(Get-Item "$base\$slug.html").Length

# Preflight score
Get-Content "$base\preflight-report.json" | ConvertFrom-Json | Select overall_score

# Hero image
Get-ChildItem "$base" | Where-Object { $_.Name -match "^hero\." }
```

## Step 3: Read preflight-report.json

Parse `overall_score`. If < 90: FAILED with score shown.
Check `gates` array — all 5 must be `"status": "PASSED"`.

## Step 4: Read review.md

Scan for gate pass/fail markers. Any FAILED gate = delivery not complete.

## Step 5: Check brand voice

```powershell
Test-Path "D:\code\seo\Projects\$domain\brand\BRAND.md"
```

If missing: WARNING — brand voice not initialized.

## Step 6: Report

Output one of:

**DELIVERY VERIFIED** — all 6 truths confirmed, score X/100, all gates passed.

**DELIVERY FAILED** — list each failed truth with evidence.

**DELIVERY PARTIAL** — list what passed and what needs re-run.
</verification_steps>

<critical_rules>
- Never trust prose claims. Read the files.
- A file existing ≠ a file being complete. Check word count and byte size.
- Score 89/100 is a FAIL. The threshold is ≥ 90, not "close to 90".
- Missing hero image = incomplete delivery even if prose is excellent.
- Always check brand voice — content without brand context may need rewrite.
</critical_rules>
```

Save to `D:\code\seo\.agents\seo-verifier.md`.

---

## Task 6: Update `.claude\settings.local.json` with hooks

**Files:**
- Modify: `.claude\settings.local.json`

- [ ] **Step 1: Read the current file**

Current content (from earlier read):
```json
{
  "permissions": {
    "allow": [
      "Bash(bash install.sh)",
      "Bash(py --version)",
      "Bash(py -3 --version)",
      "Bash(start:*)",
      "WebFetch(domain:rmcsltd.com)",
      "WebSearch",
      "Skill(seo)",
      "WebFetch(domain:aiautomationagencylondon.co.uk)",
      "Bash(claude mcp:*)",
      "Bash(CLAUDE_CODE_GIT_BASH_PATH=\"C:/Program Files/Git/bin/bash.exe\" claude mcp:*)",
      "Bash(CLAUDE_CODE_GIT_BASH_PATH=\"/usr/bin/bash\" claude mcp:*)",
      "mcp__fetch__get_markdown"
    ]
  }
}
```

- [ ] **Step 2: Write updated settings with hooks wired**

```json
{
  "permissions": {
    "allow": [
      "Bash(bash install.sh)",
      "Bash(py --version)",
      "Bash(py -3 --version)",
      "Bash(start:*)",
      "WebFetch(domain:rmcsltd.com)",
      "WebSearch",
      "Skill(seo)",
      "Skill(blog)",
      "Skill(blog-*)",
      "WebFetch(domain:aiautomationagencylondon.co.uk)",
      "Bash(claude mcp:*)",
      "Bash(CLAUDE_CODE_GIT_BASH_PATH=\"C:/Program Files/Git/bin/bash.exe\" claude mcp:*)",
      "Bash(CLAUDE_CODE_GIT_BASH_PATH=\"/usr/bin/bash\" claude mcp:*)",
      "mcp__fetch__get_markdown",
      "Bash(node D:\\code\\seo\\.tools\\gsd-tools.cjs*)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "node D:\\code\\seo\\.hooks\\gsd-prompt-guard.js"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "node D:\\code\\seo\\.hooks\\gsd-context-monitor.js"
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: Verify JSON is valid**

```powershell
Get-Content "D:\code\seo\.claude\settings.local.json" | ConvertFrom-Json | Out-Null
Write-Host "JSON valid"
```

Expected: `JSON valid` with no parse errors.

---

## Task 7: Update CLAUDE.md with session protocols and local skill paths

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Read the current CLAUDE.md end** (it's ~270 lines — read last section)

Check what the current last section is (`## Re-installing claude-seo`).

- [ ] **Step 2: Append the new sections to CLAUDE.md**

Add after the existing content:

```markdown
---

## Session Start Protocol

**FIRST ACTION every session:** Read `.planning\STATE.md`.

Check these fields:
- `current_phase` — which phase is active
- `phase_status` — in_progress / planned / blocked
- `active_plan` — the PLAN.md to execute
- `blocked` — if true, read `blocked_reason` before doing anything

Follow the `▶ Next Up` block — it has the exact command to run.

---

## Session End Protocol

**LAST ACTION every session:** Update `.planning\STATE.md`:

1. Set `last_updated` to today's date (YYYY-MM-DD)
2. Set `last_agent` to your model name (e.g. `claude-sonnet-4-6`)
3. Update `phase_status` if it changed
4. Write a new `▶ Next Up` block:

```
## ▶ Next Up — [SEO-OPS] SEO Operations Platform

**Phase N: Name** — one-line description of next task

`/clear` then:

`/the exact command to run`

**Also available:**
- alternative 1
- alternative 2
```

---

## Local Skill & Agent Paths

Skills and agents load directly from source repos — no install step:

| Component | Source Path |
|-----------|-------------|
| SEO orchestrator | `claude-seo\skills\seo\SKILL.md` |
| SEO sub-skills | `claude-seo\skills\seo-*\SKILL.md` |
| SEO agents | `claude-seo\agents\seo-*.md` |
| Blog orchestrator | `claude-blog\skills\blog\SKILL.md` |
| Blog sub-skills | `claude-blog\skills\blog-*\SKILL.md` |
| Blog agents | `claude-blog\agents\blog-*.md` |
| SEO verifier agent | `.agents\seo-verifier.md` |
| Slug/timestamp tool | `.tools\gsd-tools.cjs` |

When invoking `/blog write`, `/blog calendar`, etc. — the Skill tool
resolves these from `claude-blog\skills\`. When invoking `/seo audit`,
`/seo schema`, etc. — resolves from `claude-seo\skills\`.

---

## State & Planning Files

| File | Purpose |
|------|---------|
| `.planning\STATE.md` | Master handoff — read first, update last |
| `.planning\ROADMAP.md` | All phases and success criteria |
| `.planning\phases\NN-name\PLAN.md` | What to do in this phase |
| `.planning\phases\NN-name\SUMMARY.md` | What was done (written after completion) |
| `.planning\config.json` | Context window, project code, workflow config |
```

- [ ] **Step 3: Verify CLAUDE.md is readable**

```powershell
(Get-Content "D:\code\seo\CLAUDE.md" | Measure-Object -Line).Lines
```

Expected: more than 270 lines (previous count + new sections).

---

## Task 8: Self-check and STATE.md final update

**Files:**
- Modify: `.planning\STATE.md` (update to reflect plan complete)

- [ ] **Step 1: Verify all created files exist**

```powershell
$files = @(
  "D:\code\seo\.planning\config.json",
  "D:\code\seo\.planning\STATE.md",
  "D:\code\seo\.planning\ROADMAP.md",
  "D:\code\seo\.planning\phases\01-seo-audit-engine\SUMMARY.md",
  "D:\code\seo\.planning\phases\02-blog-engine-install\SUMMARY.md",
  "D:\code\seo\.planning\phases\03-content-pipeline\PLAN.md",
  "D:\code\seo\.planning\phases\04-gsd-optimization\PLAN.md",
  "D:\code\seo\.hooks\gsd-context-monitor.js",
  "D:\code\seo\.hooks\gsd-prompt-guard.js",
  "D:\code\seo\.tools\gsd-tools.cjs",
  "D:\code\seo\.agents\seo-verifier.md"
)

$files | ForEach-Object {
  $exists = Test-Path $_
  $status = if ($exists) { "✓" } else { "✗ MISSING" }
  Write-Host "$status  $_"
}
```

Expected: all lines show `✓`.

- [ ] **Step 2: Update STATE.md `▶ Next Up` block**

After all tasks complete, update the `▶ Next Up` block in STATE.md to
reflect that Phase 3 (content pipeline) is now the active work:

Change the Next Up section to:

```
## ▶ Next Up — [SEO-OPS] SEO Operations Platform

**Phase 3: Content Pipeline** — Wire blog sub-skills, init brand voice, generate first article

`/clear` then:

`/blog brand init`

**Why brand first:** brand voice must exist before writing content.
After brand init, run:
`/seo write-blog "DSG gearbox warning signs"`

**Also available:**
- `/seo content-plan centralgear.co.uk` — generate full content calendar
- Review `.planning\phases\03-content-pipeline\PLAN.md` for all tasks
```

---

## Self-Review

### Spec Coverage Check

| Requirement | Covered By |
|-------------|-----------|
| Self-contained folder, no ~/.claude/ dependency | Task 7 (CLAUDE.md local paths) |
| STATE.md as master resume file for any agent | Task 1 Step 2 |
| ROADMAP.md with all phases | Task 1 Step 3 |
| Phase folders with PLAN/SUMMARY | Tasks 2 & 3 |
| gsd-context-monitor hook wired | Tasks 4 & 6 |
| gsd-prompt-guard hook wired | Tasks 4 & 6 |
| gsd-tools.cjs for slug/timestamp | Task 4 |
| seo-verifier agent adapted for blog | Task 5 |
| Session start/end discipline in CLAUDE.md | Task 7 |
| Blog sub-skills discoverable | Task 7 (local skill paths table) |
| settings.local.json updated | Task 6 |

### Placeholder Scan

No TBD, TODO, or incomplete sections in this plan. All file content is
complete and copy-pasteable.

### Type/Name Consistency

- `STATE.md` used consistently throughout (not `state.md`)
- `.planning\` used consistently (not `.planning/`)
- `centralgear-co-uk` slug used consistently
- `gsd-tools.cjs` referenced by exact name throughout
