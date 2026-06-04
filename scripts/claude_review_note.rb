#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "open3"

note_path = ARGV.fetch(0)
unless File.exist?(note_path)
  warn "note not found: #{note_path}"
  exit 1
end

note = File.read(note_path)
out_dir = File.expand_path("../reviews/claude", __dir__)
FileUtils.mkdir_p(out_dir)

slug = File.basename(note_path, ".md")
out_path = File.join(out_dir, "#{slug}.review.md")

prompt = <<~PROMPT
  你是严格的论文学习笔记审稿人。请审阅下面这篇面向 AI 产品经理的中文论文笔记。

  审稿目标：
  1. 找出事实错误、归因错误、时间线错误或过度外推。
  2. 找出对 AI 产品经理不够具体、太空泛的启发。
  3. 找出结构缺口：是否缺少背景、核心方法、经典性、局限、今天怎么看、理解检查或延伸阅读。
  4. 找出版权/引用风险：是否有大段搬运或不当引用。
  5. 给出是否通过：只有没有 High/Medium 可行动问题时才通过。

  输出格式：
  # Review Result
  Verdict: Pass 或 Fail
  Rounds Recommended: 0 或 1

  ## High
  - 若无，写 None

  ## Medium
  - 若无，写 None

  ## Low
  - 若无，写 None

  ## Suggested Edits
  - 用简洁中文列出建议修改点。若无，写 None

  笔记路径：#{note_path}

  笔记正文：
  #{note}
PROMPT

stdout, stderr, status = Open3.capture3(
  "claude",
  "-p",
  prompt,
  "--model",
  "claude-opus-4-6",
  "--effort",
  "max"
)

File.write(out_path, stdout)

unless status.success?
  warn stderr
  warn stdout
  exit status.exitstatus || 1
end

puts out_path
