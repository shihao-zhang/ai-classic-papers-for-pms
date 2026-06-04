# AI Classic Papers for Product Managers

面向 AI 产品经理的 36 篇经典论文学习项目。

这个仓库不是论文 PDF 合集，也不是论文摘要搬运。它的目标是把经典论文转化成可复述、可迁移、可用于产品判断的学习材料。

## 在线阅读

直接打开 GitHub Pages：

https://shihao-zhang.github.io/ai-classic-papers-for-pms/

推荐从 [36 篇论文目录](papers.md) 开始读；也可以在本页下面按分类直接点进每篇论文笔记。

## 项目目标

- 用 36 篇经典论文建立 AI 技术演进的基础地图。
- 每篇论文沉淀一份中文导读，保留关键英文术语。
- 关注“这篇论文改变了什么能力边界”，而不是堆公式。
- 用 GitHub Issues 跟踪每篇论文的学习进度。
- 用 Docsify 提供轻量浏览站点。

## 36 篇主清单

主清单来自用户提供的微信原文剪存文档，按以下六组组织：

- 计算机视觉：[AlexNet](notes/computer-vision/01-alexnet.md)、[VGGNet](notes/computer-vision/02-vggnet.md)、[GoogLeNet/Inception](notes/computer-vision/03-googlenet-inception.md)、[ResNet](notes/computer-vision/04-resnet.md)、[U-Net](notes/computer-vision/05-u-net.md)、[Batch Normalization](notes/computer-vision/06-batch-normalization.md)、[Faster R-CNN](notes/computer-vision/07-faster-r-cnn.md)、[YOLO](notes/computer-vision/08-yolo.md)、[MobileNet](notes/computer-vision/09-mobilenet.md)、[EfficientNet](notes/computer-vision/10-efficientnet.md)
- 自然语言处理：[Transformer](notes/nlp/11-transformer.md)、[BERT](notes/nlp/12-bert.md)、[GPT-1](notes/nlp/13-gpt-1.md)、[GPT-2](notes/nlp/14-gpt-2.md)、[RoBERTa](notes/nlp/15-roberta.md)、[T5](notes/nlp/16-t5.md)、[GPT-3](notes/nlp/17-gpt-3.md)
- 多模态与视觉语言：[CLIP](notes/multimodal/18-clip.md)、[DALL-E](notes/multimodal/19-dall-e.md)、[BLIP](notes/multimodal/20-blip.md)、[Flamingo](notes/multimodal/21-flamingo.md)、[LLaVA](notes/multimodal/22-llava.md)、[GPT-4V / The Dawn of LMMs](notes/multimodal/23-gpt-4v-dawn-of-lmms.md)
- 生成模型与扩散：[GAN](notes/generative-models/24-gan.md)、[VAE](notes/generative-models/25-vae.md)、[StyleGAN](notes/generative-models/26-stylegan.md)、[DDPM](notes/generative-models/27-ddpm.md)、[Stable Diffusion / Latent Diffusion Models](notes/generative-models/28-stable-diffusion.md)、[DiT](notes/generative-models/29-dit.md)
- 视觉 Transformer 与自监督：[ViT](notes/vision-transformer-self-supervised/30-vit.md)、[MAE](notes/vision-transformer-self-supervised/31-mae.md)、[SimCLR](notes/vision-transformer-self-supervised/32-simclr.md)、[MoCo](notes/vision-transformer-self-supervised/33-moco.md)
- 强化学习：[DQN](notes/reinforcement-learning/34-dqn.md)、[AlphaGo](notes/reinforcement-learning/35-alphago.md)、[PPO](notes/reinforcement-learning/36-ppo.md)

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

## 本地预览

GitHub Pages 已经可以直接展示站点。本地预览只用于改内容前自查：用任意静态服务器从仓库根目录启动，例如：

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
