# Personal Knowledge Base

A two-layer markdown knowledge base maintained by an LLM. All content is plain markdown and can be opened with any editor. Tools like Obsidian, Logseq, or VS Code + Foam can provide a nicer browsing experience via `[[wiki-link]]` support, but they are **optional** — the project does not depend on them.

**Session start**: at the beginning of every new conversation, read `wiki/_log.md` first to catch up on recent operations and maintain continuity. Skip this if the directory doesn't exist yet.

## Architecture

```
.
├── raw/                          # Immutable original articles (LLM read-only; humans only write on ingest)
│   ├── YYYY-MM-DD-title.md
│   └── assets/                   # Attachments (images, PDFs), bucketed per article
│       └── <article-slug>/       # Same stem as the raw .md (may be abbreviated if long)
│           └── NN-description.{png,jpg,pdf,...}
├── wiki/                         # LLM-owned derived layer (humans read-only)
│   ├── summaries/                # One summary per article (1:1 with raw)
│   ├── entities/                 # People, orgs, products, technologies (accumulated across articles)
│   ├── concepts/                 # Methodologies, architectures, theories (accumulated across articles)
│   ├── comparisons/              # A vs B analyses (generated conditionally)
│   ├── overviews/                # Topic surveys (generated when ≥3 related articles exist)
│   ├── synthesis/                # Archived Q&A answers (markdown only)
│   ├── _index.md                 # Auto-maintained master index (content-oriented)
│   └── _log.md                   # Auto-maintained operation log (timeline, append-only)
└── CLAUDE.md                     # This file
```

**Why two layers**: `raw/` is the immutable factual substrate — "knowledge". `wiki/` is the LLM's current understanding of that knowledge — "understanding of knowledge". Separating them means understanding can always be regenerated from facts.

**Two special files**:
- `_index.md`: content-oriented table of contents. On a query, **read the index first** to locate relevant pages instead of scanning the whole tree blindly.
- `_log.md`: timeline-oriented operation record, append-only. Records every ingest, query-archive, and lint. New sessions read the log to catch up.

## Principles

1. **raw is immutable**: raw files and their `assets/` attachments are never modified or deleted once written — no exceptions
2. **wiki is regenerable**: summaries → entities → concepts → comparisons → overviews can all be regenerated from raw (except synthesis, which is triggered by queries and not derived from raw)
3. **Search before creating**: before creating an entity/concept page, search existing files and aliases to avoid duplicates
4. **Never lose information**: when incrementally updating an entity/concept, preserve all existing content
5. **Link format**: always use `[[folder/name]]` format (e.g. `[[entities/Kubernetes]]`) with the folder prefix
6. **Language**: wiki content defaults to English; keep proper nouns and technical terms as-is

## Conventions

### File naming

- raw files: `YYYY-MM-DD-<title>.md`, special chars replaced with `-`, consecutive `-` collapsed, title truncated to 80 chars
- raw attachments: `raw/assets/<slug>/NN-<description>.<ext>`
  - `<slug>` matches the raw .md stem; if the name is too long it may be abbreviated, but the `YYYY-MM-DD-` prefix must be kept and must remain stable within the article
  - `NN` is a two-digit zero-padded sequence (`01`, `02`, …) following the order of appearance in the original article
  - Reference attachments with relative paths in raw .md: `![alt](assets/<slug>/NN-xxx.jpg)`. **Do not** use absolute paths or `../`
  - Only raw files reference attachments. If a wiki page needs to show an image, use a relative path like `../raw/assets/<slug>/...` — don't copy the file
- wiki pages: named after the subject (e.g. `Kubernetes.md`, `Harness Engineering.md`)
- comparisons: `A vs B.md`
- synthesis: named after the answer topic, not the original question

### Frontmatter

Every wiki page has frontmatter with `type`, `created`, `updated`, `tags`, etc. Minimal template:

```yaml
---
type: summary | entity | concept | comparison | overview | synthesis
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
source: [[raw/YYYY-MM-DD-title]]   # summary only
aliases: [alias1, alias2]          # entity/concept only
---
```

### Cross-link topology

```
raw/article  ←──  summaries (the only pages that directly reference raw)
                     │
                     ▼
             entities  ↔  concepts
                 │            │
                 ▼            ▼
             comparisons  comparisons
                     \      /
                      ▼    ▼
                   overviews

synthesis ──→ all pages (outgoing only, leaf node)
```

## Workflows

### Ingest (user provides a URL or file)

When the user says "ingest", "save", "capture", or pastes a URL, run the three-stage flow:

**Stage 1: fetch and save raw**
1. Use available tools (WebFetch / curl / browser MCP / etc.) to fetch the URL, preserving body text, author, publish date, and images
2. Download all images/attachments to `raw/assets/<slug>/NN-description.<ext>`
3. Save the body as `raw/YYYY-MM-DD-<title>.md`, referencing attachments via relative paths
4. Before ingesting, check whether the URL already appears in `wiki/_log.md` or in the frontmatter of any existing raw file. If already ingested, skip.

**Stage 2: compile wiki**
1. **Summary**: create a 1:1 summary in `wiki/summaries/`, linking back to `[[raw/...]]`
2. **Entity extraction**: identify people, orgs, products, technologies
   - If a page exists, update it incrementally (preserve existing content, append new source)
   - If not, create `wiki/entities/<Name>.md`
3. **Concept extraction**: identify methodologies, architectures, theories
   - Update if exists, otherwise create `wiki/concepts/<Concept>.md`
4. **Comparison evaluation**: if the article explicitly compares two existing entities/concepts, generate `wiki/comparisons/A vs B.md`
5. **Overview evaluation**: if a topic already has ≥3 related summaries, generate or update `wiki/overviews/<Topic>.md`

**Stage 3: index and log**
1. Update `wiki/_index.md` (group new/updated pages by type with a one-line description)
2. Append to `wiki/_log.md`: timestamp, URL, which pages were generated/updated

### Query (user asks a question)

When the user asks a question (not an ingest operation), proactively search the knowledge base:

1. **Read the index first**: read `wiki/_index.md` and locate pages relevant to the question
2. **Targeted reading**: read the relevant pages identified from the index (summaries, entities, concepts, etc.)
3. **Supplementary search**: if the index isn't sufficient, use Grep to search `wiki/` by keywords
4. **Synthesized answer**: inline `[[folder/name]]` wiki-links in the answer
5. If nothing relevant exists in the knowledge base, say so plainly — don't fabricate
6. Be critical — offer depth of opinion, don't flatter the user

**Archive judgment** — after answering, evaluate whether to archive the answer under `wiki/synthesis/`:

- Synthesized ≥2 wiki pages → suggest archiving
- Produced cross-domain insight or connection → suggest archiving
- User explicitly marked it as valuable → archive
- Simple fact lookup, single-page retrieval → do not archive

Suggestion phrasing: "This answer pulled from multiple sources — archive it to the knowledge base?" After user confirmation, save as a markdown page, update `_index.md`, and append to `_log.md`.

### Lint (periodic health check)

When the user says "lint wiki", "check the knowledge base", or "health check", run:

**Step 1: structural scan** (mechanical, can be automated)
1. **Broken links**: grep all `[[...]]` links and check the target files exist
2. **Orphan pages**: grep each wiki page's filename to confirm at least one other page references it (summaries excepted — they are referenced via the index)
3. **Missing cross-references**: check the "related entities" / "related concepts" sections on entity/concept pages — are there other entities/concepts co-occurring in the same source article that got omitted?

**Step 2: content review** (requires reading pages)
4. **Contradiction detection**: read descriptions of the same entity/concept across different sources and flag contradictions
5. **Stale information**: compare older summaries against newer ones — do newer sources invalidate older claims?
6. **Missing concept/entity pages**: scan all summary pages for topics mentioned in multiple articles that lack their own page

**Step 3: development suggestions** (heuristic)
7. **Gaps**: based on the current knowledge graph, suggest gaps that could be filled via web search
8. **New questions**: based on existing content, suggest questions worth exploring

**Output**: a list of issues plus suggested fixes; wait for user confirmation before acting. Append a lint record to `_log.md`.

### Maintenance

- **Recompile**: when the user says "recompile wiki", regenerate all wiki pages from raw (keep synthesis untouched)
- **Update index**: when the user says "update index", regenerate `wiki/_index.md`
- **Deduplicate**: before ingesting, check whether the URL has already been captured
