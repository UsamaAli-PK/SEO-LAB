# Content Strategy Workflow (Option 3)

> Loaded lazily when the user picks Option 3 in `AGENTS.md`. Read this file fully before starting.

Full skill references:
- `vendor/claude-blog/skills/blog-strategy/SKILL.md` — positioning + topic architecture
- `vendor/claude-blog/skills/blog-cluster/SKILL.md` — semantic cluster planning + execution
- `vendor/claude-blog/skills/blog-calendar/SKILL.md` — editorial calendar with decay detection

---

## Step 1 — Discovery Questions

Ask the user (wait for each answer):
1. What does the business do and who are the customers?
2. Blog goals: traffic / leads / authority / AI citations?
3. Is there existing blog content? (scan `Projects/<domain>/final/blog/` if present)
4. Do you have a completed SEO audit? (check `Projects/<domain>/final/health-score.json`)
5. Who are 3–5 main competitors?
6. What unique expertise or data does this brand have?
7. Publishing capacity: how many posts per week?

---

## Step 2 — Competitive Landscape (if web search available)

For each competitor:
- Identify their top-traffic content (use web search: `site:<competitor> [topic]`)
- Find keyword gaps — topics they rank for that this brand doesn't cover
- Find angle gaps — topics covered but with weak depth, outdated data, or no original research

---

## Step 3 — Content Gap Analysis (if SEO audit exists)

Read `Projects/<domain>/final/health-score.json` and `fix-plan.md`.
Map low-scoring content areas to content opportunities:
- Low GEO score → create AI-citation-optimized FAQ and definition articles
- Thin content findings → identify which pages need supporting cluster articles
- Missing schema → identify pages needing FAQ and how-to content

---

## Step 4 — Build Topic Clusters (hub-and-spoke)

Design 3–5 topic clusters. Each cluster:

```
Cluster: [Primary keyword theme]
├── Pillar Page (3,000+ words) — comprehensive authority guide
├── Supporting Article 1 (2,000 words) — deep dive on subtopic
├── Supporting Article 2 (2,000 words) — deep dive on subtopic
├── Supporting Article 3 (1,500 words) — use case / case study
├── Comparison Article (1,500 words) — X vs Y
└── FAQ Article (1,500 words) — common questions answered
```

Rules:
- Every article in a cluster links to the pillar page
- The pillar page links back to every supporting article
- No two articles in the same cluster target the same keyword

For semantic SERP-based clustering, read and follow:
`vendor/claude-blog/skills/blog-cluster/SKILL.md`

---

## Step 5 — Content Decay Detection

Check for existing posts that are losing rankings:
- Posts not updated in > 6 months with statistics are decaying
- Posts with statistics from 2023 or earlier need freshness updates
- Mark these as priority "update" tasks in the calendar

---

## Step 6 — Build the Editorial Calendar

Assign articles to weeks using this content mix:
- **60% Informational** — builds topical authority and AI citation surface
- **30% Commercial** — drives conversions (comparisons, reviews, case studies)
- **10% News/Trending** — captures fresh traffic from algorithm updates, news

Calendar format per week:
```
Week N (Date range):
- [Publish NEW] Article title — template type — target keyword — cluster
- [UPDATE] Existing article title — what needs updating
```

Include:
- Seasonal hooks relevant to the niche
- Publishing sequence: pillar first, then supporting articles
- Freshness update schedule: which posts need statistics refreshed and when

---

## Step 7 — Output

Write to `Projects/<domain>/final/`:
- `content-calendar.md` — 90-day week-by-week editorial calendar
- `keyword-opportunity-map.md` — full keyword table:

| Keyword | Monthly Volume (est.) | Difficulty | Intent | Cluster | Template | Priority |
|---------|----------------------|------------|--------|---------|----------|---------|
| ... | ... | ... | Info/Commercial/Nav | ... | ... | High/Med/Low |

Volume and difficulty are estimates from web search unless DataForSEO MCP is active.

---

## After Delivery — Capture a Learning

Append what worked so future strategy sessions benefit:
```powershell
python .platform\scripts\learn.py add --category strategy --pattern "<key finding>" --source <slug>
```
