# BLIP：BLIP: Bootstrapping Language-Image Pre-training for Unified Vision-Language Understanding and Generation

> 分类：多模态与视觉语言  
> 年份：2022  
> 论文：https://arxiv.org/abs/2201.12086  
> 状态：reviewed

## 一句话

BLIP 把“看图理解”和“看图说话”放进同一套视觉语言预训练框架里，并用模型自己生成和筛选 caption 的方式清洗嘈杂的网页图文数据，让同一个模型能更好地做图文检索、图片描述和视觉问答。

## 背景问题

BLIP 出现前，视觉语言预训练已经被 CLIP、ALIGN、ALBEF、UNITER、OSCAR 等工作推到很高热度。大家大体同意一件事：如果模型能同时看大量图片和文字，它就能学会“图像里的东西”和“人类语言里的概念”如何对齐。

但当时有两个明显卡点。

第一，模型能力常常分裂。以 CLIP 为代表的 encoder-based 模型很擅长理解类任务，例如判断一张图和一句话是否匹配、用文字搜图片、用图片搜文字；但它不天然擅长逐词生成一段 caption。以 encoder-decoder 为代表的生成模型更适合图片描述、视觉问答答案生成，却不一定在检索、匹配这类理解任务上表现最好。产品上看，这像是一个模型会“找图”，另一个模型会“说图”，能力边界不统一。

第二，训练数据又大又脏。网页图片通常带有 alt-text、标题、周边文本，但这些文字未必真的描述图片：可能是广告语、SEO 关键词、文件名、网页导航，甚至和图片关系很弱。简单扩大数据规模当然有效，但如果监督信号本身很吵，模型会学到不稳定甚至错误的图文关联。BLIP 的问题意识是：多模态产品不能只问“数据够不够大”，还要问“图和文的关系是否足够可信”。

## 核心方法

BLIP 的方法可以拆成两部分：一个统一模型架构 MED，以及一个数据自举流程 CapFilt。

### 1. 用 MED 统一理解和生成

MED 全称是 Multimodal mixture of Encoder-Decoder。可以把它理解成一套“同底座、多工作模式”的视觉语言模型。它使用 ViT 作为图像编码器，把图片切成 patch 后编码成视觉 token；文本侧则围绕 BERT 风格的 Transformer 改造出三种功能。

第一种是 unimodal encoder：图片和文字先分别编码，再把两边表示拉到同一个向量空间里。它服务于 Image-Text Contrastive Loss，也就是 ITC。ITC 的目标很直观：真实配对的图和文要靠近，不匹配的图和文要远离。这对图文检索特别重要。

第二种是 image-grounded text encoder：文本编码时通过 cross-attention 看到图像信息，用来判断一段文字和一张图是否真的匹配。它服务于 Image-Text Matching Loss，也就是 ITM。ITM 比 ITC 更细：ITC 像先快速召回候选，ITM 像再认真复核“这句话是不是描述这张图”。

第三种是 image-grounded text decoder：把文本侧改成因果自注意力，让模型按从左到右的方式生成文字。它服务于 Language Modeling Loss，也就是 LM。这个目标让模型能根据图片生成 caption，或在 VQA 中生成答案。

这就是论文标题里 unified vision-language understanding and generation 的含义：同一个预训练框架既能做 understanding，比如 retrieval、matching、reasoning；也能做 generation，比如 image captioning、answer generation。它不是简单把两个模型拼在一起，而是让编码、跨模态交互和生成共享一部分参数，同时保留关键差异。论文中特别强调：文本 encoder 和 decoder 共享 embedding、cross-attention、FFN，但不共享 self-attention，因为理解任务需要双向看完整句子，生成任务需要按顺序预测下一个词。

### 2. 用 CapFilt 清洗 noisy web data

CapFilt 是 Captioning and Filtering 的缩写，也是 BLIP 最有产品味的一点：既然网页文本很脏，就不要完全相信原始网页文本；先让一个模型给图片重新写 caption，再让另一个模型判断哪些图文对靠谱。

流程大致是：

1. 先用已有图文数据预训练一个 MED。
2. 在 COCO 这类小规模高质量人工标注数据上，把 MED 微调成 captioner：输入图片，生成一条合成 caption。
3. 同样在高质量数据上，把 MED 微调成 filter：输入图片和文字，判断两者是否匹配。
4. 对大规模网页图片，captioner 生成 synthetic captions；filter 同时检查原始网页文本和 synthetic captions，把不匹配的图文对剔除。
5. 用过滤后的原始文本、过滤后的合成文本，再加人工标注数据，组成 bootstrapped dataset，重新预训练一个新的 BLIP 模型。

这里的 bootstrapping 不是“无中生有造数据”，而是“用一个还不错的模型改善下一轮训练数据”。captioner 负责补充更像图像描述的文本，filter 负责降低噪声。论文实验还发现，生成 caption 时使用 nucleus sampling 比 beam search 更有效，因为更有多样性的 caption 虽然更冒险，但能带来更多新信息；过于安全、模板化的 caption 对学习帮助有限。

### 3. 下游任务怎么对应

BLIP 在几个典型任务上的使用方式很能说明它的统一性。

图文检索 image-text retrieval：先用 ITC 快速算图文相似度，找出候选；再用 ITM 对候选做更细粒度重排。产品上，这对应“文字搜图”“以图搜文案”“素材库语义搜索”。

图片描述 image captioning：启用 image-grounded text decoder，用 LM 目标生成 caption。产品上，这对应自动生成图片说明、无障碍 alt text、图片素材标注。

视觉问答 VQA：把问题和图片先编码成多模态表示，再生成答案。BLIP 把 VQA 更接近地看成 answer generation，而不是固定答案类别分类，这让它更适合开放式问答。

## 为什么经典

BLIP 经典，不只是因为它在多个 benchmark 上刷新了结果，而是因为它把两个关键判断讲清楚了。

第一，视觉语言模型不能只做“对齐”，还要能“表达”。CLIP 证明了自然语言监督能学到强大的视觉表示，但 CLIP 式对比学习主要回答“这张图和这句话像不像”。BLIP 往前推进了一步：模型不仅要知道图文是否匹配，还要能把视觉内容转成语言。这条线后来影响了更强的多模态助手和视觉语言大模型。

第二，数据治理本身就是模型能力的一部分。BLIP 没有把 noisy web data 当成无法改变的输入，而是把“生成更好的文本”和“过滤不可信文本”做成训练流程。对产品经理来说，这很重要：模型效果不是只由模型结构决定，也由数据生产、清洗、验收闭环决定。

第三，BLIP 展示了一个高效路线：不必每个任务训练一个完全独立模型，而是让一个底座通过不同模式迁移到 retrieval、captioning、VQA、visual reasoning、visual dialog，甚至 zero-shot 迁移到视频语言任务。它把“统一多模态能力层”的工程想象变得更具体。

## 产品经理启发

第一，定义多模态能力时，要区分 understanding 和 generation。理解类能力回答“是否匹配、在哪里、是什么、哪一个更相关”；生成类能力回答“请描述、请解释、请回答、请改写”。很多产品需求表面都叫“看图 AI”，但评估方式完全不同。图文检索要看 recall、precision、排序质量；图片描述要看忠实性、覆盖度、可读性；VQA 要看答案正确性和可解释边界。

第二，不要迷信网页数据规模。BLIP 的教训是：图文对的“关系质量”比单纯样本数更关键。做图片搜索、商品理解、内容审核、相册助手时，数据策略应包括噪声识别、弱标签校验、合成标签、人工抽检，而不是只追求采集更多图片。

第三，合成数据要配过滤器。caption bootstrapping 的价值不在于“模型生成的数据天然正确”，而在于生成器和过滤器形成互相制衡。产品上，如果用模型自动生成图片标签、知识库摘要、客服训练样本，最好同时设计质量判别、置信度阈值、抽样复审和错误回流。

第四，统一模型不等于一个接口包打天下。BLIP 的 MED 共享了很多参数，但仍为理解和生成保留不同 self-attention 机制。产品抽象也类似：可以有统一的多模态底座和平台能力，但在交互、评估、延迟、风控上仍要按任务拆开看。

第五，检索和生成可以互补。图文检索适合高精度找候选，captioning/VQA 适合把候选解释给用户。一个素材管理产品可以先用 retrieval 找到相似图片，再用 caption 或问答解释“为什么这些图相关”；一个电商产品可以先检索商品图，再生成结构化卖点或回答用户关于图片细节的问题。

## 局限与争议

第一，CapFilt 仍然依赖初始模型和人工标注数据。captioner 和 filter 都是在已有高质量数据上微调出来的。如果初始模型对某些物体、文化语境、人群或长尾场景理解不足，生成和过滤都会继承偏差。

第二，过滤器可能制造“看起来干净但更单一”的数据。filter 倾向保留它认为匹配的文本，可能剔除罕见表达、隐喻描述、小众场景，导致数据分布更符合模型已有认知。这是自举方法常见的 confirmation bias 风险。论文也观察到，如果 captioner 和 filter 参数耦合过强，filter 更不容易拒绝 captioner 生成的噪声。

第三，caption 不等于完整视觉理解。一句 caption 通常只覆盖图片中最显眼的对象和关系，容易忽略位置、数量、细粒度属性、文字内容、时间变化和隐含常识。所以用 caption 作为中间监督会提升很多任务，但不能保证模型真正理解图片的全部细节。

第四，BLIP 不是今天意义上的通用多模态对话助手。它能做 captioning、retrieval、VQA 等任务，但还没有后来的大语言模型式长上下文、多轮指令跟随、工具调用和复杂推理能力。把 BLIP 直接当成现代视觉 ChatGPT 会高估它。

第五，benchmark 成绩不等于产品可用。COCO、Flickr30K、VQAv2、NoCaps 等数据集能评估部分能力，但真实产品会遇到截图、票据、医学影像、商品细节、低清图片、恶意提示、版权和隐私等问题。BLIP 的方法论有迁移价值，具体能力仍需按业务场景重测。

## 今天怎么看

今天看，BLIP 更像是从 CLIP 式图文对齐走向多模态生成式助手之间的一座桥。

它的统一理解与生成思想仍然重要。现在的多模态大模型通常也不会只满足于“图文是否匹配”，而是要能看图问答、解释图表、写 caption、生成结构化信息、支持多轮对话。BLIP 早期把这些能力放进一个视觉语言预训练框架，方向是对的。

它的数据自举思想也仍然重要。后来的视觉语言模型、合成数据流程、指令微调数据构造，都离不开“生成候选数据，再筛选、打分、蒸馏、重训”的闭环。只是今天的生成器和过滤器更强，可能由更大的 VLM、LLM、OCR、检测器、规则系统和人工评审共同组成。

但作为模型本身，BLIP 已经不是最前沿的交互底座。BLIP-2 把冻结视觉编码器和冻结大语言模型连接起来，进一步降低训练成本并接上 LLM 能力；Flamingo、LLaVA、GPT-4V 一类工作则把多模态能力推进到少样本学习、指令跟随和通用视觉对话。BLIP 更适合作为理解早期视觉语言预训练路线的经典节点，而不是直接代表今天的完整产品形态。

如果把它放到产品判断里，最该带走的是三句话：第一，理解和生成要分开验收，但底层能力可以统一建设；第二，网页图文数据必须清洗，合成数据必须过滤；第三，多模态产品的核心竞争力往往不是单个 demo，而是持续改进数据和评估闭环的能力。

## 理解检查

1. BLIP 所说的 vision-language understanding 和 generation 分别对应哪些产品能力？为什么只会图文匹配还不够？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- understanding 对应图文检索（文搜图/图搜文）、图文匹配判断，回答"是否匹配/哪个更相关"
- generation 对应图片描述（captioning）、视觉问答答案生成，回答"请描述/请回答"
- 只会匹配无法生成 caption 或回答开放问题，无法满足"解释给用户听"类产品需求

</details>

2. CapFilt 为什么要同时使用 captioner 和 filter？如果只生成 caption、不做过滤，会有什么风险？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- captioner 负责为网页图片补充更像真实描述的合成文本，替代低质量 alt-text
- filter 负责判断图文是否真正匹配，拒绝 captioner 生成的错误或偏离描述
- 只生成不过滤：captioner 本身会犯错，错误 caption 直接进入训练会放大模型偏差

</details>

3. BLIP 为什么让文本 encoder 和 decoder 共享部分参数，但不共享 self-attention 层？这反映了理解任务和生成任务的什么差异？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 理解任务（matching）需要双向 self-attention，能看完整句子的所有词才能判断匹配
- 生成任务（captioning）需要因果 self-attention，只能看前面的词依次预测下一个词
- 共享 embedding、cross-attention、FFN 可以降低参数量、共享视觉语言对齐知识；self-attention 机制差异决定不能共享

</details>

4. 在图文检索、图片描述、VQA 三个任务中，ITC、ITM、LM 分别发挥什么作用？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 图文检索：ITC 快速计算相似度召回候选，ITM 做更细粒度重排，提升检索精度
- 图片描述：LM 目标驱动 image-grounded text decoder 逐词生成 caption
- VQA：把问题和图片编码为多模态表示，再用 LM 生成答案（answer generation 而非固定类别分类）

</details>

5. 如果你要把 BLIP 的思想迁移到一个电商图片理解产品，你会如何设计数据清洗、合成标签和人工验收流程？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 数据清洗参考 CapFilt：先识别商品图与标题/描述是否真正匹配，过滤 SEO 文案、无关关联词
- 合成标签：用已有较好模型为图片生成卖点/属性描述，再用 filter 模型或规则筛除低质量样本
- 人工验收：对过滤后数据抽样人工复检，重点覆盖长尾类目、细粒度属性和敏感类商品

</details>

## 延伸阅读

- 原论文：BLIP: Bootstrapping Language-Image Pre-training for Unified Vision-Language Understanding and Generation, ICML 2022, https://arxiv.org/abs/2201.12086
- 官方代码与模型：https://github.com/salesforce/BLIP
- 前序代表工作：CLIP: Learning Transferable Visual Models From Natural Language Supervision, https://arxiv.org/abs/2103.00020
- 相关前序工作：ALBEF: Align Before Fuse, https://arxiv.org/abs/2107.07651
- 后续代表工作：BLIP-2: Bootstrapping Language-Image Pre-training with Frozen Image Encoders and Large Language Models, https://arxiv.org/abs/2301.12597
- 后续代表工作：LLaVA: Visual Instruction Tuning, https://arxiv.org/abs/2304.08485
