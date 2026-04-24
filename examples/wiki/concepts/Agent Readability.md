---
type: concept
created: 2026-04-24
updated: 2026-04-24
tags: [methodology, observability, agent-first]
aliases: [Agent Readability, 智能体可读性]
---

# Agent Readability（智能体可读性）

让**应用运行时状态**（UI、日志、指标、追踪）可以被编码智能体直接读取和推理的能力。[[concepts/Harness Engineering]] 的一个支柱。

## 命题

> 随着代码吞吐量增加，瓶颈变成人工 QA 能力。由于人类的时间和注意力是固定的限制因素，必须让应用的 UI、日志、指标等对 Codex 直接可读，从而扩展智能体自己验证工作的能力。

与[[concepts/Codebase as System of Record]]（让**仓库**对智能体可读）形成互补——那个是**静态知识**可读，这个是**运行时状态**可读。

## 实践（来自 [[summaries/2026-02-11-harness-engineering]]）

### UI 可读性：Chrome DevTools MCP

- 应用可按 **git worktree 启动** → 每次 Codex 修改驱动一个独立实例
- Chrome DevTools 协议接入智能体运行时
- 技能包装：DOM 快照、屏幕截图、导航
- 效果：Codex 能复现 bug、验证修复、直接推理 UI 行为

### 可观测性可读性：本地临时堆栈

- 日志/指标/追踪发送到 Vector
- Vector 分发到 Victoria Logs / Victoria Metrics / 追踪后端
- **每个 worktree 一套独立堆栈，任务结束后销毁**
- 智能体接口：LogQL 查日志、PromQL 查指标

启用的 prompt 形态（从"描述目标"升级为"验证不变量"）：
- "确保服务启动在 800ms 内完成"
- "这四个关键用户旅程中的任何 span 都不得超过两秒"

### 长任务常态化

- 单次 Codex 运行在单个任务上持续 **>6 小时**是常见的
- 通常发生在人类睡觉时
- 只有当智能体能自己验证进展，才敢让它跑这么久

## 底层原则

任何**不在智能体情境里**的信号都等同于不存在：
- 一个需要人工打开浏览器才能看到的 UI bug → 智能体看不到
- 只在监控 dashboard 上可见的性能回归 → 智能体看不到
- 埋在 Slack 里的架构决定 → 智能体看不到

因此要**把所有验证信号推入智能体可编程访问的通道**。

## 设计取舍

- 倾向于**枯燥技术**（Chrome DevTools、Prometheus、Victoria Metrics 这类）
- 倾向于有**稳定 API 且在模型训练集里常见**的工具
- 有时**重新实现小部分功能子集**比调用黑盒公共库更便宜（文章里举了自己实现带并发的 map 辅助函数、不用 p-limit 的例子）

## 相关概念

- [[concepts/Harness Engineering]]
- [[concepts/Codebase as System of Record]]

## 相关实体

- [[entities/Codex]]

## 来源

- [[summaries/2026-02-11-harness-engineering]]
