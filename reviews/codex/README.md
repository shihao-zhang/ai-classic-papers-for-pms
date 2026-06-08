# 卷二独立 Review 规范（codex 跑，维护者落地）

本目录用于卷二（`sNN`，20 篇）的**跨模型独立 review**：由 codex 作为外部审稿人产出发现，维护者侧逐条核实、落地修复，再把 catalog / 笔记 front-matter / GitHub Issue 从 `draft` 提升到 `reviewed`。

> 这是给 codex 读的 prompt + 清单 + 回传格式三合一。运行前请基于**最新 main**（20 篇正文均为 `status: draft`）。

## 你的角色

你是一位严格但不挑刺的外部审稿人，面向 **AI 产品经理** 的中文论文学习笔记。先读 `docs/building-spec.md`（内容规范）与两篇范例 `notes/nlp/11-transformer.md`、`notes/vision-transformer-self-supervised/30-vit.md` 建立标准，再逐篇审。**只审已写好的正文，不重写。** 目标是发现**真问题**，不为凑数编造。

## 审查清单（每篇逐项过）

1. **结构完整**：一句话 / 背景问题 / 核心方法 / 为什么经典 / 产品经理启发 / 局限与争议 / 今天怎么看 / 理解检查 / 延伸阅读，缺节即记 High。
2. **归因准确（重点）**：是否把后续工作/相邻概念的功劳错算给本文？逐篇对照下方「归因红线」。任何越界即记 High。
3. **事实/数字**：模型规模、年份、指标、对比结论是否与论文一致、无臆造。可疑数字记 High/Medium。
4. **理解检查**：5 道开放题是否有价值；每题下的 `参考要点` 折叠块是否**能从正文推出**、**不引入正文没有的新事实**（引入即记 Medium）。
5. **PM 启发**：是否落到具体产品判断（成本/规模/数据/对齐/部署…），而非停在「很重要」。空泛记 Medium。
6. **引用边界**：无 PDF；无大段照抄论文/文章原文；外链仅 arXiv/官方。违反记 High。
7. **内部一致 & 可读**：术语先讲人话、前后不矛盾、无明显病句。记 Low。

## 范围与归因红线（20 篇）

| # | 文件 | 归因红线（不得越界） |
|---|---|---|
| s01 | `notes/season-2/foundations/s01-word2vec.md` | 静态词向量(CBOW/skip-gram)、自监督；**非**上下文相关(ELMo/BERT 是后来)、**非** attention 起源；negative sampling 属姊妹论文 |
| s02 | `notes/season-2/foundations/s02-seq2seq.md` | LSTM encoder-decoder 做 MT；定长向量瓶颈→催生 attention；**不是** Transformer |
| s03 | `notes/season-2/foundations/s03-attention-nmt.md` | RNN 之上的 additive attention/软对齐；**≠ self-attention / Transformer (Vaswani 2017)** |
| s04 | `notes/season-2/foundations/s04-gnmt.md` | 生产级 NMT 工程化(深层 LSTM+attention+WordPiece+量化)；**规模工程非新理论** |
| s05 | `notes/season-2/scaling-training/s05-bitter-lesson.md` | Sutton **观点文(非实验论文)**；通用方法+算力胜过手工知识 |
| s06 | `notes/season-2/scaling-training/s06-scaling-laws.md` | loss 随算力/数据/参数幂律；Kaplan 最优配比**后被 Chinchilla 修正** |
| s07 | `notes/season-2/scaling-training/s07-chinchilla.md` | compute-optimal=参数与数据同步放大，纠正 Kaplan「训练不足」；**非新架构** |
| s08 | `notes/season-2/scaling-training/s08-mixture-of-experts.md` | 稀疏门控 MoE 层，容量与计算解绑；Switch/GShard 是**后续**放大 |
| s09 | `notes/season-2/scaling-training/s09-knowledge-distillation.md` | 教师软标签训小学生；**≠ 剪枝/量化** |
| s10 | `notes/season-2/infrastructure/s10-brook-for-gpus.md` | GPU 流式计算/GPGPU，CUDA 思想前身；**历史 infra，非 ML 方法** |
| s11 | `notes/season-2/infrastructure/s11-zero.md` | optimizer/梯度/参数分片省显存的数据并行(DeepSpeed)；**≠ 张量/流水并行** |
| s12 | `notes/season-2/infrastructure/s12-megascale.md` | 万卡级 LLM 训练生产系统(字节)；规模下的效率(MFU)+可靠性 |
| s13 | `notes/season-2/data/s13-laion-5b.md` | CLIP 过滤的开放图文数据集；点明过滤/偏见/NSFW/版权等数据治理代价 |
| s14 | `notes/season-2/data/s14-refinedweb.md` | 充分过滤/去重的网页数据可媲美精选语料(Falcon)；重在去重/过滤管线 |
| s15 | `notes/season-2/post-training-alignment/s15-instructgpt.md` | RLHF 三段式(SFT→奖励模型→PPO)；**对齐≠能力**，基座本事来自 GPT-3 |
| s16 | `notes/season-2/post-training-alignment/s16-lora.md` | 低秩适配 PEFT、冻结基座；**≠量化**(QLoRA 后来)、**≠RLHF** |
| s17 | `notes/season-2/post-training-alignment/s17-tulu-3.md` | 开放后训练配方(SFT+DPO+RLVR)、2024；**非发明 DPO/RL** |
| s18 | `notes/season-2/reasoning-agents/s18-chain-of-thought.md` | 提示引出中间推理、**随规模涌现**；**提示技术非训练方法** |
| s19 | `notes/season-2/reasoning-agents/s19-react.md` | 推理与行动(工具/观察)交替的 **agent 范式**，**不是某个模型** |
| s20 | `notes/season-2/self-play-rl/s20-alphago-zero.md` | 从零自博弈、无人类棋谱、**单网络+纯 MCTS**；与 2016 AlphaGo / AlphaZero / MuZero 区分 |

## 回传格式（每篇一段，可粘贴回聊天，或写成 `reviews/codex/sNN-slug.codex-review.md`）

```
## sNN <short-title>
Verdict: Pass | Pass-with-edits | Needs-work
- [High]   <file:line> 问题 → 建议改法
- [Medium] <file:line> 问题 → 建议改法
- [Low]    <file:line> 问题 → 建议改法
（无某等级则省略；Pass 可只写一句总评）
```

- **定级**：High=事实/归因错误、缺节、违反引用边界；Medium=参考要点引入新事实、PM 启发空泛、表述误导；Low=措辞/一致性。
- 给 `file:line` 与**具体改法**，不要泛泛而谈；不确定就标 “(待核实)”，由维护者侧核。

## 建议运行方式（可多实例并行）

按四组并行（与撰写分工一致），或更细到每篇一个实例：

- B 组 scaling-training：s05–s09
- C 组 infrastructure+data：s10–s14
- D 组 post-training+reasoning+self-play：s15–s20
- A 组 foundations：s01–s04

例：`codex exec "读 reviews/codex/README.md，按其清单 review notes/season-2/scaling-training 下的 5 篇，输出每篇的回传段落"`

## 维护者侧后续（收到回传后）

逐条**独立核实**（对照笔记与论文，不盲信）→ 落地真实修复 → 写入 `reviews/codex/sNN-slug.codex-review.md`（Verdict/核实结论/已改项）→ 达标的把 catalog + 笔记 front-matter + Issue 由 `draft` 提升 `reviewed`。
