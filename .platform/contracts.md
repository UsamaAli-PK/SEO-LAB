# Artifact Contracts

These are the interfaces between pipeline stages. Every agent must honor the contract for the artifacts it produces, because the next stage (and the parsing scripts) depend on the shape, not the agent. Reliable handoffs come from honored contracts, not from hope.

## 1. Raw Audit File Contract

Every `Projects/<domain>/raw/<name>.md` written by an audit agent **MUST** begin with YAML frontmatter in exactly this shape, followed by the full detailed analysis body:

```
---
agent: seo-technical
score: 52            # 0-100 integer, or null if N/A
status: complete     # complete | partial | failed
summary:
  - "First key finding, one line"
  - "Second key finding"
  - "Third key finding"
---

<full detailed analysis body goes here>
```

Field rules:
- `agent` — the producing agent's name, verbatim.
- `score` — integer 0–100, or `null` when a numeric score is not meaningful for that agent.
- `status` — one of `complete`, `partial`, `failed`.
- `summary` — a list of one-line key findings (3 is typical; more is fine).

This frontmatter is **mandatory**. `collect_findings.py` and `audit_preflight.py` parse it to roll up scores, detect failed/partial agents, and assemble the cross-agent summary. A raw file without valid frontmatter is treated as a failed handoff.

## 2. Blog Research Packet Contract

Before `blog-writer` starts drafting, `blog-researcher` MUST hand over a research packet containing at minimum:

- **8–12 statistics**, each as `{ claim, source_name, url, date, tier }` where `tier` is `1`–`3` (1 = primary/authoritative, 3 = weakest acceptable).
- **1 cover image URL**.
- **3–5 inline image URLs**.
- **2–4 chart-worthy datasets** (comparable metrics, trends, or before/after data suitable for an SVG chart).

If the researcher delivers **fewer than 8 statistics**, the handoff is **FAILED**. The writer must reject the packet and request more research **before** drafting — never draft against a thin packet. Catching the quality problem here, at the handoff, is far cheaper than catching it at the final quality gate after a full article has been written.

## 3. Blog Delivery Folder Contract

On a successful blog delivery, `Projects/<domain>/final/blog/<slug>/` must contain:

| File | Notes |
|------|-------|
| `<slug>.md` | The article source |
| `<slug>.html` | Rendered HTML |
| `<slug>.pdf` | Rendered PDF, **or** a documented skip note explaining why it was skipped |
| `hero.<ext>` | Hero image |
| `review.md` | Reviewer scorecard and notes |
| `preflight-report.json` | Machine-readable gate results |

These map to the **5 delivery gates** every blog must pass:

1. **Capability** — required tools/credentials available.
2. **Format** — structure, headings, frontmatter, no placeholders.
3. **Visual** — images present, alt text, responsive/embed integrity.
4. **Content-Review** — reviewer scorecard **≥ 90/100**.
5. **Asset + Link integrity** — all assets present and links resolve.

## 4. Project Folder Layout

Canonical tree for each `Projects/<domain-slug>/`:

```
Projects/<domain-slug>/
├── cache/              # fetched pages (raw HTML/markdown retrieved during the run)
├── raw/                # one .md per agent — per-agent analysis (see contract 1)
├── final/              # client deliverables
│   └── archive/<date>/ # prior deliverables snapshotted by date
├── brand/
│   ├── BRAND.md
│   └── VOICE.md
└── memory.md           # per-client accumulated findings (see contract 5)
```

Plus one global file shared across all clients:

```
Projects/_learnings/learnings.jsonl   # append-only cross-project learnings
```

## 5. Per-Client Memory Contract

`Projects/<domain>/memory.md` is the durable, per-client record so the next session starts informed instead of cold. Shape:

```
---
domain: example-com
first_audited: 2026-01-01
last_touched: 2026-01-15
---

## Findings Log

- 2026-01-01 (seo-technical): Sitemap missing 40% of product URLs.
- 2026-01-01 (orchestrator): Composite health score 46/100, baseline set.
- 2026-01-15 (blog-writer): Published 3 cluster posts targeting the primary topic.
```

Rules:
- Frontmatter carries `domain`, `first_audited`, `last_touched`.
- The **## Findings Log** is **append-only** — never rewrite or delete prior entries.
- Each entry is **dated** and **attributed** to the agent or session that produced it.
- Every workflow appends its key findings here before finishing.

## 6. Domain Slug Rule

Derive the slug from the hostname:
- Take the hostname only (no path, no scheme).
- Drop a leading `www`.
- Lowercase everything.
- Replace dots with hyphens.

Example: `https://www.Example.co.uk/` → `example-co-uk`.
