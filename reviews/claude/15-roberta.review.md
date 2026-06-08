# Review Result
Verdict: Pass
Rounds Recommended: 0

## High
- None

## Medium
- None

## Low
- 「核心方法」第 4 点（移除 NSP）说明了 full-sentences 和 doc-sentences 等输入格式，并指出结论与输入格式有关，这是准确的细节处理。可选补充：RoBERTa 最终主要使用 full-sentences（跨文档拼接长文本），doc-sentences 在部分设置下略优但变化较大，论文倾向 full-sentences 作为默认。对 PM 笔记来说当前精度合理。
- 笔记在「局限与争议」中诚实指出结论主要来自英文 NLU 语境，迁移到多语言或生成任务需重新验证，这是必要的范围限定。

## Suggested Edits
1. （无强制编辑，Low 项可选）

---

**核查记录：**
- 结构完整：所有必需章节齐备。
- 事实准确：BERT 原始 ~16GB（BooksCorpus + Wikipedia），RoBERTa 扩展至 ~160GB，batch size 256/2K/8K 对比，dynamic masking 机制，移除 NSP 的实验结论，均正确。
- 无误归属：RoBERTa 正确定位为"训练配方优化，不是新架构"；没有把后续 DeBERTa 等工作的贡献混入。
- PM 启发具体：提出"baseline 是否调好"、"配方优化是产品能力"、"简化目标有时比增加目标好"、"实验设计决定能否相信结论"等有判断价值的点。
- 理解检查：5 道题覆盖 undertrained 证据、dynamic masking、NSP 结论的边界、对照条件检查、训练配方 vs. 换架构，均已补充参考要点。
