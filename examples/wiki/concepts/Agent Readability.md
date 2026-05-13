---
type: concept
created: 2026-04-24
updated: 2026-05-12
tags: [methodology, observability, agent-first]
aliases: [Agent Readability, agent legibility, legibility]
---

# Agent Readability

The property of having **runtime application state** — UI, logs, metrics, traces — be directly readable and reasoned-over by a coding agent. A pillar of [[concepts/Harness Engineering]].

## Thesis

> As code throughput rises, the bottleneck becomes human QA capacity. Since human time and attention are the fixed constraint, the app's UI, logs, and metrics must be exposed in a form the agent can consume directly — so the agent can validate its own work.

Complement to [[concepts/Codebase as System of Record]] — that one is about making **static knowledge** legible; this one is about making **runtime state** legible.

## Practice (from [[summaries/2026-02-11-harness-engineering-en]])

### UI legibility: Chrome DevTools MCP

- The app boots **per git worktree** → each Codex run gets its own instance
- Chrome DevTools Protocol wired into the agent runtime
- Skill bindings for DOM snapshots, screenshots, navigation
- Result: Codex can reproduce bugs, validate fixes, and reason about UI behavior directly — without a human opening a browser

### Observability legibility: ephemeral local stack

- Logs, metrics, traces routed through a local observability stack
- **One stack per worktree, torn down when the task ends**
- Agent interface: LogQL for logs, PromQL for metrics

This enables a qualitatively new prompt shape — moving from "describe the goal" to "verify the invariant":

- "Ensure service startup completes in under 800ms."
- "No span in these four critical user journeys exceeds two seconds."

### Long-running tasks become normal

- Single Codex runs working on a single task for **>6 hours** are common
- Often these happen overnight while humans sleep
- Only viable because the agent can self-verify progress

## Underlying principle

Any verification signal **not in the agent's context** is equivalent to non-existent:

- A UI bug that only manifests when a human opens a browser → invisible to the agent
- A performance regression visible only on a monitoring dashboard → invisible
- An architecture decision buried in Slack → invisible

So: **push every verification signal into a channel the agent can read programmatically.**

## Design tradeoffs

- Prefer **boring tech** (Chrome DevTools, Prometheus, Victoria Metrics — stable, well-known, common in training data)
- Prefer tools with **stable APIs** that the model has seen many times
- Sometimes it's cheaper to **reimplement a small subset** than to wrap an opaque public library (the post's example: a custom map-with-concurrency helper instead of pulling in `p-limit`, so the agent can fully reason about it)

## Related concepts

- [[concepts/Harness Engineering]]
- [[concepts/Codebase as System of Record]]

## Related entities

- [[entities/Codex]]

## Sources

- [[summaries/2026-02-11-harness-engineering-en]]
