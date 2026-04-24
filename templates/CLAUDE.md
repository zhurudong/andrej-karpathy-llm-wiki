# 个人知识库

这是一个由 LLM 维护的双层 markdown 知识库。所有内容都是纯文本 markdown，可以用任何编辑器打开；也可以用 Obsidian、Logseq、VS Code + Foam 等支持 `[[wiki-link]]` 的软件获得更好的浏览体验（可选，不是必需）。

**会话启动**：每次新会话开始时，先读 `wiki/_log.md` 了解最近的操作历史，建立上下文连续性；若目录还不存在则跳过。

## 架构

```
.
├── raw/                          # 不可变原始文章（LLM 只读，人类只在摄入时写入）
│   ├── YYYY-MM-DD-标题.md
│   └── assets/                   # 原文附件（图片、PDF 等），按文章分子目录
│       └── <article-slug>/       # 与 raw .md 同 stem（过长时可缩写）
│           └── NN-描述.{png,jpg,pdf,...}
├── wiki/                         # LLM 完全拥有的派生层（人类只读）
│   ├── summaries/                # 每篇文章一个摘要（1:1 对应 raw）
│   ├── entities/                 # 人物、组织、产品、技术（跨文章积累）
│   ├── concepts/                 # 方法论、架构模式、理论（跨文章积累）
│   ├── comparisons/              # A vs B 对比分析（条件生成）
│   ├── overviews/                # 主题综述（≥3 篇相关文章时生成）
│   ├── synthesis/                # 查询归档的综合分析（markdown only）
│   ├── _index.md                 # 自动维护的总索引（内容导向）
│   └── _log.md                   # 自动维护的操作日志（时间线导向，append-only）
└── CLAUDE.md                     # 本文件
```

**两层的意义**：`raw/` 是不可变的事实底座——"知识"。`wiki/` 是 LLM 对知识的当前理解——"对知识的理解"。两者分开，理解可以随时重新生成。

**两个特殊文件**：
- `_index.md`：内容导向的目录。查询时**首先读 index** 定位相关页面，而非盲扫全目录。
- `_log.md`：时间线导向的操作记录，append-only。记录每次摄入、查询归档、lint。新会话通过读 log 了解最近发生了什么。

## 原则

1. **raw 不可变**：raw 文件及其 `assets/` 附件写入后绝不修改、绝不删除，任何情况都不例外
2. **wiki 可重生**：summaries → entities → concepts → comparisons → overviews 都可以从 raw 重新生成（synthesis 除外——它由查询触发，不从 raw 派生）
3. **先查后建**：创建实体/概念页面前，搜索已有文件和别名，避免重复
4. **信息不丢失**：增量更新实体/概念时，保留所有已有信息
5. **链接格式**：始终使用 `[[folder/name]]` 格式（如 `[[entities/Kubernetes]]`），带文件夹前缀
6. **语言**：wiki 内容默认中文，技术术语保留英文原名

## Conventions

### 文件命名

- raw 文件：`YYYY-MM-DD-<标题>.md`，特殊字符替换为 `-`，连续 `-` 合并，标题截断至 80 字符
- raw 附件：`raw/assets/<slug>/NN-<描述>.<ext>`
  - `<slug>` 与 raw .md 的 stem 一致；若文件名过长可缩写，但必须保留日期前缀 `YYYY-MM-DD-` 且在本文章内稳定
  - `NN` 为两位零填充序号（`01`、`02` …），按在原文中的出现顺序编号
  - 在 raw .md 中用相对路径引用：`![alt](assets/<slug>/NN-xxx.jpg)`，**不要**使用绝对路径或 `../`
  - 附件仅由 raw 引用；wiki 层如需展示图片，也通过相对路径 `../raw/assets/<slug>/...` 引用，不复制文件
- wiki 页面：以主题命名（如 `Kubernetes.md`、`Harness Engineering.md`）
- comparisons：`A vs B.md`
- synthesis：以回答主题命名，非原始问题

### Frontmatter

每个 wiki 页面都有 frontmatter，包含 `type`、`created`、`updated`、`tags` 等字段。最小模板：

```yaml
---
type: summary | entity | concept | comparison | overview | synthesis
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tag1, tag2]
source: [[raw/YYYY-MM-DD-标题]]   # 仅 summary 有
aliases: [别名1, 别名2]            # 仅 entity/concept 有
---
```

### 交叉链接拓扑

```
raw/文章  ←──  summaries（唯一直接引用 raw 的页面）
                  │
                  ▼
          entities  ↔  concepts
              │            │
              ▼            ▼
          comparisons  comparisons
                  \      /
                   ▼    ▼
                overviews

synthesis ──→ 所有页面（只出不入，叶子节点）
```

## 工作流

### 摄入（用户提供 URL 或文件时）

当用户说"抓取"、"收录"、"保存"、粘贴 URL 等，执行三阶段流程：

**阶段 1：抓取并保存 raw**
1. 用可用工具（WebFetch / curl / 浏览器 MCP 等）抓取 URL 内容，保留正文、作者、发布日期、图片
2. 下载所有图片/附件到 `raw/assets/<slug>/NN-描述.<ext>`
3. 保存正文为 `raw/YYYY-MM-DD-<标题>.md`，附件用相对路径引用
4. 摄入前先检查 URL 是否已在 `wiki/_log.md` 或现有 raw 文件的 frontmatter 中出现，已收录则跳过

**阶段 2：编译 wiki**
1. **摘要**：在 `wiki/summaries/` 创建 1:1 摘要，链接回 `[[raw/...]]`
2. **实体抽取**：识别人物、组织、产品、技术等专有名词
   - 存在对应页面则增量更新（保留已有信息，追加新来源）
   - 不存在则新建于 `wiki/entities/<Name>.md`
3. **概念抽取**：识别方法论、架构模式、理论
   - 存在则更新，不存在则新建于 `wiki/concepts/<Concept>.md`
4. **对比评估**：若本文明显对比两个已有实体/概念，生成 `wiki/comparisons/A vs B.md`
5. **综述评估**：若某主题下已有 ≥3 篇相关摘要，生成或更新 `wiki/overviews/<Topic>.md`

**阶段 3：索引与日志**
1. 更新 `wiki/_index.md`（按类型分组列出新增/更新的页面，附一句话描述）
2. append 到 `wiki/_log.md`：时间戳、URL、生成/更新了哪些页面

### 查询（用户提问时）

当用户提问（非摄入操作）时，主动搜索知识库回答：

1. **先读索引**：读取 `wiki/_index.md`，从目录中定位与问题相关的页面
2. **定向阅读**：读取索引中识别出的相关页面（summaries、entities、concepts 等）
3. **补充搜索**：如果索引不足以定位，用 Grep 按关键词在 `wiki/` 中补充搜索
4. **综合回答**：内联引用 `[[folder/name]]` wiki-link
5. 如果知识库中没有相关内容，直接告知用户，不要编造
6. 要有批判性精神，对观点有深度见解，不需要讨好用户

**归档判断**——回答完成后评估是否值得归档到 `wiki/synthesis/`：

- 综合了 ≥2 个 wiki 页面的信息 → 建议归档
- 产生了跨领域的新洞察或连接 → 建议归档
- 用户明确表示有价值 → 归档
- 简单事实查询、单一页面检索 → 不归档

建议方式："这个回答综合了多个来源，要归档到知识库吗？"用户确认后保存为 markdown 页面，更新 `_index.md`，在 `_log.md` 中 append 记录。

### Lint（定期健康检查）

用户说"lint wiki"、"检查知识库"、"健康检查"时，按以下步骤执行：

**Step 1：结构扫描**（机械化检查，可自动执行）
1. **缺失页面**：Grep 所有 `[[...]]` 链接，检查目标文件是否存在
2. **孤立页面**：Grep 每个 wiki 页面的文件名，确认至少被一个其他页面引用（summaries 除外，它们通过 index 引用）
3. **缺失交叉引用**：检查实体/概念的"相关实体""相关概念"章节，是否遗漏了同一来源文章中共同出现的其他实体/概念

**Step 2：内容审查**（需要阅读页面内容）
4. **矛盾检测**：阅读同一实体/概念在不同来源中的描述，标注矛盾之处
5. **过时信息**：对比较早的摘要与较新的摘要，检查较新来源是否推翻了旧声明
6. **缺失概念/实体**：扫描所有摘要页面，找出被多篇文章提及但没有独立页面的重要主题

**Step 3：发展建议**（启发式）
7. **数据空白**：基于现有知识图谱，建议可以通过网络搜索填补的知识缺口
8. **新问题**：基于已有内容，建议值得探索的新问题

**输出**：问题清单 + 建议修复操作，等用户确认后执行。在 `_log.md` 中 append lint 记录。

### 维护

- **重新编译**：用户说"重新编译 wiki"时，从 raw 重新生成所有 wiki 页面（synthesis 保留不动）
- **更新索引**：用户说"更新索引"时，重新生成 `wiki/_index.md`
- **去重**：摄入前检查 URL 是否已收录
