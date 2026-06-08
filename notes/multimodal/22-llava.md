# LLaVA：Visual Instruction Tuning

> 分类：多模态与视觉语言  
> 年份：2023  
> 论文：https://arxiv.org/abs/2304.08485  
> 状态：reviewed

## 一句话

LLaVA 把已经会聊天、会听指令的 LLM 接上 CLIP 视觉编码器，并用 GPT-4 生成的图文指令数据训练，让开源模型以相对简单、可复现的方式接近“看图聊天助手”的产品形态。

## 背景问题

在 LLaVA 之前，多模态模型已经能做不少视觉语言任务，比如图像分类、图文检索、图片描述、视觉问答，CLIP、BLIP、Flamingo、BLIP-2 都在推进这个方向。但这些能力通常更像“任务模型”：输入格式固定，输出目标固定，用户很难像和 ChatGPT 一样自由地追问、改问、要求解释。

与此同时，文本 LLM 领域已经证明了 instruction tuning 的价值：用“用户指令 - 助手回答”格式微调模型，可以显著提升模型听懂任务、跟随意图、泛化到新任务的能力。问题是，多模态领域缺少高质量的“图像 + 用户指令 + 助手回答”数据。人工标注很贵，而且很难覆盖真实用户会问的开放问题。

所以 LLaVA 解决的是一个很产品化的问题：如果我们想做一个能看图、能对话、能按用户意图完成视觉任务的通用助手，是否可以复用已有视觉模型、已有 LLM，再用相对便宜的数据管线把它们对齐起来？

## 核心方法

LLaVA 的方法可以拆成三件事：造数据、接模型、分阶段训练。

第一，用 language-only GPT-4 生成视觉指令数据。论文没有让 GPT-4 直接“看图”，而是把图像转成文本线索给 GPT-4：例如 COCO 图片的多条 caption，以及物体类别和 bounding box 位置。GPT-4 根据这些文字化视觉信息生成三类样本：

- conversation：围绕图片进行多轮问答，例如物体、数量、位置、动作。
- detailed description：要求模型细致描述图片。
- complex reasoning：基于图片内容提出需要推理的问题。

最终得到约 158K 条 language-image instruction-following 数据，其中包括约 58K 对话、23K 详细描述、77K 复杂推理样本。这里的关键不是数据规模最大，而是数据形态变了：从“图片配一句文字”变成“用户拿图片来问事，助手按意图回答”。

第二，CLIP vision encoder + LLM。LLaVA 使用预训练 CLIP ViT-L/14 作为视觉编码器，把图片变成一组视觉特征；使用 Vicuna 作为语言模型，负责理解指令和生成回答。产品经理可以把它理解成：

- CLIP 负责“把图片读成机器能处理的视觉 tokens”。
- Vicuna 负责“像聊天助手一样理解问题、组织答案”。
- LLaVA 的工作是让这两套系统说同一种内部语言。

第三，projection layer。CLIP 输出的视觉特征不能直接喂给 LLM，因为它们不在同一个表示空间里。LLaVA 在两者之间加了一个很简单的线性 projection layer，把视觉特征映射成与 LLM word embedding 维度一致的“视觉词元”。这样，LLM 接收到的序列里既有文本 token，也有由图片转换来的视觉 token。

这个设计的取舍很清楚：projection layer 很轻，训练和迭代快，也便于开源社区复现；但它表达能力有限，不如 Flamingo 的 gated cross-attention 或 BLIP-2 的 Q-Former 那样复杂。LLaVA 选择了一个足够有效、足够简单、足够可扩散的工程路线。

训练分两阶段：

1. Feature alignment 预训练：用过滤后的 CC3M 图文对训练 projection layer，冻结 CLIP 和 LLM。目的不是让模型学会高级推理，而是先学会“视觉特征怎么对齐到语言模型可理解的空间”。
2. End-to-end fine-tuning：继续冻结视觉编码器，更新 projection layer 和 LLM。一个版本用 LLaVA-Instruct-158K 做视觉聊天；另一个版本在 ScienceQA 上做科学问答。

所谓 visual instruction tuning，就是把 instruction tuning 从纯文本场景扩展到“图像 + 文本指令”的场景。它不是单纯让模型会描述图片，而是让模型学会：看到同一张图时，面对不同用户指令，应该切换回答方式。

## 为什么经典

LLaVA 经典，不是因为它在所有指标上压倒闭源模型，而是因为它把开源 VLM 的路线讲清楚并跑通了。

第一，它把多模态产品界面从“固定任务 API”推进到“通用视觉助手”。之前很多视觉模型回答的是“这张图是什么”“图文是否匹配”；LLaVA 关心的是“用户想用这张图完成什么任务”。这更接近真实产品里的交互方式。

第二，它证明了数据范式的重要性。模型架构并不复杂，但 visual instruction data 带来了明显提升。论文在 LLaVA-Bench 上显示，没有 instruction tuning 的模型相对分数很低，而加入完整三类指令数据后表现大幅提升。这给行业一个信号：多模态能力不是只靠更大的预训练图文对，后训练数据形态同样关键。

第三，它成为开源 VLM 的重要起点之一。LLaVA 发布了数据、代码、模型和 demo，让社区可以围绕同一条路线快速迭代。后续 LLaVA-1.5、MiniGPT-4、InstructBLIP、Qwen-VL、InternVL 等工作，都在不同程度上延续或回应了“视觉编码器 + LLM + 对齐层 + 指令微调”的范式。

第四，它让“用强模型生成训练数据”在多模态里变得具体可操作。GPT-4 在这里不是最终产品，而是数据生产老师。这个 teacher-student 思路后来成为很多模型后训练和数据合成管线的常见做法。

## 产品经理启发

1. 多模态产品的核心不是“支持图片输入”，而是“图片能参与用户意图”。同一张发票、截图、商品图、医学图像或设计稿，用户可能想总结、定位问题、比较差异、提取字段、给建议。产品需求应围绕任务意图设计，而不是围绕“图片描述”设计。

2. 数据格式决定产品能力边界。只用 caption 数据训练出来的模型，更容易变成“会描述”的模型；用对话、详细描述、复杂推理混合训练，模型才更像助手。做垂直场景 VLM 时，应该优先定义用户会怎么问、好答案长什么样、哪些问题不能答，而不是先堆图片数量。

3. 简单架构也可能是好产品路线。LLaVA 的 projection layer 很朴素，但它让团队快速验证“视觉能力接入 LLM 是否有价值”。产品早期不一定要追最复杂架构，先做出可评估的端到端体验，常常更重要。

4. 开源生态会改变 PM 的选型方式。LLaVA 让很多团队第一次能本地试验 VLM，而不是只能等待闭源 API。PM 在做方案时需要区分：研究 demo、内部工具、商业上线、隐私敏感场景，对模型许可、数据来源、部署成本和安全评估的要求完全不同。

5. 评估要贴近真实任务，不要只看榜单。LLaVA 使用 GPT-4 作为 judge 给开放回答打分，这在当时很实用，但也会引入裁判偏好、不可重复、与真实用户偏好不一致的问题。产品评估应该把自动评测、人类标注、失败案例库和线上反馈结合起来。

## 局限与争议

第一，视觉信息被压缩得很厉害。LLaVA 使用 CLIP 视觉编码器，再通过简单 projection layer 接入 LLM。这个路线适合快速对齐，但对细粒度 OCR、小物体、精确计数、空间关系、高分辨率细节并不天然强。论文自己的例子也指出，模型可能把复杂图像看成“patch 的袋子”，抓不住整体语义。

第二，训练数据有间接性。GPT-4 生成数据时看到的是 caption 和 bounding box 等文本线索，而不是原图本身。这意味着数据质量受已有标注限制：caption 没写到的细节，GPT-4 也很难凭空生成可靠问答；bounding box 能表达对象和大致位置，但不能完整表达文字、品牌、材质、微表情、图表结构等信息。

第三，评估局限明显。LLaVA-Bench 规模较小，例如 COCO 设置下是 30 张图片、90 个问题；In-the-Wild 设置下是 24 张图片、60 个问题。开放问答又依赖 GPT-4 评分，容易受到提示词、裁判模型版本、回答风格偏好影响。85.1% relative score 很有启发性，但不能等同于“真实产品里达到 GPT-4V 85.1% 能力”。

第四，容易过度自信和幻觉。VLM 把视觉感知和语言生成接在一起后，会继承 LLM 的流畅表达能力，也会继承“看不清也编得像”的风险。对于合同截图、医疗影像、质检照片、驾驶场景等高风险任务，必须设计拒答、置信度、人工复核和可追溯证据。

第五，开源不等于可商业自由使用。LLaVA 项目页明确提示，数据、代码和 checkpoint 面向研究用途，并受 CLIP、LLaMA、Vicuna、GPT-4 等组件许可约束，数据也带有非商业限制。PM 不能只看到“开源模型可下载”，还要追踪底座模型、训练数据和衍生权利。

## 今天怎么看

今天看，LLaVA 的具体能力已经被后续 VLM 大幅推进。更强模型通常支持更高分辨率、更强 OCR、更稳定的图表理解、更长上下文、更好的工具调用，也会使用更大规模、更精细的数据和更成熟的安全对齐。LLaVA 原版不应被当作今天生产级多模态助手的能力上限。

但 LLaVA 的思想仍然很重要：

- VLM 产品仍然需要把视觉输入转成可被推理和对话使用的内部表示。
- instruction tuning 仍然是把基础能力变成产品行为的关键步骤。
- 合成数据仍然是冷启动多模态场景的重要手段，但必须配合真实数据和严格评估。
- “视觉编码器 + LLM + 连接层 + 后训练”的模块化思想，仍然是理解很多开源 VLM 的基本框架。

更现实的判断是：LLaVA 是一个“路线标志”，不是一个“终局模型”。它告诉我们开源社区如何从 CLIP 和 LLM 拼出一个可聊天的视觉助手，也提醒我们：真正上线时，数据闭环、评估集、权限许可、错误处理和场景边界，比 demo 里的惊艳回答更重要。

## 理解检查

1. 为什么说 LLaVA 的关键贡献不是”图片描述”，而是 visual instruction tuning？请用一个产品场景举例说明差异。

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 纯 captioning 模型只能输出一种固定格式的描述；instruction tuning 让模型能根据不同指令切换回答方式
- 同一张发票，用户可以问”列出所有金额”、”这张票有没有异常”、”帮我写报销说明”——只有 instruction tuning 模型能区分任务意图
- 数据形态变化是关键：从”图片配文字”升级为”图片+用户指令+助手回答”三元组

</details>

2. CLIP vision encoder、projection layer、LLM 在 LLaVA 里分别承担什么角色？如果 projection layer 对齐不好，用户体验会出现什么问题？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- CLIP vision encoder 把图片编码成视觉特征 token；LLM 理解指令并生成回答；projection layer 负责把视觉特征映射到 LLM 可理解的词元空间
- projection layer 对齐不好：LLM 收到的视觉 token 不在正确表示空间，图片内容无法被正确理解，模型可能忽略图片或产生与图无关的幻觉回答
- 两阶段训练的第一阶段（feature alignment）专门用来解决这个对齐问题

</details>

3. GPT-4 生成视觉指令数据时并没有直接看原图，而是看 caption 和 bounding box 等文本线索。这会带来哪些好处和风险？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 好处：成本低、可规模化生成多样化的对话/推理/描述样本；GPT-4 的语言能力保证问答质量
- 风险：caption 没写到的细节（文字、品牌、材质、微表情）GPT-4 无法生成可靠问答
- 风险：数据质量受已有标注限制，bounding box 只有对象位置，无法覆盖图表结构等信息

</details>

4. LLaVA-Bench 使用 GPT-4 作为 judge 有什么现实价值？为什么它又不能替代真实用户评测？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 现实价值：开放式回答难以用标准答案打分，GPT-4 judge 提供了可自动化的相对质量评估
- 局限：LLaVA-Bench 规模较小（COCO 设置 30 张图/90 问），样本代表性不足
- 局限：GPT-4 judge 的偏好受提示词和模型版本影响，与真实用户偏好、业务验收标准可能不一致

</details>

5. 如果你要把 LLaVA 思路迁移到”电商商品图质检”产品，你会优先补哪些数据、评估和安全机制？

<details>
<summary>参考要点（先自己答，再展开）</summary>

- 数据：收集真实质检场景的”图片+质检指令+标准结论”三元组，覆盖合格/不合格/边界案例
- 评估：不能只看平均分，要针对每类缺陷类型分别测召回率和误报率，设定业务可接受阈值
- 安全：高风险误判必须有人工复核节点，模型输出需附带置信度或不确定性说明，保留审计记录

</details>

## 延伸阅读

- 原论文：Haotian Liu, Chunyuan Li, Qingyang Wu, Yong Jae Lee. [Visual Instruction Tuning](https://arxiv.org/abs/2304.08485), NeurIPS 2023 Oral.
- 项目页：[LLaVA: Large Language and Vision Assistant](https://llava-vl.github.io/)
- 数据与模型：[LLaVA-Instruct-150K / project resources](https://llava-vl.github.io/)
- 后续代表工作：[Improved Baselines with Visual Instruction Tuning / LLaVA-1.5](https://arxiv.org/abs/2310.03744)
- 相关前置工作：[CLIP: Learning Transferable Visual Models From Natural Language Supervision](https://arxiv.org/abs/2103.00020)
- 相关前置工作：[BLIP-2: Bootstrapping Language-Image Pre-training with Frozen Image Encoders and Large Language Models](https://arxiv.org/abs/2301.12597)
- 相关前置工作：[Flamingo: a Visual Language Model for Few-Shot Learning](https://arxiv.org/abs/2204.14198)
