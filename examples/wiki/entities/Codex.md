---
type: entity
created: 2026-04-24
updated: 2026-04-24
tags: [product, coding-agent, openai]
aliases: [Codex, Codex CLI, OpenAI Codex]
---

# Codex

[[entities/OpenAI]] 的编码智能体产品，支持 CLI 和云端两种运行形态。在本知识库收录的来源中，Codex 被作为"完全由智能体生成代码仓库"这一实验的**唯一执行者**。

## 已知事实（来自本知识库）

- **初始架构由 Codex CLI 使用 GPT-5 生成**，基于一小套现有模板
- 连指导智能体如何工作的初始 `AGENTS.md` 文件本身也是 Codex 写的
- 单次运行常**持续 >6 小时**完成一个任务（通常人类睡觉时）
- 直接使用标准开发工具（`gh`、本地脚本、嵌入仓库的技能）而不是把内容复制粘贴到 CLI
- 可以通过 Chrome DevTools 协议对前端进行截图/导航/验证（MCP 接入）
- 可以用 LogQL/PromQL 查询本地可观测性堆栈
- 在配套仓库结构下能**端到端**驱动一个新功能：复现 bug → 录视频 → 修 → 验证 → 录解决方案 → 开 PR → 响应反馈 → 合并

## 性能数据点（单个 OpenAI 内部团队，5 个月）

- ~100 万行代码
- ~1,500 个 PR
- 3.5 PR/人/天（3 人团队时），扩到 7 人后**总吞吐量仍上升**
- 人工代码：**0 行**
- 约原本人工编码时间的 **1/10**

## 对 Codex 使用的约束（来自 Lopopolo 的经验）

1. 仓库要是"地图 + 结构化 docs/" 而不是大 AGENTS.md 百科全书
2. 架构要严格分层（Types → Config → Repo → Service → Runtime → UI），用自定义 linter 机械强制
3. 倾向于**枯燥技术**（API 稳定、可组合、训练集里常见）而非"最酷的新库"
4. 品味通过 lint 规则编码，不通过文档劝告
5. 熵/技术债要**持续垃圾回收**（后台 Codex 任务小额重构），不要积累

## 相关来源

- [[summaries/2026-02-11-harness-engineering]]

## 相关实体

- [[entities/OpenAI]]
- [[entities/Ryan Lopopolo]]

## 相关概念

- [[concepts/Harness Engineering]]
- [[concepts/Codebase as System of Record]]
- [[concepts/Agent Readability]]
