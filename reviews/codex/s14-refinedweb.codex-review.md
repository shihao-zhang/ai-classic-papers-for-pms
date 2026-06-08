## s14 RefinedWeb
Verdict: Needs-work
- [High] notes/season-2/data/s14-refinedweb.md:10 把 “web data only” 直接写成“Falcon 就是这么训的”，容易误导为 Falcon-7B/40B 只用网页数据；但 RefinedWeb 论文公开的是 1.3B/7.5B web-only 模型，Falcon-40B 官方卡写的是 RefinedWeb enhanced with curated corpora → 建议改为“论文用 1.3B/7.5B RefinedWeb-only 模型证明 web-only 可行；公开 Falcon-7B/40B 则是以 RefinedWeb 为主、叠加 curated corpora 的产品化模型”。
- [High] notes/season-2/data/s14-refinedweb.md:53 同类问题，把“Falcon 系列模型（Falcon-7B、Falcon-40B）”作为 web-only 实验证据 → 建议改成“论文中的 1.3B/7.5B RefinedWeb-only 模型/实验”，并把 Falcon-7B/40B 放到“受 RefinedWeb 启发、以其为主但非纯 web-only”的后续落地里。
