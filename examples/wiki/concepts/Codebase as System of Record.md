---
type: concept
created: 2026-04-24
updated: 2026-05-12
tags: [methodology, knowledge-management, agent-first]
aliases: [Codebase as System of Record, repo as system of record]
---

# Codebase as System of Record

Treating the code repository as the **single authoritative source** of organizational knowledge — design decisions, architectural discussions, team agreements — rather than letting that knowledge live scattered across Google Docs, Slack, and people's heads. A core pillar of [[concepts/Harness Engineering]].

## Why (from the agent's point of view)

> Anything the agent cannot access in-context while running effectively doesn't exist.

- An architectural convention agreed in Slack → invisible to the agent
- API style decided in a design review meeting → invisible
- Product spec parked in Google Docs → invisible

The agent can only see versioned artifacts in the repository that fit into its working context. External knowledge is to the agent what early decisions are to a hire who joins three months later: gone.

## Practice (from [[summaries/2026-02-11-harness-engineering-en]])

### `AGENTS.md` is the table of contents, not the encyclopedia

Failure modes of the "one giant `AGENTS.md`" approach:

- Context is scarce — instructions crowd out task and code
- Too much guidance = no guidance (when everything is "important", nothing is)
- Rots instantly; impossible to verify mechanically
- A single blob cannot be checked for coverage, freshness, ownership, or cross-link integrity

Correct shape: an `AGENTS.md` of ~100 lines acting as an entry **map**, pointing into a structured `docs/` tree.

### Typical `docs/` layout

```
AGENTS.md
ARCHITECTURE.md
docs/
├── design-docs/          # Design documents + a core-beliefs file
├── exec-plans/           # Execution plans (active / completed) + tech-debt tracker
├── generated/            # Auto-generated artifacts (e.g., db-schema.md)
├── product-specs/        # Product specifications
├── references/           # LLM-friendly references for external dependencies
├── DESIGN.md / FRONTEND.md / PLANS.md / PRODUCT_SENSE.md
├── QUALITY_SCORE.md / RELIABILITY.md / SECURITY.md
```

### Execution plans are first-class artifacts

- Small changes: lightweight ephemeral plans
- Complex work: structured execution plans with progress and decision logs
- All committed into the repo → the agent can resume work without external context

### Progressive disclosure

The agent starts at a small, stable entry point and follows pointers to deeper documentation only when relevant — instead of being drowned in a 1,000-page manual up front.

## Maintenance

- **Linters + CI** validate freshness, cross-link integrity, and structural correctness
- A recurring **"doc-gardening" agent** scans for stale or obsolete documentation that no longer reflects code behavior, and opens fix-up PRs

## Echoes elsewhere

This idea aligns closely with the design of static knowledge bases — including this very repository:

- raw layer = immutable facts (code itself + original design docs)
- wiki layer = an LLM-recompilable *understanding* of those facts (summaries, concepts, cross-links)
- Operating entry point = a small, stable rules file (`AGENTS.md` / `CLAUDE.md`)

## Related concepts

- [[concepts/Harness Engineering]]
- [[concepts/Agent Readability]]

## Related entities

- [[entities/Codex]] — the agent whose system of record this is
- [[entities/OpenAI]] — the organization applying this pattern internally
- [[entities/Ryan Lopopolo]] — author of the source that articulates this pattern

## Sources

- [[summaries/2026-02-11-harness-engineering-en]]
