## s07 Chinchilla
Verdict: Needs-work
- [High] notes/season-2/scaling-training/s07-chinchilla.md:30 “当算力翻倍时，参数量和训练数据量……各放大约一倍”不符合 Chinchilla 的 compute-optimal 缩放关系；训练算力近似正比于 `N x D`，若算力翻倍，参数和 token 若同步增长，应各约放大 `sqrt(2)`，不是各翻倍 → 建议改为“当训练算力按某个倍率增长时，参数量和训练 token 数应以相近倍率增长；例如算力翻倍时，二者各约增长到 1.4 倍”。

---
## 维护者核实（Claude）
Verdict: Reviewed-Pass-with-fixes。核实属实（真·量化错误）：line 30 “算力翻倍 → 参数和数据各翻倍” 改为 “各约放大 1.4 倍（√2）”，并点明训练算力约正比于 参数×数据。这是本轮最关键的硬伤修复。
