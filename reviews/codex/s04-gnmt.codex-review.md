## s04 GNMT
Verdict: Needs-work
- [High] notes/season-2/foundations/s04-gnmt.md:55 “Google 翻译也据此完成了从 SMT 到 NMT 的整体切换”时间线过界；GNMT 发布时是先上线中英等核心语言对，随后逐步扩大 NMT 覆盖，不是论文当下完成全量整体切换 → 建议改为“Google 翻译先在中英等核心语言对上线 GNMT，随后逐步扩大 NMT 覆盖”。
- [High] notes/season-2/foundations/s04-gnmt.md:61 “它贡献了 WordPiece 子词切分”归因不稳；WordPiece 有 2012 年前序，GNMT 的贡献是采用并生产化到大规模 NMT，而非发明该方法 → 建议改为“它把 WordPiece 这类已有子词技术关键性地工程化到生产级 NMT 中”，并同步修正第 89 行“相对原创”的说法。
- [Medium] notes/season-2/foundations/s04-gnmt.md:36 “根本性地缓解”“所有大语言模型”说得太绝对；子词能显著缓解 OOV/罕见词，但不能根治术语误译，现代 LLM 也不都用 WordPiece，而是多种子词或字节级 tokenizer → 建议改为“显著缓解 OOV；多数现代模型采用某种子词或字节级 tokenization，WordPiece 是代表路线之一”。
