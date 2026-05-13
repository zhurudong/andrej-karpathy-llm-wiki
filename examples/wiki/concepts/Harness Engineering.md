---
type: concept
created: 2026-04-24
updated: 2026-05-12
tags: [methodology, agent-first, engineering]
aliases: [Harness Engineering, harness-engineering]
---

# Harness Engineering

An engineering methodology: when code is produced almost entirely by a coding agent like [[entities/Codex]], the engineer's job is no longer to write code but to **design the environment the agent operates inside** — the "harness".

Term coined by [[entities/Ryan Lopopolo]] in [[summaries/2026-02-11-harness-engineering-en]].

## Core thesis

> Discipline doesn't disappear. It migrates from the code into the **scaffolding** — the tools, abstractions, and feedback loops that keep the codebase coherent.

Engineers stop producing code directly and start producing the *systems that let agents produce code*.

## The four pillars

### 1. Repository legibility for the agent (see [[concepts/Agent Readability]])

- The app boots per git worktree → Codex drives one isolated instance per change
- Chrome DevTools Protocol wired into the agent → the agent can reproduce UI bugs and validate fixes directly
- Ephemeral local observability stack → LogQL for logs, PromQL for metrics
- Operating principle: **"What the agent cannot see in-context effectively doesn't exist."**

### 2. Repository as the system of record (see [[concepts/Codebase as System of Record]])

- `AGENTS.md` is demoted to a ~100-line **map**
- A structured `docs/` tree carries design docs, execution plans, tech-debt trackers, product specs
- **Progressive disclosure**: agents start at a small stable entry point and follow breadcrumbs to deeper truth
- Linters and a "doc-gardening" agent fight rot mechanically

### 3. Strong architectural invariants

- Each business domain is strictly layered: `Types → Config → Repo → Service → Runtime → UI`
- Cross-cutting concerns (auth, telemetry, feature flags) enter only through an explicit `Providers` interface
- Constraints enforced by **custom linters and structural tests** (which the agent itself wrote)
- "Rules that feel pedantic in a human workflow become **multipliers** in an agent workflow — once encoded, they apply everywhere at once."

### 4. Entropy as garbage collection

- Drift is inevitable; the answer is **continuous small repayment**, not periodic big-bang refactors
- Background Codex tasks scan for deviations and open small refactor PRs (most reviewed in <1 minute and auto-merged)
- Analogy: tech debt is a high-interest loan — pay it down daily, not in painful bursts

## Key principle

**When documentation falls short, promote the rule into code.**

Lint error messages are written to inject remediation instructions directly into the agent's next-attempt context.

## Throughput inverts the merge philosophy

In a system where agent throughput far exceeds human attention:

- **Corrections are cheap; waiting is expensive.**
- PRs are short-lived
- Test flakes are addressed by re-running rather than blocking
- Minimal blocking merge gates

This would be irresponsible in a low-throughput environment. Here it's often the right call.

## Transferability

Even setting aside the radical "0% manually-written code" framing, three insights generalize:

- Treat the repo as the agent's **system of record** ✓
- Encode **taste as lint rules**, not as documentation pleas ✓
- Make `AGENTS.md` a **map**, not an encyclopedia ✓

These apply to any team using Claude Code, Cursor, Codex, Aider, or similar coding agents — regardless of how much code is human-written.

## Counter-views worth holding

- Sample is a single OpenAI internal team using their own latest models on bespoke infra. External reproducibility is unproven.
- "0 lines of manually-written code" is partly framing; humans are continuously writing prompts, linters, docs, and reviews — the *upstream* of code.
- 1M LOC and 3.5 PRs/day are not benchmarked for quality or per-LOC user value.

## Related concepts

- [[concepts/Codebase as System of Record]]
- [[concepts/Agent Readability]]

## Related entities

- [[entities/Codex]]
- [[entities/OpenAI]]
- [[entities/Ryan Lopopolo]]

## Sources

- [[summaries/2026-02-11-harness-engineering-en]]
