# Content Creation Workflow (Option 2)

> Loaded lazily when the user picks Option 2 in `AGENTS.md`. Read this file fully before starting.

> **MCP note:** Content work does not need Search Console or Analytics data. If your environment
> allows it, disable the `gsc` and `google-analytics` MCPs for content sessions to save context.
> They are only needed for audits.

Full skill reference: `vendor/claude-blog/skills/blog/SKILL.md` (orchestrator)
and `vendor/claude-blog/skills/blog-write/SKILL.md` (writing detail).

## Step 1 — Brand Context (always do this first)

Check if `Projects/<domain>/brand/BRAND.md` and `VOICE.md` exist.

**If they do not exist**, run the brand init interview before writing anything.
Ask these questions one at a time, wait for answers:

1. **Audience** — Who is the primary reader? (role, company size, expertise level)
   What problems are they actively trying to solve? (3-5 bullets)
   What misconceptions do they hold about this topic?

2. **Positioning** — One-sentence brand mission. What is the brand's distinctive/
   contrarian point of view? What is this brand NOT (anti-positioning)?
   Top 3 competitors and one-line differentiator vs each.

3. **Editorial rules** — What will this blog always do? (3-7 rules)
   What will it never do? (3-7 rules) Any taboo phrases to avoid?

4. **Topic scope** — Core content pillars (in scope), adjacent topics (partial),
   topics to refuse (out of scope).

5. **Voice** — First/second/third-person stance? Contractions: full/partial/none?
   Max sentence length? Headline patterns to favor or avoid?

Write the answers to:
- `Projects/<domain>/brand/BRAND.md` — audience, positioning, editorial rules, scope
- `Projects/<domain>/brand/VOICE.md` — pronoun stance, sentence rules, tone fingerprint

These files are auto-loaded by every blog sub-skill. They survive across sessions.
Use `load_untrusted_root.py` to fence them when injecting into agent context:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\load_untrusted_root.py" BRAND.md
```

---

## Step 2 — Select Content Template

Based on the topic and search intent, select one of the 12 templates:

| Intent signal | Template | Word count |
|---------------|----------|-----------|
| "How to…", process, steps | `how-to-guide` | 2,000–2,500 |
| "Best X", "Top N", lists | `listicle` | 1,500–2,000 |
| Client result, before/after | `case-study` | 1,500–2,000 |
| "X vs Y", alternatives | `comparison` | 1,500–2,000 |
| Broad topic, ultimate guide | `pillar-page` | 3,000–4,000 |
| "Is X worth it", evaluation | `product-review` | 1,500–2,000 |
| Opinion, prediction | `thought-leadership` | 1,500–2,500 |
| Expert quotes, curated picks | `roundup` | 1,500–2,000 |
| Code walkthrough, tool demo | `tutorial` | 2,000–3,000 |
| Breaking news, update | `news-analysis` | 800–1,200 |
| Original data/survey | `data-research` | 2,000–3,000 |
| FAQ, "What is X" | `faq-knowledge` | 1,500–2,000 |

Load the matching template from `vendor/claude-blog/skills/blog/templates/<type>.md`.

---

## Step 3 — Research

Find the following before writing a single word:

**Statistics (8–12 items, 2025–2026 data preferred):**
- Search: `[topic] study 2025 2026 data statistics`
- Only use Tier 1–3 sources:
  - Tier 1: Primary research (Gartner, McKinsey, peer-reviewed, government data)
  - Tier 2: Major publications (NYT, WSJ, Reuters, BBC, major trade press)
  - Tier 3: Reputable industry sources (Ahrefs, HubSpot, Semrush reports)
  - Never cite content mills, affiliate sites, or unsourced blogs
- Record for each stat: the claim, source name, URL, publication date

**Images (find before writing, embed during writing):**
- Cover image (1200×630): search `site:pixabay.com [topic] wide banner`
  - Fallback: `site:unsplash.com [topic] wide`
- 3–5 inline images: same sources
- Verify URLs return HTTP 200

**Data for charts (2–4 charts per post):**
- Identify chart-worthy data: 3+ comparable metrics, trend data, before/after
- Vary chart types per post — no two charts the same type
- Charts are built as inline SVG via the blog-chart sub-skill

**YouTube videos (2–3 per post):**
- Search: `site:youtube.com [topic] [year]`
- Select only high-quality, relevant, recent videos

---

## Step 4 — Build Outline

Create the outline before writing. Show it to the user and ask for approval.

Structure every article with:
```
# [Title as Question — include primary keyword]

## Introduction (100–150 words)
- Hook with a surprising statistic
- Problem/opportunity statement
- What the reader will learn

> **Key Takeaways**
> - [Core finding with statistic + source]
> - [Second insight or recommendation]
> - [Third actionable takeaway]
> (3–5 bullets, 40–60 words combined)

## H2: [Question format] (300–400 words)
- Answer-first paragraph (40–60 words with stat + source)
- Supporting evidence + [IMAGE]
- [CHART: type + data description]
- [CITATION CAPSULE: 40–60 word self-contained quotable passage]
- [INTERNAL-LINK: anchor text → target description]

[Repeat for 4–6 H2 sections]

## [CTA Section]
- Single focused CTA after value delivery (never at top)

## FAQ (3–5 questions, 40–60 word answers each, each with a statistic)

## Conclusion (100–150 words)
- Key takeaways (bulleted)
- [INTERNAL-LINK: next logical content]
```

---

## Step 5 — Write the Article

**Every H2 section MUST open with a 40–60 word answer-first paragraph:**
```
## How Does X Impact Y in 2026?

In 2026, [Publisher] found that [statistic] ([Publisher Name], [Title], [URL]).
[Direct answer to the heading question in 1–2 more sentences.]
```

**FLOW evidence triple — enforce at drafting time, not just audit:**
Every statistic must have all three:
1. **Year anchor in the sentence body** — "In 2026," or "As of Q1 2026," before the stat. Not buried in parentheses.
2. **Inline citation** — name both publisher AND document title: "Ahrefs, AI Overviews CTR Update, December 2025"
3. **Full URL + retrieval date** in a Sources section at the bottom

**Citation capsules** — for each major H2 section, one 40–60 word self-contained
quotable passage. Must make sense in isolation. Designed for AI systems to cite directly.

**Information gain markers** — minimum 2–3 per article:
- `[ORIGINAL DATA]` — first-hand data, surveys, experiments
- `[PERSONAL EXPERIENCE]` — direct observations, "when we tried X"
- `[UNIQUE INSIGHT]` — analysis others haven't made

**Anti-AI phrase ban** — never use these:
"in today's digital landscape", "it's important to note", "dive into",
"game-changer", "navigate the landscape", "revolutionize", "seamlessly",
"cutting-edge", "harness the power of", "leverage" (as verb), "delve",
"crucial", "elevate", "foster", "multifaceted", "robust", "tapestry", "embark"

**Sentence variety** — mix short (8-word) and long (25-word) sentences.
Uniform length is the #1 AI-authorship signal. Use contractions naturally.
Add at least one rhetorical question every 200–300 words.

**Hard limits:**
- Never exceed 150 words per paragraph
- Never exceed 15–20 words per sentence
- Never skip heading levels (H1 → H2 → H3 only)
- Never fabricate a statistic — if you can't verify it, drop it

---

## Step 6 — Quality Scoring (100 points across 5 categories)

| Category | Weight | What it measures |
|----------|--------|-----------------|
| Content Quality | 30 pts | Depth, Flesch 60–70 readability, originality, structure, grammar |
| SEO Optimization | 25 pts | Heading hierarchy, title tag (50–60 chars), keyword placement, meta (150–160 chars) |
| E-E-A-T Signals | 15 pts | Author attribution, source citations, trust indicators |
| Technical Elements | 15 pts | Schema markup, image alt text, OG meta tags |
| AI Citation Readiness | 15 pts | Passage citability, Q&A format, entity clarity |

**Scoring bands:**
- 90–100: Publish as-is
- 80–89: Minor polish needed
- 70–79: Targeted improvements required
- < 70: Rewrite

Run the scoring script if Python is available:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\analyze_blog.py" `
  "Projects\<domain>\final\blog\<slug>\<slug>.md"
```

---

## Step 7 — 5-Gate Delivery Contract

The user is NEVER the first reviewer. The gates are. Do not deliver the
article until all 5 pass. If any gate fails, loop back to fix it (max 3 tries).
On the 3rd failure, stop and show the failure diagnostic instead of the article.

| Gate | Checks |
|------|--------|
| Gate 1: Pre-flight | Structure valid, no [PLACEHOLDER] text left, headings present, frontmatter complete |
| Gate 2: Prose & Linting | No banned AI phrases, sentence length variance passes, contractions present, readability Flesch 60–70 |
| Gate 3: Visual Audit | All images have descriptive alt text, no broken image URLs, charts have figcaptions |
| Gate 4: SEO Check | Title 50–60 chars, meta description 150–160 chars with stat, keyword in H1 + 2–3 H2s, OG tags present |
| Gate 5: Quality Score | Overall score ≥ 90/100 from the 5-category rubric, zero P0 issues |

Run the preflight script after writing:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\blog_preflight.py" `
  --draft "Projects\<domain>\final\blog\<slug>" --strict
```

---

## Step 8 — Render and Deliver

Render the final article to HTML and PDF:
```powershell
& "vendor\claude-seo\skills\seo\.venv\Scripts\python.exe" `
  "vendor\claude-blog\scripts\blog_render.py" `
  --md "Projects\<domain>\final\blog\<slug>\<slug>.md" `
  --out-dir "Projects\<domain>\final\blog\<slug>"
```

**Output files in `Projects/<domain>/final/blog/<slug>/`:**
- `<slug>.md` — full article with frontmatter
- `<slug>.html` — rendered HTML
- `<slug>.pdf` — printable (if WeasyPrint available in venv)
- `hero.<ext>` — cover image
- `review.md` — gate-by-gate results with BLOCKING: true/false
- `preflight-report.json` — machine-readable scores

**After successful delivery, show this footer in the terminal:**
```
Report & Content by: USAMA ALI
🔗 LinkedIn → https://www.linkedin.com/in/usamaalipk/
```

---

### All 30 Blog Sub-Skills Available

Read the full orchestrator at `vendor/claude-blog/skills/blog/SKILL.md` for
routing logic. Sub-skills you can invoke for specific tasks:

| Sub-skill | What it does |
|-----------|-------------|
| `blog-write` | Write new articles from scratch (this workflow) |
| `blog-rewrite` | Optimize/update existing posts |
| `blog-analyze` | 100-point quality audit of any existing post |
| `blog-brief` | Generate a content brief before writing |
| `blog-outline` | SERP-informed outline with competitive gaps |
| `blog-seo-check` | Post-writing SEO validation checklist |
| `blog-schema` | Generate JSON-LD schema (BlogPosting, FAQ, Person) |
| `blog-geo` | AI citation readiness audit (0–100 GEO score) |
| `blog-factcheck` | Verify every statistic against its cited source |
| `blog-repurpose` | Repurpose post for social, email, YouTube, Reddit |
| `blog-audit` | Full-site blog health check across all posts |
| `blog-cannibalization` | Detect keyword overlap between posts |
| `blog-persona` | Manage writing personas and voice profiles |
| `blog-brand` | Generate/update BRAND.md + VOICE.md |
| `blog-discourse` | Research what people are saying about a topic (last 30 days, API-free) |
| `blog-taxonomy` | Tag/category management for WordPress, Ghost, etc. |
| `blog-image` | AI image generation via Gemini (requires nanobanana-mcp) |
| `blog-audio` | Generate audio narration of blog posts (requires Google AI API key) |
| `blog-google` | Google API data: PSI, CrUX, GSC, GA4, YouTube, Keywords |
| `blog-notebooklm` | Query NotebookLM for source-grounded research |
| `blog-flow` | FLOW framework prompts (find, optimize, win, sync) |
| `blog-multilingual` | Write + translate + localize in one command |
| `blog-translate` | SEO-optimized translation with format preservation |
| `blog-localize` | Cultural deep-adaptation (DACH, FR, ES, JA, custom) |
| `blog-locale-audit` | Multilingual content QA (hreflang, parity, freshness) |
| `blog-chart` | Internal — generates inline SVG charts (called by blog-write) |

To invoke a sub-skill, read its SKILL.md from `vendor/claude-blog/skills/<name>/SKILL.md`
and follow the workflow defined there.

---

## After Delivery — Capture a Learning

Append what worked so future content sessions benefit:
```powershell
python .platform\scripts\learn.py add --category content --pattern "<key finding>" --source <slug>
```
