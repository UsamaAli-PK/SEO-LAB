# Project Folder Template

This is the canonical structure every client project follows. Real client
folders are created under `Projects/<domain-slug>/` at the repo root and are
**gitignored** — client data never goes to GitHub. This template documents the
shape so any agent (or human) knows what to create.

Copy this layout to `Projects/<domain-slug>/` when starting a new client.
`<domain-slug>` = hostname, dots→hyphens, no `www`, lowercase
(e.g. `https://www.Example.com/` → `example-com`).

```
Projects/<domain-slug>/
├── cache/                      single homepage snapshot, fetched once per audit
│   ├── homepage.html
│   ├── homepage.md
│   └── homepage.meta.json
├── raw/                        one .md per analysis area (YAML frontmatter required)
│   ├── technical.md            (agent / score / status / summary frontmatter)
│   ├── content.md
│   ├── schema.md
│   ├── sitemap.md
│   ├── geo.md
│   ├── performance.md
│   ├── visual.md
│   └── sxo.md
├── final/                      client-facing deliverables
│   ├── audit-meta.json
│   ├── health-score.json
│   ├── fix-plan.md
│   ├── report.md
│   ├── client-audit-report.md
│   ├── client-audit-report.html
│   ├── content-calendar.md
│   ├── keyword-opportunity-map.md
│   ├── archive/<YYYY-MM-DD>/    prior audits, before promotion to final/
│   ├── blog/<slug>/            one folder per article (md, html, pdf, hero, review, preflight)
│   └── pages/<slug>.md
├── brand/
│   ├── BRAND.md                audience, positioning, editorial rules, taboo terms
│   └── VOICE.md                tone, pronoun stance, sentence rules
└── memory.md                   append-only per-client findings log (see contracts.md §5)
```

Cross-client learnings (not per-client) live in `Projects/_learnings/learnings.jsonl`.

See `.platform/contracts.md` for the exact frontmatter contracts each file must carry.
