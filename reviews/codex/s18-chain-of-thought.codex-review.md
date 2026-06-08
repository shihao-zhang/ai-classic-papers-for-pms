## s18 Chain-of-Thought
Verdict: Needs-work
- [High] notes/season-2/reasoning-agents/s18-chain-of-thought.md:48 “大约百亿参数级别以上”低估了论文强调的规模门槛；原论文更接近“约 100B/千亿参数级模型才明显涌现” → 建议改为“约百B/千亿参数级以上，且阈值随模型和任务变化”，并同步改第 144 行。
- [Medium] notes/season-2/reasoning-agents/s18-chain-of-thought.md:60 “不训练、不标注”与原始 CoT 需要少量手写 few-shot 推理范例不一致 → 建议改为“不做模型训练、不需要大规模标注，只需少量人工写好的推理示范”。

---
## 维护者核实（Claude）
Verdict: Reviewed-Pass-with-fixes。两条均核实属实并已修：①line 48/144 涌现门槛“百亿” → “千亿 / 约 100B 以上，阈值随模型与任务而变”；②line 60 补“只需少量人工写好的推理示范”，与原始 few-shot CoT 一致。
