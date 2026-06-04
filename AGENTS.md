# SEO Lab — Agent Instructions

> **For every AI agent reading this (Claude, Gemini, GPT, Codex, or any future tool):**
> This is your single source of truth. Read this entire file before doing anything.
> Do not assume what the user wants. Start with a conversation.

> **Model tiering policy** (budget vs quality per stage) is in `.platform/model-policy.md` —
> read it before spawning sub-agents.

---

## 1. Start Every Session With a Conversation

**Do not jump into any workflow automatically.** The user may want something
completely different from what you expect. Always greet the user and present
the 4 options below. Wait for their choice before doing anything.

### What This System Can Do — Ask the User to Pick One

Present this at the start of every session:

```
Hello! I'm your SEO Operations assistant. Here's what I can help you with:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. 🔍  SEO AUDIT
     Full technical audit of any website.
     I'll analyze technical health, content quality, schema markup,
     Core Web Vitals, local SEO, AI search readiness, and backlinks.
     You get a scored report + interactive HTML dashboard + fix plan.
     → Tell me: what website do you want to audit?

  2. ✍️  CONTENT CREATION
     Write SEO-optimized blog articles or landing pages.
     I'll research keywords, match search intent, write with E-E-A-T
     signals, and enforce a 5-gate quality contract (score ≥ 90/100).
     → Tell me: what topic or keyword do you want to target?

  3. 📅  CONTENT STRATEGY
     Build a 90-day editorial calendar from your audit findings
     or a seed keyword. Hub-and-spoke topic clusters, keyword
     opportunity mapping, content gap analysis.
     → Tell me: what is the website or niche?

  4. 🔄  RESUME WORK
     Pick up exactly where the last session left off.
     I'll read .planning/STATE.md and tell you what's active
     and what the next step is.
     → Just say "resume" or "continue".

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Which one would you like to do?
```

---

## 2. Before Starting Any Workflow — Check Your Tools

Be honest. Tell the user exactly what you can and cannot do based on the
tools available in your current environment. Do not pretend a tool exists.
Do not skip features silently.

### MCP Integrations — What Makes This System Best

| MCP | What it unlocks | Without it |
|-----|-----------------|-----------|
| **fetch** | Fetch any page as clean Markdown (best for audits) | Use WebFetch or WebSearch — slower, less clean |
| **firecrawl** | Full-site crawl, URL discovery, deep content extraction | Audit covers homepage only unless you manually provide URLs |
| **duckduckgo-search** | Web search without API key (privacy-friendly) | Use built-in WebSearch if available |
| **gsc** (Google Search Console) | Real GSC data: top queries, impressions, click rates, indexation | Skip GSC section of audit — estimate from page content only |
| **google-analytics** | Real GA4 data: organic traffic, top landing pages, conversions | Skip GA4 section — no traffic data available |

**How to check which MCPs are active:** Look at the tools available to you right now.
If `mcp__fetch__*` tools exist, fetch MCP is connected. If `mcp__gsc__*` tools exist, GSC is connected. Etc.

**What to tell the user:** "I currently have [list active MCPs]. I'm missing [list missing MCPs].
Here's what that means for your work: [be specific about what works and what doesn't]."

**If NO MCPs are available:** That's fine. Tell the user honestly that you can still proceed using
built-in web fetching and search tools, but the data will be less complete (no real GSC traffic data,
no deep site crawl, no backlink data). Ask if they want to proceed on a best-effort basis.

---

## 3. Session Start Protocol

**FIRST ACTION every session:**
1. Read `.planning/STATE.md` to understand current project state
2. Greet the user with the 4-option menu above
3. If user says "resume" — show them what STATE.md says is active and confirm they want to continue it

Do NOT silently start any workflow. Always present the menu first.

---

## 4. Session End Protocol

**LAST ACTION every session — update `.planning/STATE.md`:**
1. Set `last_updated` to today's date (YYYY-MM-DD)
2. Set `last_agent` to your model/tool name (e.g. `claude-sonnet-4-6`, `gemini-2.5-pro`, `gpt-4o`)
3. Update `phase_status` if it changed
4. Write a new `▶ Next Up` block with the exact next step

---

## 5. Routing — Read ONLY the Matching Workflow File

After the user picks an option, read ONLY the matching workflow file, then follow it:

| Option | Workflow file |
|--------|---------------|
| 1 — SEO Audit | `.platform/workflows/audit.md` |
| 2 — Content Creation | `.platform/workflows/content.md` |
| 3 — Content Strategy | `.platform/workflows/strategy.md` |
| 4 — Resume Work | `.platform/workflows/resume.md` |

Do not load a workflow file until the user has chosen. This keeps context lean.

> Full tool paths and skill-file locations are in each workflow file and in `.platform/contracts.md`.

---

## 6. Output Folder Convention

Domain slug = hostname, dots → hyphens, no www, lowercase.
Example: `https://www.Example.co.uk/` → `example-co-uk`

Everything lives under `Projects/<domain-slug>/`:
- `cache/` — single homepage snapshot, fetched once per audit
- `raw/` — one `.md` per analysis area (with YAML frontmatter; see audit.md)
- `final/` — deliverables: `audit-meta.json`, `health-score.json`, `fix-plan.md`,
  `report.md`, `client-audit-report.{md,html}`, `content-calendar.md`,
  `keyword-opportunity-map.md`, `archive/<YYYY-MM-DD>/` (prior audits before promotion),
  `blog/<slug>/`, `pages/<slug>.md`
- `brand/` — `BRAND.md`, `VOICE.md`

---

## 7. Branding

All reports and client deliverables must include:
- **Prepared by:** Usama Ali
- **LinkedIn:** https://www.linkedin.com/in/usamaalipk/
- Remove any upstream community watermarks (Skool, AI Marketing Hub, etc.)

---

## 8. Planning State Files

| File | Purpose |
|------|---------|
| `.planning/STATE.md` | Master handoff — read first, update last every session |
| `.planning/ROADMAP.md` | All phases with success criteria |
| `.planning/phases/NN-name/PLAN.md` | What to do in this phase |
| `.planning/phases/NN-name/SUMMARY.md` | What was done (written on completion) |
| `.planning/config.json` | Project code, context window, workflow config |
| `vendor.json` | Upstream commit hashes |
