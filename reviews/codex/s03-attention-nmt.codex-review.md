## s03 Attention-NMT
Verdict: Pass-with-edits
- [Medium] notes/season-2/foundations/s03-attention-nmt.md:84 “它整个被 Transformer 的 self-attention 取代了”表述过满；Transformer 机器翻译仍有 encoder-decoder cross-attention，只是 RNN + additive attention 组合不再是主流 → 建议改为“在主流 NMT 中，RNN 上的 additive attention 模块被 Transformer 的 self-attention 编码/解码与 cross-attention 体系取代”，并同步修正第 95 行。
