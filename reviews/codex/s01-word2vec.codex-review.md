## s01 Word2Vec
Verdict: Needs-work
- [High] notes/season-2/foundations/s01-word2vec.md:10 “第一次”把词义相近变成向量距离相近，归因过强；此前 NNLM、LSA 等已能产生带语义关系的向量表示，Word2Vec 的关键是把这件事做到低成本、大规模、行业可复用 → 建议改为“把这种几何语义关系做到了低成本、大规模、可复用”。
- [High] notes/season-2/foundations/s01-word2vec.md:169 延伸阅读直接链接到 `glove.pdf`，违反 review 规范里的“无 PDF”引用边界 → 建议替换为 GloVe 官方项目页或 arXiv/官方非 PDF 页面，或移除该条。
- [Medium] notes/season-2/foundations/s01-word2vec.md:92 “大模型里的 token embedding 是上下文相关的”不准确；输入 token embedding 通常仍是静态查表，上下文相关的是经过模型层后的隐藏表示 → 建议改为“大模型会把静态 token embedding 经过上下文网络转成上下文相关表示”，并同步修正第 103 行。
