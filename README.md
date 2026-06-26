# AI Classic Papers for Product Managers

面向 AI 产品经理的经典论文学习项目。项目分两卷：**卷一·能力演进地图**（36 篇，按能力/模态横切）与 **卷二·大模型范式演进**（20 篇，按大模型生命周期纵切）。

这个仓库不是论文 PDF 合集，也不是论文摘要搬运。它的目标是把经典论文转化成可复述、可迁移、可用于产品判断的学习材料。

## 快速入口

- 在线阅读：https://ai-papers.zyxooo.com/
- 卷一目录：[能力演进地图（36 篇）](papers.md)
- 卷二目录：[大模型范式演进（20 篇）](papers-season-2.md)
- 渐进式阅读：[阅读地图](docs/learning-map.md)
- AI 辅助自学：[Guided Learning 提示词](docs/guided-learning.md)
- 分类综述 slides：[NotebookLM Slides 提示词](docs/notebooklm-slides-prompt.md)

## 项目结构

```text
.
├── README.md                    # 项目总览
├── papers.md                    # 卷一目录：36 篇能力演进地图
├── papers-season-2.md           # 卷二目录：20 篇大模型范式演进
├── catalog/                     # 两卷论文清单的结构化数据源
├── docs/                        # Docsify 站点、阅读地图、学习提示词
├── notes/                       # 每篇论文的中文导读
├── reviews/                     # review 记录
├── scripts/                     # 目录与笔记校验脚本
└── templates/                   # 笔记模板
```

## 两卷怎么读

两卷是同一片经典论文的两种视角，不是先后续集。

- **卷一·能力演进地图**：按 CV / NLP / 多模态 / 生成 / 自监督 / RL 横切，回答“AI 能做什么、能力边界如何被经典架构改写”。
- **卷二·大模型范式演进**：按前史、缩放、Infra、数据、对齐、推理/Agent、自博弈纵切，回答“大模型如何被造出来、对齐、跑起来、接入产品系统”。

推荐读法：

1. 想建立 AI 能力全景：先读卷一，再挑卷二补大模型工程与对齐。
2. 正在做 LLM / Agent 产品：先读卷二，再回卷一补视觉、多模态、生成和 RL 的能力边界。
3. 时间有限：先看 [阅读地图](docs/learning-map.md)，按分组读每组 1-2 篇代表论文。

## 卷一·能力演进地图（36 篇）

主清单来自用户提供的微信原文剪存文档，按六组组织：

- 计算机视觉：[AlexNet](notes/computer-vision/01-alexnet.md)、[VGGNet](notes/computer-vision/02-vggnet.md)、[GoogLeNet/Inception](notes/computer-vision/03-googlenet-inception.md)、[ResNet](notes/computer-vision/04-resnet.md)、[U-Net](notes/computer-vision/05-u-net.md)、[Batch Normalization](notes/computer-vision/06-batch-normalization.md)、[Faster R-CNN](notes/computer-vision/07-faster-r-cnn.md)、[YOLO](notes/computer-vision/08-yolo.md)、[MobileNet](notes/computer-vision/09-mobilenet.md)、[EfficientNet](notes/computer-vision/10-efficientnet.md)
- 自然语言处理：[Transformer](notes/nlp/11-transformer.md)、[BERT](notes/nlp/12-bert.md)、[GPT-1](notes/nlp/13-gpt-1.md)、[GPT-2](notes/nlp/14-gpt-2.md)、[RoBERTa](notes/nlp/15-roberta.md)、[T5](notes/nlp/16-t5.md)、[GPT-3](notes/nlp/17-gpt-3.md)
- 多模态与视觉语言：[CLIP](notes/multimodal/18-clip.md)、[DALL-E](notes/multimodal/19-dall-e.md)、[BLIP](notes/multimodal/20-blip.md)、[Flamingo](notes/multimodal/21-flamingo.md)、[LLaVA](notes/multimodal/22-llava.md)、[GPT-4V / The Dawn of LMMs](notes/multimodal/23-gpt-4v-dawn-of-lmms.md)
- 生成模型与扩散：[GAN](notes/generative-models/24-gan.md)、[VAE](notes/generative-models/25-vae.md)、[StyleGAN](notes/generative-models/26-stylegan.md)、[DDPM](notes/generative-models/27-ddpm.md)、[Stable Diffusion / Latent Diffusion Models](notes/generative-models/28-stable-diffusion.md)、[DiT](notes/generative-models/29-dit.md)
- 视觉 Transformer 与自监督：[ViT](notes/vision-transformer-self-supervised/30-vit.md)、[MAE](notes/vision-transformer-self-supervised/31-mae.md)、[SimCLR](notes/vision-transformer-self-supervised/32-simclr.md)、[MoCo](notes/vision-transformer-self-supervised/33-moco.md)
- 强化学习：[DQN](notes/reinforcement-learning/34-dqn.md)、[AlphaGo](notes/reinforcement-learning/35-alphago.md)、[PPO](notes/reinforcement-learning/36-ppo.md)

完整数据源见 [catalog/papers.yml](catalog/papers.yml)。

## 卷二·大模型范式演进（20 篇）

卷二不参与主 36 篇编号，单独使用 `S1` 到 `S20`：

- 序列建模前史：[Word2Vec](notes/season-2/foundations/s01-word2vec.md)、[Seq2Seq](notes/season-2/foundations/s02-seq2seq.md)、[Attention (Bahdanau)](notes/season-2/foundations/s03-attention-nmt.md)、[GNMT](notes/season-2/foundations/s04-gnmt.md)
- 缩放与训练范式：[The Bitter Lesson](notes/season-2/scaling-training/s05-bitter-lesson.md)、[Scaling Laws](notes/season-2/scaling-training/s06-scaling-laws.md)、[Chinchilla](notes/season-2/scaling-training/s07-chinchilla.md)、[Mixture-of-Experts](notes/season-2/scaling-training/s08-mixture-of-experts.md)、[Knowledge Distillation](notes/season-2/scaling-training/s09-knowledge-distillation.md)
- 训练基础设施：[Brook for GPUs](notes/season-2/infrastructure/s10-brook-for-gpus.md)、[ZeRO](notes/season-2/infrastructure/s11-zero.md)、[MegaScale](notes/season-2/infrastructure/s12-megascale.md)
- 数据集与数据治理：[LAION-5B](notes/season-2/data/s13-laion-5b.md)、[RefinedWeb](notes/season-2/data/s14-refinedweb.md)
- 后训练与对齐：[InstructGPT](notes/season-2/post-training-alignment/s15-instructgpt.md)、[LoRA](notes/season-2/post-training-alignment/s16-lora.md)、[Tulu 3](notes/season-2/post-training-alignment/s17-tulu-3.md)
- 推理与 Agent：[Chain-of-Thought](notes/season-2/reasoning-agents/s18-chain-of-thought.md)、[ReAct](notes/season-2/reasoning-agents/s19-react.md)
- 自博弈与强化学习：[AlphaGo Zero](notes/season-2/self-play-rl/s20-alphago-zero.md)

完整数据源见 [catalog/papers-season-2.yml](catalog/papers-season-2.yml)。

## 笔记怎么读

每篇论文笔记都回答同一组问题：

1. 这篇论文一句话讲什么？
2. 它解决了什么历史问题？
3. 核心方法是什么？
4. 为什么它成为经典？
5. 它对 AI 产品经理有什么启发？
6. 今天看有哪些局限、争议或已过时之处？
7. 读完后能否通过 3-5 个理解检查问题？

如果希望有 AI 学习搭子，可以把 [Guided Learning 提示词](docs/guided-learning.md) 复制给自己的 Codex / Claude session，让它围绕单篇、分组或跨卷对比提问。

## 本地预览

公开阅读站点已经可以直接展示内容。本地预览只用于改内容前自查：用任意静态服务器从仓库根目录启动，例如：

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

## 维护说明

- 卷一校验：`ruby scripts/validate_catalog.rb`
- 卷二校验：`ruby scripts/validate_season2.rb`
- 笔记质量规范见 [docs/building-spec.md](docs/building-spec.md)
- 原始扩展候选清单见 [docs/alternative-roadmap.md](docs/alternative-roadmap.md)
