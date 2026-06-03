---
phase: 04-gsd-optimization
status: planned
must_haves:
  - "Context monitor hook fires at <=35% context remaining"
  - "Prompt guard scans .planning/ writes for injection patterns"
  - "gsd-tools generate-slug works: node .tools/gsd-tools.cjs generate-slug test"
  - "seo-verifier agent verifies blog delivery goal-backward"
  - "STATE.md updated at end of every session (Next Up block)"
---

# Phase 4: GSD Optimization

## Objective

Wire hooks into settings.local.json. Test gsd-tools. Run seo-verifier
on Phase 3 delivery. Confirm STATE.md discipline is working.

## Tasks

### 4.1 — Verify hooks wired in settings.local.json
PreToolUse: gsd-prompt-guard.js on Write/Edit to .planning/
PostToolUse: gsd-context-monitor.js on every tool call

### 4.2 — Test gsd-tools
`node .tools/gsd-tools.cjs generate-slug "Your Article Title Here"`
Expected: `your-article-title-here`

### 4.3 — Run seo-verifier on Phase 3 output
Verify blog delivery: all 6 files exist, score >=90, all gates passed.

### 4.4 — STATE.md discipline check
Confirm last_updated, last_agent, Next Up block are current.
