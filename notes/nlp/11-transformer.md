# Transformer：Attention Is All You Need

> 分类：自然语言处理  
> 年份：2017  
> 论文：https://arxiv.org/abs/1706.03762  
> 状态：draft

## 一句话

Transformer 把机器翻译里的序列建模从“按顺序一步步读”的 RNN/CNN 路线，改成“所有词彼此直接看见、用注意力分配信息”的路线，因此训练更并行、长距离依赖更容易学习，并成为后来 BERT、GPT、T5 以及大语言模型的核心骨架。

## 背景问题

在 Transformer 之前，主流的序列到序列任务，比如机器翻译，通常采用 encoder-decoder 架构：encoder 读入源语言句子，decoder 逐步生成目标语言句子。强模型多基于 RNN、LSTM、GRU，后来也有 CNN 序列模型；attention 已经被广泛使用，但更多是“辅助模块”，不是整个模型的主体。

当时的关键卡点有三个。

第一，RNN 天然按时间步串行计算。第 10 个词的表示通常要等前 9 个词处理完才能得到，这会限制 GPU/TPU 的并行能力。训练数据越大、句子越长，这个瓶颈越明显。

第二，长距离依赖难学。比如“这家公司虽然连续亏损，但因为现金储备充足，所以仍然能融资”里，“公司”和“融资”之间隔了很多词。RNN 需要信息沿着很多步传递，CNN 也要靠多层堆叠扩大感受野；路径越长，模型越难稳定捕捉关系。

第三，工程迭代成本高。机器翻译当时已经进入大数据、大模型、大算力阶段，模型不只要效果好，还要训练快、能扩展、能被硬件高效执行。Transformer 的核心判断是：如果把“顺序处理”这个结构性约束拿掉，只保留 attention，是否能同时提升效果和训练效率？

## 核心方法

### 1. 整体结构：仍然是 encoder-decoder，但内部换了发动机

Transformer 没有抛弃机器翻译常用的 encoder-decoder 框架。

encoder 负责把输入句子转成一组上下文表示。它不是给每个词一个孤立向量，而是让每个位置都融合整句信息。比如处理“bank”时，模型会根据周围词判断它更像“银行”还是“河岸”。

decoder 负责生成输出句子。它一边看已经生成的目标语言内容，一边通过 encoder-decoder attention 查看源语言句子的全部位置，决定下一个词应该是什么。为了避免“偷看未来答案”，decoder 的 self-attention 会加 mask：生成第 5 个词时，只能看第 1 到第 4 个词。

所以，Transformer 的创新不是“发明了翻译的输入输出流程”，而是把 encoder 和 decoder 内部的主要计算单元，从循环或卷积换成了 self-attention、multi-head attention 和前馈网络的组合。

### 2. Self-attention：每个词都能直接询问整句话

Self-attention 可以先理解成一种“信息路由机制”：一句话里的每个 token 都会问，当前我要理解自己，应该重点参考哪些其他 token？

论文里的实现用 Query、Key、Value 三组向量来做这件事。

- Query：我现在想找什么信息。
- Key：我能被别人用什么线索匹配到。
- Value：如果别人关注我，我能提供什么内容。

每个 token 用自己的 Query 去和所有 token 的 Key 做匹配，得到一组权重；再按权重加总对应的 Value，形成新的表示。结果是，每个位置都不是孤立理解自己，而是在整句上下文里重新定义自己。

这对长距离依赖特别重要。RNN 里，两个相距很远的词要经过很多中间状态传递信息；self-attention 里，它们在一层里就可以直接建立联系。代价是计算量随序列长度平方增长，也就是长文本越长，attention 成本增长越快。

### 3. Multi-head attention：不只用一个视角看上下文

如果只有一个 attention 头，模型会把所有关系压到一个“平均视角”里，容易混在一起。Multi-head attention 的做法是：把同一批 token 投影到多个较小的子空间，让多个 attention head 并行工作，然后把结果拼回去。

对产品经理来说，可以把它想成多个分析员同时读同一句话：有人关注主谓关系，有人关注指代关系，有人关注位置关系，有人关注语义搭配。最后模型把这些视角合并成一个更丰富的表示。

需要注意的是，论文展示了 attention head 有一定可解释性，但今天不能简单说“每个 head 都代表一个明确语言规则”。在大模型里，head 的行为更复杂，有些头有清晰功能，有些头可能冗余或难以解释。

### 4. Positional encoding：给没有顺序感的 attention 注入位置

Self-attention 本身有一个问题：它天然更像在处理一袋 token，而不是一条有顺序的句子。如果只看 token 集合，“狗咬人”和“人咬狗”的词一样，但含义完全不同。

Transformer 因此在词向量里加入 positional encoding，也就是位置编码。论文主版本使用不同频率的正弦、余弦函数来表示位置，并把位置向量加到 token embedding 上。这样模型既能知道一个词在第几个位置，也更容易学习相对距离，比如“前一个词”“后两个词”。

论文也实验了可学习的位置向量，结果与正弦位置编码接近。作者选择正弦版本，是因为它理论上可能更容易外推到训练中没见过的更长序列。今天看，位置编码已经发展出很多变体，比如相对位置、RoPE、ALiBi 等，原始正弦编码不再是唯一主流方案，但“显式处理顺序信息”这个问题仍然存在。

### 5. 并行训练：为什么它更适合规模化

Transformer 能规模化，核心不是某个单点技巧，而是结构与硬件匹配。

RNN 的训练像排队：一个 token 的状态依赖前一个 token 的状态，句内并行度低。Transformer 的 self-attention 可以把同一句里的所有 token 一起做矩阵计算，很多操作能一次性丢给 GPU/TPU 并行执行。

这带来几个连锁结果。

- 更高吞吐：同样时间内能处理更多 token。
- 更快实验：研究者能更快试模型尺寸、数据、正则化和训练策略。
- 更容易堆规模：参数、数据、batch size 增长时，矩阵乘法是硬件最擅长优化的计算形态。
- 更统一的模块：encoder、decoder、跨注意力和前馈层可以重复堆叠，工程上更模块化。

这也是为什么 Transformer 不只是“一个翻译模型”，而更像一套可扩展的建模基础设施。后来的 BERT 主要使用 encoder，GPT 主要使用 decoder-only，T5 保留 text-to-text 的 encoder-decoder 思路；它们都从这套结构里拆出不同产品能力。

## 为什么经典

第一，它改变了序列建模的默认范式。论文证明，在机器翻译这类典型序列转导任务上，不依赖循环和卷积也能做到当时领先效果，而且训练更快。

第二，它把 attention 从辅助机制提升为主体架构。此前 attention 常用于帮助 decoder 对齐源句子；Transformer 让 attention 负责构造表示、建模上下文、连接输入输出。

第三，它把“模型效果”和“可训练规模”绑在一起考虑。论文的影响不只在 BLEU 分数，更在于它把 NLP 模型带到更适合现代加速器的计算路径上。后来大模型的 scaling law、预训练-微调、指令微调、长上下文推理，都很大程度建立在这个可扩展骨架之上。

第四，它提供了一种通用积木。Transformer 可以只用 encoder 做理解，可以只用 decoder 做生成，也可以用 encoder-decoder 做翻译、摘要、结构化转换。这种可拆可组的能力，对后续模型平台化非常关键。

## 产品经理启发

1. 架构创新有时不是“加功能”，而是移除关键瓶颈。Transformer 的重要动作是去掉 RNN/CNN 的顺序依赖，把问题重构为更适合并行计算的信息匹配。

2. 产品能力要看“质量上限”和“规模化成本”两条线。一个模型 demo 准，不代表能支撑大规模训练、频繁迭代和低成本部署。Transformer 的经典之处在于同时改善了效果和训练吞吐。

3. 注意力机制对应产品里的“上下文选择”。做 AI 产品时，模型并不是平均使用所有输入；它会在上下文里动态分配关注。RAG、长上下文、Agent 记忆、工具调用编排，本质上都要回答“当前任务该看哪些信息”。

4. 架构会影响产品形态。encoder 更适合理解、分类、检索、匹配；decoder-only 更适合开放式生成和对话；encoder-decoder 更适合输入到输出的转换任务。选模型不是只看榜单，还要看任务是“理解为主”“生成为主”还是“转换为主”。

5. 长上下文不是免费能力。Self-attention 让远距离 token 更容易相互连接，但标准 attention 的计算和显存成本会随长度快速增长。产品上设计长文档问答、会议纪要、代码库理解时，仍要权衡上下文长度、延迟、成本、准确率和检索策略。

6. 可解释性要谨慎使用。Attention 权重能帮助观察模型关注了哪里，但不能等同于完整因果解释。面向客户展示时，可以把它当辅助调试信号，不宜包装成“模型为什么这样回答”的充分证明。

## 局限与争议

第一，标准 self-attention 的长序列成本高。每个 token 都看所有 token，序列越长，计算和显存压力越大。今天的长上下文模型通过稀疏注意力、滑窗、分块处理、位置编码改造、检索增强等方式缓解；推理阶段还会用 KV cache 避免重复计算历史 token。但标准 Transformer 本身并没有彻底解决超长输入问题。

第二，decoder 生成仍然是串行的。训练时可以并行处理目标序列位置，但推理生成第 n 个 token 时通常要先生成前 n-1 个 token。论文也提到希望减少生成过程的顺序性，这在今天仍是推理加速的重要方向。

第三，位置理解并不天然稳健。原始 positional encoding 能给模型位置信息，但对更长上下文、复杂结构、代码缩进、表格、跨段落引用等场景，后续仍需要大量改造和工程补丁。

第四，attention 不等于解释。早期论文给出了一些 attention head 可视化，让人看到模型似乎学到了语法和语义关系；但后续研究表明，attention 权重和模型决策原因之间不能简单画等号。

第五，经典论文的实验范围有限。它主要在机器翻译和一个句法分析任务上验证。今天 Transformer 横跨文本、图像、音频、视频、多模态和强化学习，这些不是原论文直接证明的结论，而是后续大量工作和工程投入扩展出来的结果。

第六，它打开了大模型规模化路线，也放大了资源门槛。Transformer 让大规模训练更可行，但并不意味着训练成本低；相反，后续竞争把算力、数据、人才和基础设施门槛推得更高。

## 今天怎么看

今天看 Transformer，最重要的不是记住原始结构细节，而是理解它为什么成为大模型时代的底层范式：它把上下文建模、并行矩阵计算、可堆叠模块和大规模训练连接到了一起。

仍然重要的部分包括：

- self-attention 作为动态上下文选择机制；
- multi-head attention 作为多视角信息融合机制；
- encoder、decoder、encoder-decoder 三类结构对应不同产品任务；
- 并行训练带来的规模化红利；
- 长距离依赖从“多步传递”变成“直接连接”的思路。

已经被后续工作改造或替代的部分包括：

- 原始正弦 positional encoding 在很多大模型中被 RoPE、相对位置等方案替代或扩展；
- 原论文的机器翻译训练规模，已远小于今天的预训练语料和模型参数规模；
- 原始 encoder-decoder 不是所有生成式 AI 产品的默认选择，decoder-only 在通用聊天、代码生成、Agent 场景中更常见；
- 标准全量 attention 在超长上下文场景中常被各种高效注意力和检索策略补强。

对 AI 产品经理来说，Transformer 更像一个“技术路线分水岭”：它解释了为什么现代模型可以通过更多数据、更多参数、更多算力持续变强，也提醒我们不要把“模型能看很长上下文”误解为“模型必然会正确使用所有上下文”。规模化提供上限，产品化仍要靠任务设计、数据治理、评估体系、成本控制和用户反馈闭环。

## 理解检查

1. 如果向非技术同事解释 self-attention，你会如何说明“每个 token 都能直接看见其他 token”？这个机制为什么有利于处理长距离依赖？
2. Multi-head attention 相比单个 attention head，多出的价值是什么？为什么不能简单把它理解成“更多 head 一定更好”？
3. Transformer 去掉 RNN 后，为什么必须加入 positional encoding？如果没有位置信息，模型会在哪些语言场景中出问题？
4. Transformer 的训练为什么更适合 GPU/TPU 并行？这种训练优势和推理阶段逐 token 生成之间有什么区别？
5. 从产品选型角度看，encoder、decoder-only、encoder-decoder 分别更适合哪些任务？请各举一个产品例子。

## 延伸阅读

- 原论文：Ashish Vaswani 等，Attention Is All You Need，https://arxiv.org/abs/1706.03762
- 早期 attention 代表工作：Bahdanau, Cho, Bengio，Neural Machine Translation by Jointly Learning to Align and Translate，https://arxiv.org/abs/1409.0473
- BERT：Devlin 等，BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding，https://arxiv.org/abs/1810.04805
- GPT-1：Radford 等，Improving Language Understanding by Generative Pre-Training，https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf
- T5：Raffel 等，Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer，https://arxiv.org/abs/1910.10683
- RoPE：Su 等，RoFormer: Enhanced Transformer with Rotary Position Embedding，https://arxiv.org/abs/2104.09864
