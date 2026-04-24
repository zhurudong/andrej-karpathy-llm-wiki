---
type: concept
created: 2026-04-24
updated: 2026-04-24
tags: [methodology, agent-first, engineering]
aliases: [Harness Engineering, 支撑结构工程, 工程技术]
---

# Harness Engineering（支撑结构工程）

一套工程方法论：当软件产出完全由编码智能体（如 [[entities/Codex]]）完成时，工程师的工作重心从"写代码"转为**设计智能体能可靠工作的环境**——即"harness"（支撑结构、马具）。

术语来自 [[entities/Ryan Lopopolo]] 在 [[summaries/2026-02-11-harness-engineering]] 中的描述。

## 核心命题

> 纪律不消失，而是从代码转移到支撑结构。保持代码库一致性的工具、抽象和反馈回路变得越发重要。

工程师不再直接产出代码，而是产出让智能体产出代码的系统。

## 四个支柱

### 1. 仓库可读性（[[concepts/Agent Readability]]）

- 应用按 git worktree 启动 → 每次 Codex 修改跑独立实例
- Chrome DevTools 接入 → 智能体可复现 bug / 验证修复
- 临时可观测性堆栈 → LogQL/PromQL 查询日志与指标
- "智能体无法在情境里看到的 = 不存在"

### 2. 仓库即记录系统（[[concepts/Codebase as System of Record]]）

- AGENTS.md 降为"约 100 行的地图"
- `docs/` 承载设计文档、执行计划、技术债务、产品规范
- 渐进式披露：小切入点 → 按需展开
- 专职 linter + doc-gardening 智能体防腐烂

### 3. 强架构约束

- 业务域严格分层：`Types → Config → Repo → Service → Runtime → UI`
- 横切关注点只走显式 `Providers` 接口
- 通过**自定义 linter + 结构测试**机械强制
- "在人工流程中觉得迂腐的规则，在智能体流程中是倍增器"

### 4. 熵垃圾回收

- 代码漂移不可避免，但要**持续小额偿还**而非累积
- 后台 Codex 任务定期扫描偏差、发起小重构 PR
- 类比：技术债是高息贷款，每天还一点 << 一次性痛苦清理

## 关键原则

**当文档不够完善时，把规则转化为代码。**

lint 规则的错误信息要直接包含修复指令，这样修复建议会进入智能体情境。

## 吞吐量下的取舍

在智能体吞吐量远超人类注意力的系统里：
- 纠错成本低（再跑一次就行）
- 等待成本高（阻塞合并门扼杀吞吐）
- 所以 PR 生命周期要短，测试偶发失败允许重跑

在低吞吐环境这样做是不负责任的。

## 可迁移性判断

这套方法论**独立于"100% AI 生成代码"的激进约束**都成立：
- 把仓库当成智能体的记录系统 ✓
- 把品味编码成 lint 规则 ✓
- AGENTS.md 是地图不是百科全书 ✓

这三条对任何使用 Claude Code / Cursor / Codex / Aider 的工程团队都适用。

## 可能的反面观点

- 样本单一（OpenAI 自家团队 + 自家最新模型 + 专属基建），外部复现性存疑
- "零人工代码"的框架本身是一种 PR 修辞——人类仍在写 prompt、lint 规则、docs
- 一百万行代码 + 3.5 PR/天的数字缺少质量基准，无法判断 AI 生成代码的单位价值密度

## 相关概念

- [[concepts/Codebase as System of Record]]
- [[concepts/Agent Readability]]

## 相关实体

- [[entities/Codex]]
- [[entities/OpenAI]]
- [[entities/Ryan Lopopolo]]

## 来源

- [[summaries/2026-02-11-harness-engineering]]
