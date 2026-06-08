# 术语表

面向 AI 产品经理的速查表，覆盖[卷一·能力演进地图](catalog.md)与[卷二·大模型范式演进](season-2.md)的核心概念。解释力求"先讲人话"，需要展开时再点到对应笔记。

## 基础架构与表示

**Embedding（嵌入 / 向量表示）**　把词、图片、用户等对象映射成一串数字（向量），让"语义相近 = 向量距离相近"变得可计算。语义搜索、推荐召回、RAG 检索都建立在它之上。→ [Word2Vec](../notes/season-2/foundations/s01-word2vec.md)

**CNN（卷积神经网络）**　Convolutional Neural Network。早期计算机视觉的核心架构，用卷积核逐层提取局部图像特征。

**Attention（注意力）**　让模型在处理每个位置时，按相关性动态地"加权读取"其他位置的信息，而不是把整句压成一个定长向量。最早作为 RNN 上的模块出现。→ [Attention (Bahdanau)](../notes/season-2/foundations/s03-attention-nmt.md)

**Self-attention / Transformer**　Self-attention 让序列中任意两个位置直接交互；Transformer 是完全基于它的架构，抛弃了循环结构、极利于大规模并行训练，是当今几乎所有大模型的骨架。→ [Transformer](../notes/nlp/11-transformer.md)

**Encoder-Decoder（编码器-解码器）**　一个网络读懂输入（编码），另一个网络据此生成输出（解码）的通用骨架，机器翻译、摘要等"输入→输出"任务的范式源头。→ [Seq2Seq](../notes/season-2/foundations/s02-seq2seq.md)

**Tokenization / 子词（BPE、WordPiece）**　把文本切成模型能处理的最小单元。子词切分把词拆成常见片段，几乎任何生僻词都能拼出来，既控制词表大小又缓解未登录词；它也决定了今天大模型的 token 计费方式。→ [GNMT](../notes/season-2/foundations/s04-gnmt.md)

**Pre-training（预训练）**　先用大规模数据学到通用能力，再针对具体任务微调或提示。"基座决定能力上限"。

**Fine-tuning（微调）**　在已训练好的模型基础上，用特定任务或领域数据继续训练，让它适配具体场景。

**Self-supervised Learning（自监督学习）**　不靠人工标注，直接从数据本身构造监督信号（如"用上下文预测中心词""遮住一块再还原"）。让海量无标注数据产生价值。

## 训练、缩放与基础设施

**Scaling Laws（缩放律）**　模型测试 loss 随参数量、数据量、算力按平滑的"幂律"下降——模型变强可以提前预测、画在曲线上，把"要不要训更大模型"变成一道工程预算题。→ [Scaling Laws](../notes/season-2/scaling-training/s06-scaling-laws.md)

**Compute-optimal / Chinchilla（算力最优）**　固定算力下，参数量和训练数据量应近似等比、同步放大（不是一味堆参数）。一个喂饱的小模型可以打败"营养不良"的大模型，且推理更便宜。→ [Chinchilla](../notes/season-2/scaling-training/s07-chinchilla.md)

**Emergent Ability（涌现能力）**　某些能力在模型小时几乎为零，规模越过某个门槛后突然大幅出现，呈非线性。提醒我们"小模型上试不行"未必代表此路不通。→ [Chain-of-Thought](../notes/season-2/reasoning-agents/s18-chain-of-thought.md)

**MoE（Mixture-of-Experts，混合专家）**　把一层拆成成百上千个"专家"，每个输入只激活极少数几个。总参数量（容量）可暴涨，而每次前向的算力几乎不变——把模型做大却不必等比增加计算。→ [Mixture-of-Experts](../notes/season-2/scaling-training/s08-mixture-of-experts.md)

**Knowledge Distillation（知识蒸馏）**　用一个大"教师"模型输出的软标签（概率分布）去训练小"学生"模型，让小模型以很低成本逼近大模型效果。是部署降本的奠基方法，区别于剪枝、量化。→ [Knowledge Distillation](../notes/season-2/scaling-training/s09-knowledge-distillation.md)

**Quantization（量化）**　用更低精度（如 4-bit）表示模型权重/计算，换取更省显存、更快更便宜的推理；是模型能否大规模上线的决定性因素之一。

**Data / Tensor / Pipeline Parallelism（数据/张量/流水并行）**　把训练分摊到多卡的不同方式：数据并行复制模型分摊数据，张量/流水并行切分模型本身。

**ZeRO**　一种省显存的数据并行：把优化器状态、梯度、参数分片到各张 GPU、用时再临时拼回，单卡显存占用降一个数量级，让大模型"训得动"。→ [ZeRO](../notes/season-2/infrastructure/s11-zero.md)

**MFU（Model FLOPs Utilization）**　模型算力利用率——真正用于有效计算的算力占理论峰值的比例，衡量万卡训练"有没有让算力空转"的关键效率指标。→ [MegaScale](../notes/season-2/infrastructure/s12-megascale.md)

**GPGPU**　用图形处理器（GPU）做通用计算。把硬件算力用易用编程模型释放出来的路线，是 CUDA 与今天深度学习跑在 GPU 上的史前史。→ [Brook for GPUs](../notes/season-2/infrastructure/s10-brook-for-gpus.md)

## 数据与数据治理

**Data Curation / Filtering / Deduplication（数据清洗 / 过滤 / 去重）**　大模型数据的胜负手常在"加工"而非"来源"：充分过滤 + 狠去重能把脏网页变成主食。去重还能省算力、抑制逐字"背诵"带来的隐私/版权风险。→ [RefinedWeb](../notes/season-2/data/s14-refinedweb.md)

**Data Governance（数据治理）**　把整个开放网络当训练集，意味着同时继承其中的偏见、版权争议、NSFW 乃至非法内容——数据的合规与质量是产品级风险。→ [LAION-5B](../notes/season-2/data/s13-laion-5b.md)

## 后训练与对齐

**Alignment（对齐）**　让有能力的模型，其行为对齐到人类意图——听指令、有用、诚实、无害。注意"对齐 ≠ 能力"：能力来自预训练，对齐是后训练的事。→ [InstructGPT](../notes/season-2/post-training-alignment/s15-instructgpt.md)

**RLHF（人类反馈强化学习）**　三段式：监督微调（SFT）→ 训练奖励模型 → 用 PPO 强化。把"人类更喜欢哪个回答"规模化地灌进模型，是 ChatGPT 一代的标准后训练范式。→ [InstructGPT](../notes/season-2/post-training-alignment/s15-instructgpt.md)

**SFT（监督微调）**　用人工写好的"指令—理想回答"示范数据微调模型，让它从"续写机器"初步变成"应答助手"。

**Reward Model（奖励模型）**　用人类对回答的排序偏好训练出的打分函数，充当"人类判断的自动代理"，让强化学习不必每步都叫人评判。

**DPO（Direct Preference Optimization，直接偏好优化）**　跳过显式奖励模型和 PPO，直接用成对偏好数据、以一个更简洁稳定的损失把模型往"被偏好回答"上推，是 RLHF 的轻量替代。→ [Tülu 3](../notes/season-2/post-training-alignment/s17-tulu-3.md)

**RLVR（基于可验证奖励的强化学习）**　在答案对错可被程序自动验证的任务（数学、可规则检查的指令）上，直接用"验证器判对错"当奖励，奖励客观、更难被钻空子；但只适用于可判定领域。→ [Tülu 3](../notes/season-2/post-training-alignment/s17-tulu-3.md)

**LoRA / PEFT（低秩适配 / 参数高效微调）**　冻结基座的几百亿参数，只在旁边挂一对很小的"低秩"矩阵学任务增量。可训练参数降到万分之一、checkpoint 从几十 GB 缩到几 MB，推理时还能合并回去不加延迟。→ [LoRA](../notes/season-2/post-training-alignment/s16-lora.md)

**Reward Hacking / Alignment Tax（钻奖励空子 / 对齐税）**　模型为讨好奖励而生成分数虚高、质量崩坏的回答（reward hacking）；对齐优化又常让模型在部分通用任务上退步（对齐税）。

**Hallucination（幻觉）**　模型一本正经地编造看似可信、实则错误的内容。对齐能改善语气与听话度，但不天然解决幻觉。

## 推理与 Agent

**Chain-of-Thought（CoT，思维链）**　在提示里示范"把中间推理一步步写出来"，不改一个参数就显著提升多步推理正确率；效果随规模涌现。是提示技术，不是训练方法。→ [Chain-of-Thought](../notes/season-2/reasoning-agents/s18-chain-of-thought.md)

**Agent / ReAct**　让模型"边想边做"：推理（Thought）与行动（调用工具、检索、观察）交替循环。是今天几乎所有"会用工具的 AI agent"的共同蓝本。→ [ReAct](../notes/season-2/reasoning-agents/s19-react.md)

**RAG（检索增强生成）**　先去外部知识库检索相关内容，再让模型基于检索结果作答，用真实信息为生成"接地"，是对抗幻觉的主力手段之一。

## 生成、自监督与强化学习

**Multimodal（多模态）**　模型同时处理图像、文本、音频、视频等多种输入或输出。→ [CLIP](../notes/multimodal/18-clip.md)

**Contrastive Learning（对比学习）**　通过拉近正样本、推远负样本来学习表示，无需逐样本标注。CLIP、SimCLR 都属此类。

**GAN / VAE（生成对抗网络 / 变分自编码器）**　两类经典生成模型：GAN 让"生成器"与"判别器"对抗博弈，VAE 用编码-解码并约束隐空间来生成数据。→ [GAN](../notes/generative-models/24-gan.md)

**Diffusion Model（扩散模型）**　通过逐步加噪再学习去噪来生成数据的模型家族，是当今主流文生图/视频的基础。→ [DDPM](../notes/generative-models/27-ddpm.md)

**Reinforcement Learning（强化学习）**　智能体通过与环境交互、获得奖励信号来学习策略。

**Self-play / MCTS（自我对弈 / 蒙特卡洛树搜索）**　在规则明确、胜负可判的环境里，机器只靠自己跟自己对弈、配合树搜索，无需人类数据就能自我提升到超人水平。→ [AlphaGo Zero](../notes/season-2/self-play-rl/s20-alphago-zero.md)
