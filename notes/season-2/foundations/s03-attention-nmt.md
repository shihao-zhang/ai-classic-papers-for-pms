# Attention (Bahdanau)：Neural Machine Translation by Jointly Learning to Align and Translate

> 分类：序列建模前史  
> 年份：2014  
> 论文：https://arxiv.org/abs/1409.0473  
> 状态：reviewed

## 一句话

Bahdanau 等人发现 Seq2Seq 把整句压成一个定长向量是长句翻译的主要瓶颈，于是让 decoder 在生成每一个目标词时，都能动态地“回看”源句所有位置、按相关性加权地取信息——这就是第一代 attention（注意力）机制；它解决了定长瓶颈，并埋下了后来 Transformer“attention is all you need”的思想种子。但要分清：这里的 attention 是架在 RNN encoder-decoder 之上的对齐模块，**不是** self-attention，也不是 Transformer。

## 背景问题

上一篇 Seq2Seq 用 encoder-decoder 做出了端到端的神经机器翻译，但它有一个致命缺陷：encoder 要把整句源语言压进**一个固定长度的向量**，decoder 只能靠这一个向量重建译文。

这个设计在短句上还行，句子一长就崩。直觉上也好理解：让你读完一整段话、只准记住一个固定大小的“总结”，然后凭这个总结一字不差地翻译出来——句子越长，这个总结越装不下，细节越容易丢。实验也证实了这一点：Seq2Seq 的翻译质量随源句变长而明显下降。

当时的补丁（比如把源句逆序输入）能缓解，但治标不治本。真正的问题是结构性的：**为什么要强迫模型把所有信息都挤进一个固定向量？** 翻译某个具体的目标词时，其实只需要源句里的一小部分相关信息——翻“银行”时该重点看源句里对应的那个词，而不是把整句的总结嚼一遍。能不能让模型在生成每个词时，自己去源句里挑相关的部分看？

## 核心方法

Bahdanau 的解法，是把“一个定长向量装下整句”换成“保留每个源词的表示 + 生成时动态挑选”。

### 1. 不再压成一个向量：保留每个位置的表示

encoder 改用**双向 RNN**（BiRNN）：一个方向从左往右读，一个方向从右往左读，把两个方向的隐藏状态拼起来。这样每个源词位置都得到一个 annotation（标注向量），它既包含这个词本身，也融合了它前后的上下文。

关键变化在于：encoder **不再只输出最后一个向量**，而是输出一整排 annotation——源句有多少个词，就有多少个 annotation，每个都保留着对应位置的信息。整句话不再被压成一个点，而是摊开成一排可供查询的表示。

### 2. attention：生成每个词时，动态算一个“专属”上下文向量

真正的创新在 decoder 这边。decoder 每要生成一个目标词时，不再共用同一个固定向量，而是临时算一个**专属于这一步的 context vector**（上下文向量）：

- 先用一个小网络给每个源位置打一个**对齐分数**（alignment score），衡量“生成当前这个目标词，应该多关注这个源词”；
- 把这些分数归一化成一组权重（加起来为 1）；
- 用这组权重对所有 annotation 加权求和，得到这一步的 context vector。

于是 decoder 生成第一个词时算出一个偏向源句某处的 context，生成第二个词时又算出一个偏向别处的 context——**上下文向量是随每一步动态变化的**，模型自己决定每一步该看源句的哪里。

### 3. 对齐分数怎么算：additive attention

打对齐分数用的是一个小前馈网络，形式大致是“把 decoder 当前状态和某个源 annotation 拼起来，过一个带 tanh 的小网络，输出一个分数”。因为它是用加法把两边信息组合再打分，这种做法后来被称为 **additive attention**（加性注意力），也叫 Bahdanau attention。

这个对齐网络和整个翻译模型一起端到端训练，没有任何人工标注的对齐。论文标题里的 *jointly learning to align and translate* 就是这个意思：**对齐和翻译是一起学出来的**。相比 SMT 里需要专门训练的、硬性的对齐组件，这里的对齐是软的（每个源词都分到一点权重）、可微的、数据驱动的。

### 4. 副产品：可视化的软对齐

因为每一步都有一组对齐权重，把它们画成热力图，就能看到目标词和源词之间的**软对齐**关系。论文展示了即使英语和法语语序不同，模型也能学会在生成某个法语词时正确地对到对应的英语词上。这让 attention 不仅效果好，还带来了一点可解释性。

## 为什么经典

第一，它解决了定长瓶颈。通过让 decoder 每步动态读取源句相关部分，长句翻译质量大幅改善，神经机器翻译从“短句还行”变成“长句也能打”，实用性上了一个台阶。

第二，它把 **attention 这个机制引入了序列建模**。“在一堆信息里，按相关性动态地加权挑选”——这个思想是后来整个 Transformer 时代的核心。可以说，2017 年“attention is all you need”的那个 attention，思想源头之一就在这里。

第三，它用一个软的、可微的、端到端学出来的对齐，替换了 SMT 里硬性的、需要专门设计的对齐组件。这是“用可微模块替换手工组件”这条大思路在对齐问题上的一次漂亮示范。

需要明确的归因边界：本文的 attention 是**架在 RNN encoder-decoder 之上的一个模块**，是 decoder 去看 encoder 的**跨注意力（cross-attention）性质的对齐**。它**不是** self-attention（句子内部每个词互相看），也没有去掉 RNN，更不是把 attention 当成模型的唯一主体。self-attention、multi-head、QKV、彻底去掉循环并行化——这些都是 Transformer（Vaswani 2017）的贡献，**不能回算到本文头上**。

## 产品经理启发

1. **attention 的本质是“在上下文里动态选相关的部分”，这是个可迁移的产品直觉。** 处理长输入时，与其把它压成一个总结，不如保留全部、再按当前任务的需要动态聚焦相关片段。RAG 按问题去检索相关段落、Agent 按任务去调相关记忆，本质上都是这个“动态选相关”的思路。

2. **“保留 + 按需读取”常常优于“提前压缩”。** Seq2Seq 提前把整句压成一个向量，丢了信息；attention 选择保留所有位置、生成时再挑。当你设计的系统要在大量信息里工作时，先别急着压缩——能不能保留细节、把“选哪部分”这件事推迟到真正用的时候，往往是更好的架构。

3. **软对齐给了可解释性，但别神化它。** attention 权重热力图能直观展示“模型翻这个词时在看源句哪里”，是很好的调试和演示信号。但和 Transformer 笔记里的告诫一样：attention 权重不等于因果解释，不能当成“模型为什么这么做”的充分证明，对外展示时要拿捏分寸。

4. **可微、数据驱动的组件，往往比手工规则更可扩展。** Bahdanau 用一个一起训练的小网络学对齐，替掉了 SMT 里要专门设计和训练的对齐模块。做产品时遇到“这一步要不要写一套规则”，可以想想：能不能让它变成一个和主模型一起端到端学出来的可微部分。

5. **看清一个改进解决的是哪个具体瓶颈。** attention 不是“让模型更聪明”这种含糊的好处，它精确地解决了“定长向量装不下长句”这一个瓶颈。评估技术方案时，逼自己说清楚“它到底治好了哪个具体的病”，比笼统地说“效果更好”有用得多。

## 局限与争议

第一，它仍然建立在 RNN 之上。encoder、decoder 都还是循环网络，必须逐词串行计算，训练和推理都慢。attention 在这里是 RNN 的**增强模块**，不是替代——彻底去掉 RNN 是 Transformer 才做的事。

第二，它不是 self-attention。这里的 attention 是 decoder 去看 encoder（跨序列的对齐），不是句子内部 token 之间互相看。把 Bahdanau attention 和 Transformer 的 self-attention 混为一谈，是非常常见的归因错误。

第三，additive attention 的计算开销。要为每一个“目标位置 × 源位置”的组合算一次对齐分数，开销随两边长度的乘积增长。后来 Luong（2015）提出用点积（multiplicative / dot-product）来打分，更简单高效，也是 Transformer 里 scaled dot-product attention 的前身。

第四，对齐的可解释性有边界。软对齐热力图很直观，但它反映的是模型内部的权重分布，不一定等于人类意义上的“正确对齐”或“决策原因”，过度解读会误导。

## 今天怎么看

Bahdanau attention 作为一个 RNN 上的模块，今天已经不再被直接使用——RNN + additive attention 这套组合被 Transformer 的 self-attention 编解码与 cross-attention 体系取代了（注意：encoder-decoder 之间的 cross-attention 仍在，只是不再架在 RNN 上）。但它引入的核心思想，是现代 AI 最重要的概念之一：**注意力，即按相关性动态地加权读取信息**。从 Transformer 的每一层，到 RAG 的检索，到长上下文模型里对历史的关注，本质都是这个思想的延续和放大。读这篇的价值，在于看清 attention 是从哪个具体问题里长出来的，以及它和后来的 self-attention 究竟差在哪。

仍然重要的部分：

- attention 作为“动态选择、加权读取相关信息”的核心机制；
- “保留全部 + 按需读取”相对“提前压缩成一个向量”的优势；
- 软的、可微的、端到端学出来的对齐，替代硬性手工对齐；
- attention 权重提供的（有限的）可解释性。

已经被后续工作改造或替代的部分：

- 作为 RNN 之上的模块，被 Transformer 的 self-attention 与 cross-attention 体系全面取代；
- additive（加性）打分被 scaled dot-product（点积）打分取代；
- 串行的 RNN 主干被可并行的 attention 主干取代；
- 单一对齐被 multi-head 多视角注意力扩展。

## 理解检查

1. Bahdanau attention 要解决的具体瓶颈是什么？它的解法和 Seq2Seq 最大的不同在哪？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 瓶颈：Seq2Seq 把整句压进一个定长向量，长句信息装不下，质量随句长下降
- 解法：encoder 保留每个源位置的 annotation，不再压成一个向量
- decoder 生成每个词时动态算一个专属的 context vector，自己决定该看源句的哪里

</details>

2. “context vector 是随每一步动态变化的”是什么意思？为什么这一点对长句翻译特别关键？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 每生成一个目标词，都按对齐分数对所有源 annotation 重新加权求和，得到一个新的上下文向量
- 模型每一步只聚焦源句里与当前词相关的小部分，而非嚼一遍整句总结
- 长句里相关信息分散，动态聚焦避免了定长向量把所有细节挤压丢失

</details>

3. 为什么说 Bahdanau attention 是 attention 思想的源头之一，但又必须强调它“不是 self-attention、不是 Transformer”？这两者的界线在哪？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 它引入了“按相关性动态加权读取信息”的核心思想，是后来 attention 路线的种子
- 但它是架在 RNN 之上的模块，是 decoder 去看 encoder 的跨注意力对齐
- self-attention（句内互看）、去掉 RNN、并行、multi-head/QKV 都是 Transformer 的贡献，不能回算给本文

</details>

4. attention 权重的软对齐热力图能用来做什么、不能用来做什么？对产品意味着什么？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 能做：直观展示“翻这个词时模型在看源句哪里”，是好的调试和演示信号
- 不能做：不等于因果解释，不能当成“模型为什么这么判断”的充分证明
- 产品上可作辅助信号，但对外展示要拿捏分寸，避免过度解读

</details>

5. 从“保留全部 + 按需读取”这个角度，Bahdanau attention 和今天的 RAG 有什么相通之处？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 两者都拒绝把信息提前压成一个固定总结，而是保留全部、按当前需要动态挑选相关部分
- attention 按对齐分数加权读源句；RAG 按问题相关性检索文档片段
- 共同直觉：把“选哪部分”推迟到真正使用时，比提前压缩更不丢信息

</details>

## 延伸阅读

- 原论文：Bahdanau、Cho、Bengio，Neural Machine Translation by Jointly Learning to Align and Translate，https://arxiv.org/abs/1409.0473
- 前序瓶颈来源：Sutskever、Vinyals、Le，Sequence to Sequence Learning with Neural Networks，https://arxiv.org/abs/1409.3215
- 后续代表工作（点积打分变体）：Luong、Pham、Manning，Effective Approaches to Attention-based Neural Machine Translation，https://arxiv.org/abs/1508.04025
- 后续代表工作（把 attention 推到极致）：Vaswani 等，Attention Is All You Need，https://arxiv.org/abs/1706.03762
- 跨卷·延伸（卷一）：[Transformer](../../nlp/11-transformer.md) —— 把 attention 推到极致的后继。
