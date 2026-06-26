# AI Classic Papers for PMs

这是一个面向 AI 产品经理的经典论文学习项目。它把经典论文转化成可复述、可迁移、可用于产品判断的中文导读。

项目分两卷：

- [卷一·能力演进地图（36 篇）](catalog.md)：按 CV / NLP / 多模态 / 生成 / 自监督 / RL 横切，建立 AI 能力边界地图。
- [卷二·大模型范式演进（20 篇）](season-2.md)：按前史、缩放、Infra、数据、对齐、推理/Agent、自博弈纵切，理解大模型如何被造出来并进入产品系统。

两卷是同一片经典论文的两种视角，不是先后续集。

## 从哪里开始

| 你想要 | 推荐入口 |
|---|---|
| 建立全局地图 | [阅读地图](learning-map.md) |
| 按论文逐篇读 | [卷一目录](catalog.md) / [卷二目录](season-2.md) |
| 用 AI 陪自己读论文 | [Guided Learning 提示词](guided-learning.md) |
| 把分类笔记做成综述 PPT | [NotebookLM Slides 提示词](notebooklm-slides-prompt.md) |
| 了解项目内容规范 | [学习方法与搭建规范](building-spec.md) |

## 推荐学习流程

1. 先看 [阅读地图](learning-map.md)，判断要按“能力演进”还是“大模型生命周期”进入。
2. 每次只读一个分组，例如 NLP 7 篇、后训练与对齐 3 篇。
3. 单篇阅读时，先读“一句话”和“背景问题”，再读“核心方法”和“为什么经典”。
4. 读完后完成“理解检查”，确认自己能用产品语言复述，而不是只记住论文名。
5. 如果要做复盘，把同组笔记交给 NotebookLM 生成 slides，或把单篇笔记交给 Codex / Claude 做追问。

## 学习标准

读完一篇论文，不以“看过”为标准，而以能回答这些问题为标准：

1. 它解决了什么问题？
2. 为什么当时这个问题重要？
3. 核心机制是什么？
4. 它改变了哪些 AI 能力或产品形态？
5. 今天看还有哪些局限？

## 入口

- [阅读地图](learning-map.md)
- [卷一·能力演进地图（36 篇）](catalog.md)
- [卷二·大模型范式演进（20 篇）](season-2.md)
- [Guided Learning 提示词](guided-learning.md)
- [学习方法与搭建规范](building-spec.md)
- [NotebookLM Slides 提示词](notebooklm-slides-prompt.md)
- [术语表](glossary.md)
- [扩展路线](alternative-roadmap.md)
