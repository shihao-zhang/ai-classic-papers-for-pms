# DiT：Scalable Diffusion Models with Transformers

> 分类：生成模型与扩散  
> 年份：2022  
> 论文：https://arxiv.org/abs/2212.09748  
> 状态：draft

## 一句话

DiT 证明扩散模型的核心去噪骨干不一定必须是 U-Net，也可以换成 Transformer，并且质量会随模型规模和计算量呈现清晰的 scaling behavior。

## 背景问题

扩散模型兴起后，U-Net 成为图像去噪生成的默认骨干。U-Net 很适合多尺度图像任务，能同时处理全局结构和局部细节。但大模型时代已经显示，Transformer 在语言、视觉预训练和多模态中具备很强的规模化能力。

问题是：扩散模型是否也能享受 Transformer 的 scaling 红利？如果把图像 latent 切成 patch tokens，用 Transformer 做 denoising backbone，能否像语言模型一样通过扩大模型和算力持续提升质量？

DiT 的核心目标不是提出一个立即取代所有 U-Net 的产品模型，而是验证一条架构路线：diffusion + Transformer 是否具备可规模化性。

## 核心方法

DiT 建立在 latent diffusion 之上。它先使用预训练 autoencoder 把图像压缩到 latent space，然后在 latent 上训练 diffusion model。这降低了 token 数和计算成本。

与 U-Net 不同，DiT 把 latent 表示切成 patches，每个 patch 变成一个 token。随后用 Transformer block 处理这些 tokens。时间步、类别条件等信息通过 conditioning 机制注入模型。

论文比较了不同 patch size、模型深度、宽度和计算量设置，观察生成质量与 GFLOPs 的关系。核心发现是：随着 DiT 模型变大、计算增加，FID 等质量指标持续改善。这说明 Transformer diffusion backbone 存在类似 scaling law 的行为。

DiT 的训练目标仍是扩散模型的去噪目标；真正变化的是 denoiser 的架构。从产品语言看，DDPM/LDM 定义了“逐步去噪”的任务，DiT 则在问：执行去噪任务的主力网络，能否换成更适合规模化的 Transformer？

## 为什么经典

DiT 经典，是因为它把扩散模型接入了大模型架构趋势。

第一，它挑战了 U-Net 默认地位。U-Net 强在图像归纳偏置和多尺度结构，但 Transformer 强在统一 token 表示、并行计算和规模化。DiT 展示了后者在图像生成中也可行。

第二，它把生成模型质量和计算规模之间的关系显式化。对研究和产品团队来说，这很重要：如果模型可规模化，投入更多算力和参数可能带来可预期收益。

第三，它影响了后续图像和视频生成路线。许多现代生成系统在不同程度上采用 Transformer-like backbone、patch/token 表示或 diffusion transformer 思想。当然，不能把具体系统能力直接归给 DiT，但 DiT 是重要的架构信号。

## 产品经理启发

第一，架构趋势会跨领域迁移。Transformer 从 NLP 走到视觉理解，再走到扩散生成，说明底层可规模化架构会不断扩展边界。PM 不应只按任务类型看技术路线，还要看架构是否具备长期扩展潜力。

第二，scaling behavior 是路线判断依据。一个模型如果变大后收益不稳定，产品投入风险高；如果扩展曲线清晰，团队更容易规划算力、数据和版本节奏。

第三，归纳偏置和规模化能力要权衡。U-Net 带有图像多尺度先验，Transformer 更通用但可能需要更多数据和算力。产品选型要看阶段：小团队和低成本场景未必适合追求最大 DiT。

第四，生成产品的竞争不只在 prompt 层。底层 backbone 决定模型能否扩到更高分辨率、更长视频、更复杂条件和更大数据。PM 需要理解这些底层差异，才能判断供应商能力边界。

## 局限与争议

DiT 的优势依赖规模和算力。小模型或低预算场景下，U-Net 的图像先验可能更划算。不能简单说 Transformer 一定优于 U-Net。

论文主要在图像生成上验证，不能直接外推到所有视频、3D、交互式编辑或实时生成产品。后续系统能力还依赖数据、训练策略、条件控制、采样器和安全层。

DiT 也没有解决扩散模型的所有老问题。采样速度、精细控制、文字生成、身份一致性、版权和安全风险仍然存在。

另外，公众很容易把 DiT 和后续大型视频生成系统绑定。更准确的说法是，DiT 提供了“Transformer diffusion backbone 可规模化”的证据，而不是某个具体产品系统的完整技术说明。

## 今天怎么看

今天看 DiT，重点是理解生成模型的基础架构正在从图像专用 U-Net 走向更通用的 token/Transformer 系统。这个变化和语言模型、多模态模型的趋势一致：一旦任务能被表示成 token 序列，Transformer 就有机会接管核心建模。

但这不意味着 U-Net 过时。很多产品仍会在成本、速度、开源生态和工具链成熟度上选择 U-Net/LDM 路线。DiT 的价值是指向未来扩展方向：更大模型、更统一架构、更强跨模态和时空建模。

对 PM 来说，DiT 是判断生成模型路线图的一把尺：当供应商说自己模型“更可规模化”时，要追问它的 backbone、token 表示、训练数据、计算曲线和采样成本，而不是只看样图。

## 理解检查

1. DiT 相比 U-Net diffusion，核心改变在哪里？
2. 为什么 DiT 要结合 latent diffusion，而不是直接在像素空间切 patch？
3. Scaling behavior 对产品路线规划有什么意义？
4. 哪些后续生成系统思想可以受 DiT 启发，但不能直接归功于 DiT？
5. 在低成本产品场景中，为什么 U-Net 路线仍可能更合适？

## 延伸阅读

- 原论文：William Peebles, Saining Xie，Scalable Diffusion Models with Transformers，https://arxiv.org/abs/2212.09748
- 前序工作：High-Resolution Image Synthesis with Latent Diffusion Models，https://arxiv.org/abs/2112.10752
- 前序工作：An Image is Worth 16x16 Words，https://arxiv.org/abs/2010.11929
- 相关工作：Denoising Diffusion Probabilistic Models，https://arxiv.org/abs/2006.11239
