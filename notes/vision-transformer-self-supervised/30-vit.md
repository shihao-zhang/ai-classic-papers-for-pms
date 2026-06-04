# ViT：An Image is Worth 16x16 Words

> 分类：视觉 Transformer 与自监督  
> 年份：2020  
> 论文：https://arxiv.org/abs/2010.11929  
> 状态：draft

## 一句话

ViT 证明了：只要有足够大规模的数据和预训练，Transformer 可以把图像切成 patch tokens 来做视觉识别，不必依赖 CNN 作为默认骨干。

## 背景问题

Transformer 在 NLP 中已经证明了强大的并行训练和规模化能力，但计算机视觉仍主要由 CNN 主导。CNN 有很强的图像先验：局部连接、权重共享、平移等变性、多尺度层级结构。这些先验让 CNN 在中小数据上更容易训练。

问题是，大规模数据和算力出现后，视觉任务是否仍必须依赖 CNN 这些手工先验？能不能像文本一样，把图像也变成 token 序列，让 Transformer 学到视觉表示？

ViT 的问题意识就是：在足够大数据下，通用架构能否替代视觉专用架构？

## 核心方法

ViT 的方法非常直接。

第一，把图像切成固定大小 patch，例如 16x16。每个 patch 展平成向量，再通过线性投影变成 token embedding。论文标题里的 “16x16 Words” 就来自这个类比：一个图像 patch 像一句文本里的一个 word token。

第二，加入 position embedding。Transformer 本身不知道 token 的空间位置，因此需要给每个 patch token 加位置信息。

第三，加一个 classification token，类似 BERT 的 `[CLS]` token。经过 Transformer encoder 后，用这个 token 的表示做分类。

第四，使用大规模预训练。ViT 的关键发现是：如果只在中等规模数据上训练，缺少 CNN 先验的 Transformer 表现未必好；但在 JFT 等大规模数据上预训练后，ViT 可以达到甚至超过强 CNN。

ViT 不是自监督论文，原始设定主要是监督预训练和分类微调。但它为后来的 MAE、DINO、CLIP 等视觉预训练路线提供了核心 backbone。

## 为什么经典

ViT 经典，是因为它打破了“视觉必须用 CNN”的默认假设。

它让视觉模型进入 token 化和 Transformer 化阶段。图像从二维网格变成 patch token 序列后，就能与 NLP、多模态、生成模型共享更多架构语言：attention、positional embedding、pretraining、scaling。

它也让规模成为视觉架构选择的关键变量。CNN 的先验在小数据上很有帮助，但当数据足够大时，Transformer 的通用性和可扩展性更突出。这一点对后来的基础模型非常关键。

ViT 还间接推动了视觉与语言的融合。CLIP、Flamingo、LLaVA、GPT-4V 相关路线都受益于视觉表示 token 化，因为图像 token 更容易和文本 token、跨模态 attention 接上。

## 产品经理启发

第一，架构选择取决于数据规模。小数据场景下，强先验模型可能更稳；大数据场景下，通用可扩展架构可能更强。PM 不应孤立比较模型名，而要问训练数据和算力是否匹配。

第二，统一表示会降低跨模态集成成本。ViT 把图像变成 token 序列，让视觉更容易接入语言模型、多模态模型和生成模型。产品上，这意味着“看图说话”“图文检索”“视觉问答”更容易形成统一架构。

第三，预训练是能力平台。ViT 本身是分类模型，但预训练后的表示可以迁移到检测、分割、检索和多模态任务。PM 要区分“一个任务模型”和“一个可复用视觉底座”。

第四，少先验不等于无成本。Transformer 更通用，但通常需要更多数据、算力和正则化。产品选型要看投入回报，而不是追逐最新架构。

## 局限与争议

ViT 对数据规模敏感。在中小数据上，从零训练 ViT 往往不如 CNN 稳定。它减少了视觉先验，也意味着模型必须从数据中学到更多空间结构。

原始 ViT 主要面向图像分类，不直接解决检测、分割和多尺度密集预测。后续 Swin Transformer、DETR、Mask2Former 等工作进一步处理这些任务需求。

ViT 的 token 数随图像分辨率增加而增加，self-attention 计算成本也会变高。高分辨率视觉任务需要窗口 attention、层级结构或其他效率改进。

此外，ViT 的成功依赖大规模预训练数据。数据来源、标注质量、偏差和合规问题，会进入模型能力和产品风险。

## 今天怎么看

今天 ViT 已经是视觉基础模型的重要骨干之一。它不一定在所有场景取代 CNN，但它改变了视觉模型的主流语言：patch、token、attention、pretraining、scaling。

对 PM 来说，读 ViT 不是为了记住 patch size，而是理解一个范式切换：当数据和算力足够大时，通用架构可以吞掉领域专用先验，并让跨模态产品更容易统一。

## 理解检查

1. ViT 为什么要把图像切成 patch tokens？
2. CNN 先验在小数据场景中有什么优势？为什么大数据会改变这个权衡？
3. ViT 与 MAE、CLIP 的关系是什么？哪些贡献不能混为一谈？
4. 图像 token 化对多模态产品有什么意义？
5. 为什么 ViT 不等于所有视觉任务的完整解决方案？

## 延伸阅读

- 原论文：An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale，https://arxiv.org/abs/2010.11929
- 前序架构：Attention Is All You Need，https://arxiv.org/abs/1706.03762
- 后续工作：Masked Autoencoders Are Scalable Vision Learners，https://arxiv.org/abs/2111.06377
- 后续工作：Swin Transformer，https://arxiv.org/abs/2103.14030
