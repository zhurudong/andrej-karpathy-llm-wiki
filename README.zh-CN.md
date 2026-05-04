# LLM-Maintained Knowledge Base

[English](./README.md) | **简体中文**

> 一个 `CLAUDE.md` = 一个能自我维护的本地知识库。无后端、无向量库、无 RAG 框架。

```bash
curl -fsSL https://raw.githubusercontent.com/zhurudong/andrej-karpathy-llm-wiki/main/install.sh | bash -s my-kb zh
```

跑完上面这行，进 `my-kb/` 启动 LLM CLI 说"收录 https://example.com/article"，你就有了一个由 LLM 自己抓取、整理、索引、查询的知识库。所有内容都是纯 markdown，用任何编辑器都能打开。

> 受 Andrej Karpathy 的 gist 启发：<https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>。

## 为什么

主流"个人知识库"方案往往走两条路：

- **笔记软件**（Notion / Obsidian / Logseq）——擅长存储和浏览，但整理、打标、建立关联全靠人工。
- **RAG / 向量检索**——擅长大规模语料问答，但需要嵌入服务、向量库、索引管道，重、脆、黑盒。

这个项目走第三条路：**把"整理"本身交给 LLM，用 markdown 文件做底座，用 wiki-link 做关联，用 LLM CLI 做运行时**。

- 原始文章不可变，LLM 生成的摘要/实体/概念页面可随时重新编译
- 所有内容都是纯 markdown，可以用任何编辑器、Git、grep 直接处理
- 知识图谱由 `[[wiki-link]]` 自然形成，不需要图数据库
- 换 LLM 工具不需要迁移数据——规则都在 `CLAUDE.md` 里

典型用法：

- **读论文做笔记**：抓 arXiv 链接，LLM 自动生成摘要并关联已有概念
- **跟踪某个领域**：定期收录行业博客，`overviews/` 会自动形成主题综述
- **个人思考归档**：问问题时让 LLM 把综合答案存到 `synthesis/`，逐步形成自己的观点库
- **团队协作**：推到 Git，团队成员各自用自己的 LLM CLI 维护同一个知识库

## 快速开始

两种方式安装，推荐“一键安装”。

### 一键安装

一行命令搞定——目录、`CLAUDE.md`、`AGENTS.md` 软链、空的 `raw/` + `wiki/` 骨架全部就绪：

```bash
curl -fsSL https://raw.githubusercontent.com/zhurudong/andrej-karpathy-llm-wiki/main/install.sh | bash -s my-kb zh
```

第一个参数是目录名（默认 `my-knowledge-base`），第二个参数 `zh`/`en` 选模板语言。跑完 `cd my-kb`，进 LLM CLI 直接用自然语言下指令。

### 手动安装

不想把脚本管道给 bash？三行命令同样搞定：

```bash
mkdir my-knowledge-base && cd my-knowledge-base
curl -fsSL -o CLAUDE.md https://raw.githubusercontent.com/zhurudong/andrej-karpathy-llm-wiki/main/templates/CLAUDE.md
ln -s CLAUDE.md AGENTS.md
```

唯一一个 [`templates/CLAUDE.md`](https://github.com/zhurudong/andrej-karpathy-llm-wiki/blob/main/templates/CLAUDE.md) 文件就是全部"程序"——它告诉 LLM 如何组织知识库。`AGENTS.md` 软链让同一个文件能被多家 CLI 识别：

| CLI                                                | 约定文件                          |
| -------------------------------------------------- | ----------------------------- |
| [Claude Code](https://docs.claude.com/claude-code) | `CLAUDE.md`                   |
| [Codex CLI](https://github.com/openai/codex)       | `AGENTS.md`（软链到 CLAUDE.md 即可） |
| [OpenCode](https://opencode.ai)                    | `AGENTS.md`                   |
| 其他支持项目规则文件的 Agent CLI                              | 参见各自文档                        |

### 开始收录

在你的 LLM CLI 里，直接用自然语言：

```
收录 https://www.anthropic.com/engineering/harness-design-long-running-apps
```

或者：

```
抓取这篇文章 https://www.anthropic.com/engineering/harness-design-long-running-apps
```

LLM 会自动执行：抓取网页 → 保存到 `raw/YYYY-MM-DD-标题.md` → 生成摘要 → 抽取/更新实体与概念页面 → 评估是否生成对比/综述 → 更新索引 → 写入操作日志。

### 开始查询

直接问问题：

```
Karpathy 对 agentic coding 怎么看？
RLHF 和 DPO 的核心区别是什么？
这个知识库里关于 tokenizer 有哪些讨论？
```

LLM 会先读 `wiki/_index.md` 定位相关页面，再综合回答，必要时建议把答案归档到 `wiki/synthesis/`。

### 健康检查

```
lint wiki
```

LLM 会扫描断链、孤立页面、矛盾描述、过时信息、缺失交叉引用等问题，给出修复建议。

## 目录结构

每个知识库实例遵循同一套约定：

```
my-knowledge-base/
├── CLAUDE.md                # 规则文件（LLM 读这个来运行）
├── raw/                     # 不可变原始文章
│   ├── YYYY-MM-DD-标题.md
│   └── assets/              # 原文附件
└── wiki/                    # LLM 派生的理解层
    ├── summaries/           # 每篇文章一个摘要
    ├── entities/            # 人物、组织、产品、技术
    ├── concepts/            # 方法论、架构模式、理论
    ├── comparisons/         # A vs B 对比
    ├── overviews/           # 主题综述
    ├── synthesis/           # 问答归档
    ├── _index.md            # 内容索引
    └── _log.md              # 操作日志
```

两层设计的核心：**`raw/` 是不可变的事实底座，`wiki/` 是 LLM 对事实的当前理解**。理解可以随时重新生成，事实永远保留。

## 浏览方式（可选）

生成的都是标准 markdown + `[[wiki-link]]` 格式。任何编辑器都能打开；如果你想要更好的双向链接和图谱视图，可以用：

- **[Obsidian](https://obsidian.md)**：把整个目录作为 Vault 打开，自动识别 `[[...]]` 并生成关系图
- **[Logseq](https://logseq.com)**：同样支持 wiki-link
- **VS Code + [Foam](https://foambubble.github.io/foam/)**：IDE 派首选
- **纯命令行**：`grep -r "\[\[" wiki/` 足以应付大多数查询

这些都是**可选的浏览工具**，本项目不依赖它们。

## 这个仓库本身

`examples/` 目录是一个真实运行过的样例，收录了若干 LLM 工程相关文章（初始为 OpenAI 的 [Harness Engineering](https://openai.com/zh-Hans-CN/index/harness-engineering/)）。你可以直接克隆来看生成出的 summaries / entities / concepts 长什么样，也可以只取 `templates/CLAUDE.md` 开始自己的。

## 致谢

`CLAUDE.md` 知识库设计思路源于 Andrej Karpathy 的 gist：<https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>。本项目在其之上做了工程化落地——双层结构（raw 不可变 / wiki 可重生）、交叉链接拓扑、摄入/查询/lint 工作流、跨 LLM CLI 的模板化。

## 许可

MIT
