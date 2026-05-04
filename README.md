# LLM-Maintained Knowledge Base

**English** | [简体中文](./README.zh-CN.md)

> Inspired by Andrej Karpathy's gist: <https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>.

A local knowledge base template maintained by an LLM. No backend, no vector database, no RAG framework — just a single `CLAUDE.md` file that tells any LLM CLI (Claude Code / Codex / OpenCode / …) how to fetch, organize, index, and query your notes.

Everything is plain markdown. Open it with any editor.

## Why

Most "personal knowledge base" solutions take one of two paths:

- **Note-taking apps** (Notion / Obsidian / Logseq) — great for storage and browsing, but tagging, linking, and organizing is all manual.
- **RAG / vector search** — great for Q&A over large corpora, but needs embedding services, a vector store, and an ingestion pipeline. Heavy, fragile, opaque.

This project takes a third path: **let the LLM do the organizing, use markdown files as the substrate, use wiki-links as the graph, and use an LLM CLI as the runtime.**

- Raw articles are immutable; LLM-generated summaries / entities / concepts can be recompiled anytime
- Everything is plain markdown — works with any editor, Git, grep
- The knowledge graph emerges naturally from `[[wiki-link]]` — no graph DB
- Switching LLM tools requires zero data migration — the rules live in `CLAUDE.md`

Typical use cases:

- **Reading papers** — drop an arXiv link; the LLM generates a summary and links it to existing concepts
- **Following a field** — ingest industry blogs regularly; `overviews/` organically form topic surveys
- **Archiving your own thinking** — ask questions, let the LLM store synthesized answers in `synthesis/`, building your own opinion library
- **Team collaboration** — push to Git; teammates maintain the same knowledge base with their own LLM CLIs

## Quick Start

Three commands get you running: create a directory, drop in `CLAUDE.md`, then talk to your LLM CLI in natural language. The CLI reads the rules file, fetches articles, generates `raw/` + `wiki/`, and answers questions — no extra setup.

### 1. Set up a directory

```bash
mkdir my-knowledge-base && cd my-knowledge-base
```

### 2. Copy the rules file

Copy [`templates/CLAUDE.en.md`](https://github.com/zhurudong/andrej-karpathy-llm-wiki/blob/main/templates/CLAUDE.en.md) from this repo into your knowledge base root as `CLAUDE.md`:

```bash
curl -L -o CLAUDE.md https://github.com/zhurudong/andrej-karpathy-llm-wiki/raw/main/templates/CLAUDE.en.md
```

That single file is the entire "program" — it tells the LLM how to organize this knowledge base.

Supported LLM CLIs (pick one):

| CLI | Convention file |
|---|---|
| [Claude Code](https://docs.claude.com/claude-code) | `CLAUDE.md` |
| [Codex CLI](https://github.com/openai/codex) | `AGENTS.md` (symlink to CLAUDE.md) |
| [OpenCode](https://opencode.ai) | `AGENTS.md` |
| Other agent CLIs that read a project rules file | see their docs |

One command makes it compatible with all of them:

```bash
ln -s CLAUDE.md AGENTS.md
```

### 3. Start ingesting

Inside your LLM CLI, just use natural language:

```
ingest https://www.anthropic.com/engineering/harness-design-long-running-apps
```

or:

```
save this article https://www.anthropic.com/engineering/harness-design-long-running-apps
```

The LLM will automatically: fetch the page → save it as `raw/YYYY-MM-DD-title.md` → generate a summary → extract/update entity and concept pages → evaluate whether to generate a comparison or overview → update the index → append to the log.

### 4. Ask questions

Just ask:

```
what does Karpathy think about agentic coding?
what's the core difference between RLHF and DPO?
what has this knowledge base captured about tokenizers?
```

The LLM reads `wiki/_index.md` first to locate relevant pages, then synthesizes an answer. If the answer crosses multiple sources, it will offer to archive it under `wiki/synthesis/`.

### 5. Health check

```
lint wiki
```

The LLM scans for broken links, orphan pages, contradictions, stale claims, and missing cross-references, and proposes fixes.

## Directory layout

Every knowledge base instance follows the same convention:

```
my-knowledge-base/
├── CLAUDE.md                # Rules file (the LLM reads this to run)
├── raw/                     # Immutable original articles
│   ├── YYYY-MM-DD-title.md
│   └── assets/              # Article attachments
└── wiki/                    # LLM-derived understanding layer
    ├── summaries/           # One summary per article
    ├── entities/            # People, orgs, products, technologies
    ├── concepts/            # Methodologies, architectures, theories
    ├── comparisons/         # A vs B analyses
    ├── overviews/           # Topic surveys
    ├── synthesis/           # Archived Q&A answers
    ├── _index.md            # Content index
    └── _log.md              # Operation log
```

The core of the two-layer design: **`raw/` is the immutable factual substrate; `wiki/` is the LLM's current understanding of those facts.** Understanding can be regenerated anytime; facts are preserved forever.

## Browsing (optional)

Everything generated is standard markdown plus `[[wiki-link]]` format. Any editor works; if you want bidirectional links and a graph view, try:

- **[Obsidian](https://obsidian.md)** — open the directory as a Vault; `[[...]]` links and the graph view just work
- **[Logseq](https://logseq.com)** — also supports wiki-links
- **VS Code + [Foam](https://foambubble.github.io/foam/)** — for IDE users
- **Plain CLI** — `grep -r "\[\[" wiki/` handles most queries

These are **optional viewers**. The project doesn't depend on any of them.

## This repo itself

The `examples/` directory is a real sample instance seeded with a few LLM-engineering articles (starting with OpenAI's [Harness Engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)). Clone the repo to see what the generated summaries / entities / concepts actually look like, or just grab `templates/CLAUDE.en.md` and start your own.

## Credits

The `CLAUDE.md` knowledge-base design is inspired by Andrej Karpathy's gist: <https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>. This project builds on that idea with a concrete structure — a two-layer design (immutable `raw/` + regenerable `wiki/`), a cross-link topology, ingest/query/lint workflows, and a cross-CLI template.

## License

MIT
