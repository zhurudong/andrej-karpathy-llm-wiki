---
type: log
created: 2026-04-24
---

# Operation Log

> Append-only. Records every ingest, query-archive, and lint operation so new sessions can re-establish context.

---

## 2026-04-24 17:49 · Initialization

- Repository initialized from blank template
- Landed: `README.md` (English), `README.zh-CN.md` (Chinese), `templates/CLAUDE.md` (Chinese rules), `templates/CLAUDE.en.md` (English rules)
- Root `CLAUDE.md` → symlink to `templates/CLAUDE.md`
## 2026-05-12 20:14 · Ingest · OpenAI Harness Engineering (English original, first attempt — later superseded)

- **Source**: https://openai.com/index/harness-engineering
- **Dedup judgment**: same article had been ingested in Chinese translation on 2026-04-24. Decided to keep the English original as a separate raw for original terminology and exact quotations; both raw files coexist.
- **Fetch path**: WebFetch and curl both 403; succeeded via `web-fetcher` skill's `fetch.py` (Playwright + anti-detection).
- **raw**: `raw/2026-02-11-harness-engineering-en.md` (with 4 diagrams in `raw/assets/2026-02-11-harness-engineering-en/`, byte-identical to the Chinese version's images, renamed to short descriptive slugs)
- **Generated/updated**:
  - `summaries/2026-02-11-harness-engineering-en.md` (new, English)
  - `entities/OpenAI.md`, `entities/Codex.md`, `entities/Ryan Lopopolo.md` (English source appended; quotations added)
  - `concepts/Harness Engineering.md`, `concepts/Codebase as System of Record.md`, `concepts/Agent Readability.md` (English source appended; original terms noted)
- **Not generated**: comparison (n/a), overview (still <3 related), synthesis (not query-triggered)
- **Index**: `_index.md` updated