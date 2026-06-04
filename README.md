# AI Classic Papers for Product Managers

面向 AI 产品经理的 36 篇经典论文学习项目。

这个仓库不是论文 PDF 合集，也不是论文摘要搬运。它的目标是把经典论文转化成可复述、可迁移、可用于产品判断的学习材料。

## 项目目标

- 用 36 篇经典论文建立 AI 技术演进的基础地图。
- 每篇论文沉淀一份中文导读，保留关键英文术语。
- 关注“这篇论文改变了什么能力边界”，而不是堆公式。
- 用 GitHub Issues 跟踪每篇论文的学习进度。
- 用 Docsify 提供轻量浏览站点。

## 36 篇主清单

主清单来自用户提供的微信原文剪存文档，按以下六组组织：

- 计算机视觉：AlexNet、VGGNet、GoogLeNet/Inception、ResNet、U-Net、Batch Normalization、Faster R-CNN、YOLO、MobileNet、EfficientNet
- 自然语言处理：Transformer、BERT、GPT-1、GPT-2、RoBERTa、T5、GPT-3
- 多模态与视觉语言：CLIP、DALL-E、BLIP、Flamingo、LLaVA、GPT-4V / The Dawn of LMMs
- 生成模型与扩散：GAN、VAE、StyleGAN、DDPM、Stable Diffusion / Latent Diffusion Models、DiT
- 视觉 Transformer 与自监督：ViT、MAE、SimCLR、MoCo
- 强化学习：DQN、AlphaGo、PPO

完整数据源见 [catalog/papers.yml](catalog/papers.yml)。

## 每篇笔记怎么读

每篇论文笔记都回答同一组问题：

1. 这篇论文一句话讲什么？
2. 它解决了什么历史问题？
3. 核心方法是什么？
4. 为什么它成为经典？
5. 它对 AI 产品经理有什么启发？
6. 今天看有哪些局限、争议或已过时之处？
7. 读完后能否通过 3-5 个理解检查问题？

## 浏览站点

本仓库预留 Docsify 站点。用任意静态服务器从仓库根目录预览，例如：

```bash
python3 -m http.server 8080
```

然后访问 `http://localhost:8080`。

## 版权与引用

- 不上传论文 PDF。
- 不大段复制论文、微信文章或社区文章原文。
- 正文以原创解释、学习问题和产品启发为主。
- 引用短句时保留来源链接。
- 本仓库内容采用 CC BY-NC 4.0。

## 扩展路线

用户最初提供的微信剪存清单是本仓库主线。另有一条偏大模型范式、Infra、Agent 的公开节目大纲，作为扩展路线单独保存，不参与 36 篇编号。

见 [docs/alternative-roadmap.md](docs/alternative-roadmap.md)。
