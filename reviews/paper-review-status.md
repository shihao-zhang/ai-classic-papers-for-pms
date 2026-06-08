# Paper Review Status

本表跟踪第一季 36 篇笔记的 review 真实状态。

口径说明（避免"名不副实"）：

- **Claude reviewed**：经过一次独立的 Claude 评审（非作者自评），核对事实、归因红线（不把后续论文贡献误归当前论文）、PM 启发是否具体、理解检查是否有效。逐篇评审结论存档在 `reviews/claude/<n>-<slug>.review.md`。
- 第 26–36 篇（薄笔记深化批次）的评审在 PR #38 完成：起草后逐篇人工审校 + 维护者终审通过；逐篇 `reviews/claude/` 存档待回填。
- 全部 36 篇当前 `status: reviewed`，同时已补齐「理解检查 + 参考要点」折叠块。

| # | Paper | Note | Status | Review 来源 / 存档 |
|---:|---|---|---|---|
| 1 | AlexNet | `notes/computer-vision/01-alexnet.md` | Claude reviewed: Pass | `reviews/claude/01-alexnet.review.md` |
| 2 | VGGNet | `notes/computer-vision/02-vggnet.md` | Claude reviewed: Pass | `reviews/claude/02-vggnet.review.md` |
| 3 | GoogLeNet/Inception | `notes/computer-vision/03-googlenet-inception.md` | Claude reviewed: Pass | `reviews/claude/03-googlenet-inception.review.md` |
| 4 | ResNet | `notes/computer-vision/04-resnet.md` | Claude reviewed: Pass | `reviews/claude/04-resnet.review.md` |
| 5 | U-Net | `notes/computer-vision/05-u-net.md` | Claude reviewed: Pass | `reviews/claude/05-u-net.review.md` |
| 6 | Batch Normalization | `notes/computer-vision/06-batch-normalization.md` | Claude reviewed: Pass | `reviews/claude/06-batch-normalization.review.md` |
| 7 | Faster R-CNN | `notes/computer-vision/07-faster-r-cnn.md` | Claude reviewed: Pass | `reviews/claude/07-faster-r-cnn.review.md` |
| 8 | YOLO | `notes/computer-vision/08-yolo.md` | Claude reviewed: Pass | `reviews/claude/08-yolo.review.md` |
| 9 | MobileNet | `notes/computer-vision/09-mobilenet.md` | Claude reviewed: Pass | `reviews/claude/09-mobilenet.review.md` |
| 10 | EfficientNet | `notes/computer-vision/10-efficientnet.md` | Claude reviewed: Pass | `reviews/claude/10-efficientnet.review.md` |
| 11 | Transformer | `notes/nlp/11-transformer.md` | Claude reviewed: Pass | `reviews/claude/11-transformer.review.md` |
| 12 | BERT | `notes/nlp/12-bert.md` | Claude reviewed: Pass | `reviews/claude/12-bert.review.md` |
| 13 | GPT-1 | `notes/nlp/13-gpt-1.md` | Claude reviewed: Pass | `reviews/claude/13-gpt-1.review.md` |
| 14 | GPT-2 | `notes/nlp/14-gpt-2.md` | Claude reviewed: Pass | `reviews/claude/14-gpt-2.review.md` |
| 15 | RoBERTa | `notes/nlp/15-roberta.md` | Claude reviewed: Pass | `reviews/claude/15-roberta.review.md` |
| 16 | T5 | `notes/nlp/16-t5.md` | Claude reviewed: Pass | `reviews/claude/16-t5.review.md` |
| 17 | GPT-3 | `notes/nlp/17-gpt-3.md` | Claude reviewed: Pass | `reviews/claude/17-gpt-3.review.md` |
| 18 | CLIP | `notes/multimodal/18-clip.md` | Claude reviewed: Pass | `reviews/claude/18-clip.review.md` |
| 19 | DALL-E | `notes/multimodal/19-dall-e.md` | Claude reviewed: Pass | `reviews/claude/19-dall-e.review.md` |
| 20 | BLIP | `notes/multimodal/20-blip.md` | Claude reviewed: Pass | `reviews/claude/20-blip.review.md` |
| 21 | Flamingo | `notes/multimodal/21-flamingo.md` | Claude reviewed: Pass | `reviews/claude/21-flamingo.review.md` |
| 22 | LLaVA | `notes/multimodal/22-llava.md` | Claude reviewed: Pass | `reviews/claude/22-llava.review.md` |
| 23 | GPT-4V / The Dawn of LMMs | `notes/multimodal/23-gpt-4v-dawn-of-lmms.md` | Claude reviewed: Pass | `reviews/claude/23-gpt-4v-dawn-of-lmms.review.md` |
| 24 | GAN | `notes/generative-models/24-gan.md` | Claude reviewed: Pass | `reviews/claude/24-gan.review.md` |
| 25 | VAE | `notes/generative-models/25-vae.md` | Claude reviewed: Pass | `reviews/claude/25-vae.review.md` |
| 26 | StyleGAN | `notes/generative-models/26-stylegan.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 27 | DDPM | `notes/generative-models/27-ddpm.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 28 | Stable Diffusion | `notes/generative-models/28-stable-diffusion.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 29 | DiT | `notes/generative-models/29-dit.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 30 | ViT | `notes/vision-transformer-self-supervised/30-vit.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 31 | MAE | `notes/vision-transformer-self-supervised/31-mae.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 32 | SimCLR | `notes/vision-transformer-self-supervised/32-simclr.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 33 | MoCo | `notes/vision-transformer-self-supervised/33-moco.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 34 | DQN | `notes/reinforcement-learning/34-dqn.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 35 | AlphaGo | `notes/reinforcement-learning/35-alphago.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
| 36 | PPO | `notes/reinforcement-learning/36-ppo.md` | Reviewed (PR #38): Pass | 深化 + 维护者终审；`reviews/claude/` 待回填 |
