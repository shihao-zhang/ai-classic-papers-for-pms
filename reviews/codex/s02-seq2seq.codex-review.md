## s02 Seq2Seq
Verdict: Pass-with-edits
- [Medium] notes/season-2/foundations/s02-seq2seq.md:81 “所有‘给定输入、自回归地逐词生成输出’的模型--包括今天的大语言模型--都站在 Seq2Seq 划定的范式上”归因偏大，容易把 decoder-only LLM 和 encoder-decoder Seq2Seq 混同 → 建议改为“许多输入到输出的生成任务继承了 Seq2Seq 的条件生成思想；T5/翻译这类 encoder-decoder 模型是更直接继承，decoder-only LLM 则通过 prompt 条件化生成延续了部分思想”。

---
## 维护者核实（Claude）
Verdict: Reviewed-Pass-with-fixes。核实属实（归因偏大）：line 81 已区分 encoder-decoder（T5/翻译）直接继承 vs decoder-only 经 prompt 条件化延续。
