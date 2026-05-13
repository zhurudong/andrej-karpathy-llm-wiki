---
type: summary
created: 2026-05-12
updated: 2026-05-12
tags: [codex, agent-first, openai, engineering, harness]
source: ../../raw/2026-02-11-harness-engineering-en.md
---

# Summary — OpenAI's "harness engineering": how a 7-engineer team shipped a million-LOC Codex-authored product

An OpenAI engineering blog by Member of Technical Staff [[entities/Ryan Lopopolo]] (published 2026-02-11). His team built and shipped an internal product from an empty git repo in ~5 months, reaching roughly a million LOC with **zero manually-written code**. Every line — application logic, tests, CI, docs, observability, internal tooling — was authored by [[entities/Codex]]. The team grew from 3 to 7 engineers, throughput rose to ~3.5 PRs/engineer/day, totaling ~1,500 merged PRs. They estimate it took ~1/10th the time of writing it by hand.

## Thesis

**Humans steer. Agents execute.** The engineer's job shifts from writing code to **designing environments, specifying intent, and building feedback loops**. Discipline doesn't disappear — it migrates from the code itself into the *scaffolding*: tools, abstractions, architectural invariants, and feedback loops.

## Five core practices

1. **Make the application legible to agents** (see [[concepts/Agent Readability]])
   - The app boots per git worktree, so Codex drives a fresh instance per change
   - Chrome DevTools Protocol is wired into the agent runtime — Codex takes DOM snapshots, navigates, reproduces UI bugs directly
   - Per-worktree ephemeral observability stack; Codex queries logs with LogQL and metrics with PromQL
   - Single Codex runs frequently last **>6 hours** (often overnight)

2. **Repository as system of record** (see [[concepts/Codebase as System of Record]])
   - Rejected the "one giant AGENTS.md" pattern (context is scarce, too much guidance = no guidance, rots fast, hard to verify)
   - `AGENTS.md` is ~100 lines and acts as a **table of contents**, pointing into a structured `docs/` tree
   - Design docs, execution plans, technical-debt trackers — all versioned in-repo
   - Enables **progressive disclosure**: small stable entry point, with breadcrumbs to deeper truth
   - Linters, CI jobs, and a recurring "doc-gardening" Codex agent keep the knowledge base fresh

3. **Optimize everything for agent legibility**
   - "Anything Codex can't access in-context effectively doesn't exist" — Google Docs, Slack threads, tribal knowledge are invisible to the system
   - Prefer **"boring" tech** (composable, API-stable, well-represented in training data)
   - Sometimes reimplement instead of importing (e.g., a custom map-with-concurrency helper rather than a generic p-limit dependency), so the agent can fully reason about it

4. **Enforce architecture and taste mechanically** (see [[concepts/Harness Engineering]])
   - Every business domain follows a strict layered model: `Types → Config → Repo → Service → Runtime → UI`
   - Cross-cutting concerns (auth, telemetry, feature flags) enter only via an explicit `Providers` interface
   - Constraints are enforced by **custom linters and structural tests** (Codex-generated, of course)
   - Lint error messages carry remediation instructions that get injected into the agent's context
   - Slogan: **"When documentation falls short, we promote the rule into code."** Once encoded, rules act as **multipliers** — applied everywhere at once.

5. **Entropy and garbage collection**
   - Initially humans manually cleaned up "AI slop" every Friday (20% of the week) — didn't scale
   - Now: codified **"golden principles"** (e.g., prefer shared utilities over hand-rolled helpers; validate at boundaries, no YOLO data probing) plus background Codex tasks that scan for deviations and open small refactor PRs (most auto-merged within a minute)
   - Treats tech debt like a high-interest loan: continuous small repayments beat painful big-bang refactors

## A different throughput logic

In a system where **corrections are cheap and waiting is expensive**, classic engineering norms invert:

- Pull requests are short-lived; minimal blocking merge gates
- Test flakes are addressed with follow-up runs rather than indefinite blocks
- "Irresponsible in a low-throughput environment; often correct here."

## End-to-end autonomy threshold

Given a single prompt, Codex can now: validate repo state → reproduce a reported bug → record a failure video → implement the fix → validate by driving the app → record a resolution video → open a PR → respond to agent and human feedback → fix build failures → escalate to a human only when judgment is required → merge.

The author flags that this depends heavily on the bespoke harness; it should not be assumed to generalize without similar investment.

## Open questions

- How does architectural coherence evolve over *years* in a fully agent-generated system?
- Where does human judgment add the most leverage, and how do you encode it so it compounds?
- How will this system evolve as models keep getting more capable?

## Critical commentary

Worth re-reading, because it's a rare first-hand data point on agentic coding at production scale. But hold it lightly:

- **Single product, 5 months, 7 engineers.** "1M LOC" and "3.5 PRs/day" sound dazzling, but code quality, architectural uniformity, and user-value density per LOC are not benchmarked publicly.
- **"Zero manually-written code" is partly framing.** Humans are continuously writing prompts, designing linters, curating docs, and reviewing PRs — these are the *upstream* of code. Relabeling that work as "non-code" doesn't make the work smaller; it just moves the bookkeeping.
- **Attribution is hard.** OpenAI internal team, latest in-house models, bespoke infra. Independent reproducibility under non-OpenAI conditions is an open question.
- **But three transferable insights stand on their own**, independent of any "100% AI generated" framing:
  1. Treat the repo as the agent's **system of record**.
  2. Encode **taste as lint rules**, not as documentation pleas.
  3. Make `AGENTS.md` a **map, not an encyclopedia**.

## Related entities and concepts

- Author: [[entities/Ryan Lopopolo]]
- Product: [[entities/Codex]] (built by [[entities/OpenAI]])
- Core methodology: [[concepts/Harness Engineering]]
- Key ideas: [[concepts/Codebase as System of Record]], [[concepts/Agent Readability]]

## Source

- Raw article: [[raw/2026-02-11-harness-engineering-en]]
- Original URL: https://openai.com/index/harness-engineering
