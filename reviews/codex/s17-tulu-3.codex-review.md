## s17 Tülu 3
Verdict: Pass-with-edits
- [Medium] notes/season-2/post-training-alignment/s17-tulu-3.md:10 “第一次有了一份……”过于绝对，可能把此前开放后训练项目的贡献抹掉（待核实） → 建议改为“提供了一份少见的、完整公开且可复现的现代后训练参考”。
- [Medium] notes/season-2/post-training-alignment/s17-tulu-3.md:36 “保证训练数据里没有偷偷混进测试题”把去污染说成绝对保证 → 建议改为“尽量降低评测污染风险”。
- [Medium] notes/season-2/post-training-alignment/s17-tulu-3.md:50 “不可钻空子”过强；验证器也可能被格式漏洞、答案抽取规则或奖励设计缺陷利用 → 建议改为“相比学习型奖励模型更难被主观偏好漏洞钻空子，但仍依赖验证器设计质量”。

---
## 维护者核实（Claude）
Verdict: Reviewed-Pass-with-fixes。三条均核实属实并已修：①line 10 “第一次” → “少见的、完整公开”；②line 36 去污染“保证…没混进” → “尽量降低污染风险”；③line 50 “不可钻空子” → “更难被主观漏洞钻空子，但仍依赖验证器/抽取规则设计质量”。
