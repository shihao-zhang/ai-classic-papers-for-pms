## s16 LoRA
Verdict: Needs-work
- [High] notes/season-2/post-training-alignment/s16-lora.md:57 “一张消费级显卡就能微调出一个定制模型”容易把 QLoRA/量化后的门槛降低回算给 LoRA；LoRA 显著降低可训练参数、优化器状态和 checkpoint 成本，但是否能用消费级显卡取决于基座规模 → 建议改为“LoRA 显著降低微调成本；进一步单卡化通常依赖量化/QLoRA 或较小基座”。
