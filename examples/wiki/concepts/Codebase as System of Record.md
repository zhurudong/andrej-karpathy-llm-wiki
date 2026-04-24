---
type: concept
created: 2026-04-24
updated: 2026-04-24
tags: [methodology, knowledge-management, agent-first]
aliases: [Codebase as System of Record, 仓库即记录系统]
---

# Codebase as System of Record（仓库即记录系统）

把代码仓库当成组织知识的**唯一权威来源**，而不是把设计决策、架构讨论、团队共识散落在 Google Docs / Slack / 人脑里。这是 [[concepts/Harness Engineering]] 的一个核心支柱。

## 为什么（智能体视角）

> 从智能体的角度来看，它在运行时无法在情境中访问的任何内容都是不存在的。

- Slack 讨论敲定的架构约定 → 智能体不知道
- 设计评审会议决定的 API 风格 → 智能体不知道
- Google Docs 里的产品规范 → 智能体不知道

智能体只能看到仓库里的、已版本化的、可被情境读取的工件。外部知识对它等价于**三个月前才入职的新员工对历史决策一无所知**。

## 实践（来自 [[summaries/2026-02-11-harness-engineering]]）

### AGENTS.md 是地图，不是百科全书

失败模式："一个大型的 AGENTS.md" ——
- 情境是稀缺资源，指令挤占任务代码
- 过多指导 = 无指导（一切都"重要"= 一切都不重要）
- 立刻腐烂，无法验证
- 单个大 blob 无法做机械覆盖率检查

正确做法：**约 100 行的 AGENTS.md** 作为入口地图，指向结构化的 `docs/`。

### 典型 docs/ 结构

```
AGENTS.md
ARCHITECTURE.md
docs/
├── design-docs/          # 设计文档 + 核心理念（core-beliefs）
├── exec-plans/           # 执行计划（active / completed）+ 技术债务追踪
├── generated/            # 自动生成产物（如 db-schema.md）
├── product-specs/        # 产品规范
├── references/           # 外部依赖的 LLM-friendly 参考（design-system-reference-llms.txt 等）
├── DESIGN.md / FRONTEND.md / PLANS.md / PRODUCT_SENSE.md
├── QUALITY_SCORE.md / RELIABILITY.md / SECURITY.md
```

### 执行计划是一流工件

- 小变更：临时轻量计划
- 复杂工作：结构化执行计划 + 进度/决策日志
- 全部 commit 进仓库 → 智能体无需外部情境就能续作

### 渐进式披露

智能体从小而稳定的切入点起步，按需展开更深文档，不会一开始就被百科全书淹没。

## 维护

- **linter + CI** 验证知识库新鲜度、交叉链接、结构正确
- 定期运行的 **"doc-gardening" 智能体**扫描过时/废弃文档，自动发起修复 PR

## 引申

这个思路和静态知识库（本仓库自身）的设计哲学高度一致：
- raw 层 = 不可变事实（代码本身 + 历史设计文档）
- wiki 层 = LLM 可重新编译的理解（生成的摘要、概念、交叉链接）
- 工作入口 = 一份小而稳的规则文件（AGENTS.md / CLAUDE.md）

## 相关概念

- [[concepts/Harness Engineering]]
- [[concepts/Agent Readability]]

## 来源

- [[summaries/2026-02-11-harness-engineering]]
