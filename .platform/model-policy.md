# Model Policy

Per-stage model tiering for the SEO platform. The goal is to cut LLM spend roughly in half without degrading client deliverables, by matching model strength to the cognitive demand of each stage.

## The Two Modes

- **BUDGET** — the cheapest capable model (Haiku class). Use for mechanical work: extraction, pattern-matching, checklist running, schema/markup generation, formatting, and data fetching. These stages have a right answer that doesn't require deep reasoning.
- **QUALITY** — a strong model (Sonnet/Opus class). Use for work that requires judgment: analysis, scoring, prioritization, prose, and anything a client reads. The cost of a weak answer here is a worse deliverable, so it's worth the premium.

Rule of thumb: if the output is consumed by another machine stage or is a deterministic transform, BUDGET. If a human pays for it or a decision hinges on it, QUALITY.

## How the Policy Is Applied

Model selection is **not** baked into vendor agent files. It is applied at runtime per environment:

- **Claude Code** — the orchestrator passes the model when spawning each sub-agent via the `Task` tool. Do **NOT** edit the `model:` frontmatter in `vendor/claude-seo` or `vendor/claude-blog` agent files — `update.ps1` re-syncs the vendored repos and would overwrite any local edits. The policy lives here, in the orchestrator's dispatch logic, not in the vendor tree.
- **Gemini / other agents** — the human operator (or the driving agent) selects the model at the start of each stage, following the tables below. There is no automatic enforcement; the policy is the checklist.

## Agent Tier Mapping

| Agent | Mode | Rationale |
|-------|------|-----------|
| seo-technical | QUALITY (Sonnet) | Diagnoses crawl/index/CWV issues; needs reasoning about cause and impact |
| seo-content | QUALITY (Sonnet) | E-E-A-T and content-quality judgment is subjective and client-facing |
| seo-schema | BUDGET (Haiku) | Generates/validates JSON-LD against known patterns; deterministic |
| seo-sitemap | BUDGET (Haiku) | Parses and checks sitemap structure; mechanical |
| seo-geo | QUALITY (Sonnet) | AI-citability analysis requires reasoning about how LLMs read content |
| seo-performance | QUALITY (Sonnet) | Interprets CWV/lab data and prioritizes fixes by impact |
| seo-visual | BUDGET (Haiku) | Screenshot/alt-text/asset pattern checks; mostly extraction |
| seo-sxo | BUDGET (Haiku) | Search-experience checklist matching; rule-driven |
| seo-google | QUALITY (Sonnet) | Interprets GSC/GA4 data into insight; analytical judgment |
| seo-backlinks | BUDGET (Haiku) | Pulls and tabulates link metrics from APIs; data formatting |
| seo-dataforseo | BUDGET (Haiku) | DataForSEO API extraction and tabulation; mechanical |
| seo-local | QUALITY (Sonnet) | Local-pack/NAP/citation strategy needs contextual judgment |
| seo-maps | QUALITY (Sonnet) | GBP and maps presence analysis is interpretive |
| seo-cluster | QUALITY (Sonnet) | Semantic clustering and intent grouping requires reasoning |
| seo-flow | QUALITY (Sonnet) | FLOW-framework reasoning over evidence; analytical |
| seo-ecommerce | QUALITY (Sonnet) | Product/catalog/conversion analysis is client-facing judgment |
| seo-drift | BUDGET (Haiku) | Detects ranking/content drift via diffing; pattern-matching |
| seo-image-gen | BUDGET (Haiku) | Prompt assembly and asset orchestration; mechanical |
| blog-researcher | BUDGET (Haiku) | Gathers and tabulates stats/sources; extraction-heavy |
| blog-writer | QUALITY (Sonnet) | Prose quality is the product; client-facing |
| blog-seo | BUDGET (Haiku) | On-page SEO checklist validation; rule-driven |
| blog-reviewer | QUALITY (Sonnet) | Scores quality and makes accept/reject calls; judgment |
| blog-translator | QUALITY (Sonnet) | Native-quality translation requires nuance, not lookup |

### Orchestrator-Level (Client-Facing Judgment)

The orchestrator's own reasoning stages always run QUALITY (Sonnet, escalate to Opus for the highest-stakes synthesis):

| Orchestrator Stage | Mode |
|--------------------|------|
| Phase 3 scoring (health-score.json) | QUALITY (Sonnet/Opus) |
| Phase 4 fix-plan creation | QUALITY (Sonnet/Opus) |
| Phase 5 final report / client deliverables | QUALITY (Sonnet/Opus) |

## Workflow Stage Mapping

| Workflow | Stage | Mode |
|----------|-------|------|
| Audit | Phase 0 — Brainstorm | QUALITY |
| Audit | Phase 2 — Parallel agents | per the Agent Tier table above |
| Audit | Phase 3 — Review / score | QUALITY |
| Audit | Phase 4 — Fix plan | QUALITY |
| Audit | Phase 5 — Reports | QUALITY |
| Content | Research | BUDGET |
| Content | Write | QUALITY |
| Content | Review | QUALITY |
| Strategy | Discovery | QUALITY |
| Strategy | Clustering | QUALITY |
| Strategy | Calendar | BUDGET |

## MCP Discipline

Heavy MCP servers inject their full tool schemas into context on **every turn**, costing tokens whether or not the tools are called. Trim the active MCP set per workflow:

- During **content-writing** and **strategy** work, disable the `gsc` and `google-analytics` MCPs — they are not needed for drafting or planning and only inflate context cost.
- Keep `fetch` and `firecrawl` enabled for audits, where live page retrieval is essential.

This is configured in `.claude/settings.local.json` via the `enabledMcpjsonServers` / `disabledMcpjsonServers` keys. Toggle them at the start of a stage rather than leaving everything on by default.

## Honest Caveat

True automatic, content-aware model routing would require a runtime daemon sitting between the orchestrator and the model API — and that breaks the platform's core design goal that *any agent can just open the folder and work* with no background services. This documented policy is the portable approximation: a human- and agent-readable convention instead of an enforced router. Realistically it gets cost-efficiency to about an **A-**, not a perfect **A**, because nothing prevents an operator from forgetting to downshift. That tradeoff is intentional — portability over the last few percent of savings.
