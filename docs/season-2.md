# 卷二·大模型范式演进（数据 · Infra · 缩放 · 对齐 · Agent）

卷二与[卷一·能力演进地图](catalog.md)是同一片经典论文的**两种视角，不是先后续集**：卷一按能力/模态横切（CV / NLP / 多模态 / 生成 / 自监督 / RL），卷二按大模型生命周期纵切（前史 → 数据 → Infra → 缩放 → 训练 → 对齐 → 推理/Agent）。因为卷二是视角而非时间线，它会包含早于卷一 Transformer 的「前史」（Word2Vec / Seq2Seq / Attention）。

卷二不参与主 36 篇编号，单独用 `sNN` 编号；数据源见 `catalog/papers-season-2.yml`。

> 当前状态：已立项并搭好骨架，正文待分批撰写（`status: not-started`）。每篇笔记沿用与卷一相同的七问结构与「理解检查 + 参考要点」规范。

## 序列建模前史

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S1 | Word2Vec | 2013 | [阅读](../notes/season-2/foundations/s01-word2vec.md) |
| S2 | Seq2Seq | 2014 | [阅读](../notes/season-2/foundations/s02-seq2seq.md) |
| S3 | Attention (Bahdanau) | 2014 | [阅读](../notes/season-2/foundations/s03-attention-nmt.md) |
| S4 | GNMT | 2016 | [阅读](../notes/season-2/foundations/s04-gnmt.md) |

## 缩放与训练范式

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S5 | The Bitter Lesson | 2019 | [阅读](../notes/season-2/scaling-training/s05-bitter-lesson.md) |
| S6 | Scaling Laws | 2020 | [阅读](../notes/season-2/scaling-training/s06-scaling-laws.md) |
| S7 | Chinchilla | 2022 | [阅读](../notes/season-2/scaling-training/s07-chinchilla.md) |
| S8 | Mixture-of-Experts | 2017 | [阅读](../notes/season-2/scaling-training/s08-mixture-of-experts.md) |
| S9 | Knowledge Distillation | 2015 | [阅读](../notes/season-2/scaling-training/s09-knowledge-distillation.md) |

## 训练基础设施

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S10 | Brook for GPUs | 2004 | [阅读](../notes/season-2/infrastructure/s10-brook-for-gpus.md) |
| S11 | ZeRO | 2019 | [阅读](../notes/season-2/infrastructure/s11-zero.md) |
| S12 | MegaScale | 2024 | [阅读](../notes/season-2/infrastructure/s12-megascale.md) |

## 数据集与数据治理

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S13 | LAION-5B | 2022 | [阅读](../notes/season-2/data/s13-laion-5b.md) |
| S14 | RefinedWeb | 2023 | [阅读](../notes/season-2/data/s14-refinedweb.md) |

## 后训练与对齐

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S15 | InstructGPT | 2022 | [阅读](../notes/season-2/post-training-alignment/s15-instructgpt.md) |
| S16 | LoRA | 2021 | [阅读](../notes/season-2/post-training-alignment/s16-lora.md) |
| S17 | Tülu 3 | 2024 | [阅读](../notes/season-2/post-training-alignment/s17-tulu-3.md) |

## 推理与 Agent

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S18 | Chain-of-Thought | 2022 | [阅读](../notes/season-2/reasoning-agents/s18-chain-of-thought.md) |
| S19 | ReAct | 2022 | [阅读](../notes/season-2/reasoning-agents/s19-react.md) |

## 自博弈与强化学习

| # | 论文 | 年份 | 笔记 |
|---:|---|---:|---|
| S20 | AlphaGo Zero | 2017 | [阅读](../notes/season-2/self-play-rl/s20-alphago-zero.md) |
