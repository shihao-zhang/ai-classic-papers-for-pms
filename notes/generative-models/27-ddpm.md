# DDPM：Denoising Diffusion Probabilistic Models

> 分类：生成模型与扩散  
> 年份：2020  
> 论文：https://arxiv.org/abs/2006.11239  
> 状态：draft

## 一句话

DDPM 把“从噪声一步步去噪生成图像”做成了稳定、可扩展的生成模型路线，让 diffusion model 从理论兴趣重新变成图像生成主流候选。

## 背景问题

在 DDPM 之前，图像生成的明星路线是 GAN。GAN 生成图像锐利，但训练不稳定，容易 mode collapse，也很难给出明确 likelihood。VAE 更稳定、有潜变量解释，但图像常偏模糊。Flow 模型有精确 likelihood，但架构受可逆性约束，设计复杂。

扩散思想并不是 2020 年才出现。更早的工作已经提出通过逐步加噪和反向去噪建模数据分布。但这些方法一度没有成为主流，因为采样慢、生成质量不够突出，也没有形成清晰的工程配方。

DDPM 的关键问题是：能不能用一个简单稳定的训练目标，让模型学会从纯噪声逐步还原高质量图像，并在质量上接近 GAN？

## 核心方法

DDPM 有两个过程：forward process 和 reverse process。

Forward process 是固定的加噪过程。训练时，真实图像会经过很多步，每一步加入一点高斯噪声，直到最后接近纯噪声。这个过程不需要学习，就像把清晰照片逐渐打散。

Reverse process 是要学习的去噪过程。模型从纯噪声开始，逐步预测如何去掉一点噪声，最终还原出图像。核心网络通常是 U-Net denoiser：输入当前带噪图像和时间步 `t`，输出对噪声或去噪方向的估计。

论文的一个重要简化是训练目标。模型可以直接学习预测加入的噪声，用均方误差训练。这让扩散模型训练非常稳定：不像 GAN 那样要平衡 generator 和 discriminator 两个玩家，也不需要担心对抗训练崩掉。

DDPM 还与 score matching 有联系。直观地说，模型学习的是在不同噪声强度下，数据分布应该往哪里“走”才能更像真实图像。每一步去噪都是一个小修正，很多小修正叠加成最终生成。

## 为什么经典

DDPM 经典，是因为它让 diffusion model 重新进入生成模型主舞台。

第一，它展示了扩散模型可以生成高质量图像，并且训练稳定。对研究社区来说，这给了 GAN 之外的强替代路线。

第二，它提供了非常清晰的工程心智：先破坏数据，再学习如何反向修复。这个思路对 PM 很友好，也容易迁移到图像、音频、视频、3D 等生成任务。

第三，它为后续爆发奠定了基础。Improved DDPM、classifier-free guidance、latent diffusion、Stable Diffusion、DiT 等工作，都可以看作在 DDPM 方向上继续解决采样速度、条件控制、算力成本和架构扩展问题。

第四，它改变了生成产品的质量曲线。扩散模型通常比 GAN 更容易覆盖多样性，也更容易接入文本、图像、布局等条件信号。后来文生图产品的兴起，很大程度建立在这条路线之上。

## 产品经理启发

第一，稳定训练是一种产品资产。GAN 的高上限伴随高训练风险；DDPM 的价值在于让生成能力更可复现、更可扩展。对产品团队来说，稳定意味着更可预测的研发周期。

第二，把复杂生成拆成多步修复，可能比一步到位更可靠。DDPM 每一步只做一点去噪，这类似产品里的迭代式生成、逐步 refinement、草稿到成品的工作流。

第三，采样速度和质量是核心权衡。DDPM 原始采样需要很多步，产品上线必须关心延迟、成本和吞吐。后续加速采样方法之所以重要，是因为它们直接决定用户体验。

第四，条件控制决定商业可用性。无条件生成只是技术证明；产品需要文本控制、风格控制、结构控制、局部编辑和安全约束。DDPM 打开了路线，后续产品要补控制层。

## 局限与争议

DDPM 的主要问题是采样慢。相比 GAN 一次前向生成，扩散模型需要多步迭代，早期版本可能需要上百到上千步。这对实时交互和大规模服务是明显成本。

它也不是天然可控。原始 DDPM 主要展示无条件或简单条件生成，复杂文本控制、布局控制、身份一致性和可编辑性需要后续方法。

另一个局限是计算成本。扩散模型训练和采样都可能很贵，尤其在高分辨率像素空间中。Latent Diffusion 之所以重要，正是因为它把扩散搬到更低维的潜空间。

此外，扩散模型生成质量提高后，也带来版权、伪造、偏见和安全风险。模型是否记忆训练样本、是否复制风格、是否生成有害内容，都是产品必须处理的问题。

## 今天怎么看

今天 DDPM 更像扩散模型时代的基础论文，而不是直接拿来上线的完整产品方案。真实产品通常会用更快采样、更强条件控制、更大的数据、更复杂架构和安全层。

但它的核心思想仍在：生成不是一次凭空创造，而是从噪声中逐步恢复结构。这个框架支撑了文生图、图像编辑、视频生成、音频生成和 3D 生成的许多后续工作。

读 DDPM 的价值，是理解为什么扩散模型能替代 GAN 成为许多生成任务的主流：它牺牲了采样速度，换来了训练稳定、覆盖多样性和可扩展条件控制的空间。

## 理解检查

1. DDPM 的 forward process 和 reverse process 分别做什么？
2. 为什么预测噪声这个训练目标能让扩散模型更稳定？
3. DDPM 相比 GAN 的主要产品优势和代价是什么？
4. 为什么原始 DDPM 不等于完整文生图产品？
5. Latent Diffusion 主要解决 DDPM 的哪个成本问题？

## 延伸阅读

- 原论文：Jonathan Ho, Ajay Jain, Pieter Abbeel，Denoising Diffusion Probabilistic Models，https://arxiv.org/abs/2006.11239
- 前序工作：Deep Unsupervised Learning using Nonequilibrium Thermodynamics，https://arxiv.org/abs/1503.03585
- 后续工作：Improved Denoising Diffusion Probabilistic Models，https://arxiv.org/abs/2102.09672
- 后续工作：Denoising Diffusion Implicit Models，https://arxiv.org/abs/2010.02502
- 后续工作：High-Resolution Image Synthesis with Latent Diffusion Models，https://arxiv.org/abs/2112.10752
