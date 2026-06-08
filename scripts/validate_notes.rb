#!/usr/bin/env ruby
# frozen_string_literal: true

# 笔记结构与账实一致性校验（两卷通用）。
# 在 validate_catalog.rb / validate_season2.rb（校验 catalog 本身）之外，
# 进一步校验每篇笔记正文：
#   1. front-matter 有 `> 状态：<值>`，且值 ∈ {not-started, draft, reviewed}
#   2. 该状态与 catalog 中对应论文的 status 完全一致（账实一致）
#   3. 九个必备小节齐全
#   4. 「理解检查」下至少有一个「参考要点」折叠块
#
# 用法：ruby scripts/validate_notes.rb

require "yaml"

ROOT = File.expand_path("..", __dir__)
VALID_STATUSES = %w[not-started draft reviewed].freeze
REQUIRED_SECTIONS = [
  "## 一句话",
  "## 背景问题",
  "## 核心方法",
  "## 为什么经典",
  "## 产品经理启发",
  "## 局限与争议",
  "## 今天怎么看",
  "## 理解检查",
  "## 延伸阅读"
].freeze
REF_MARKER = "参考要点（先自己答，再展开）"

CATALOGS = {
  "卷一" => "catalog/papers.yml",
  "卷二" => "catalog/papers-season-2.yml"
}.freeze

errors = []
checked = 0

CATALOGS.each do |vol, rel|
  catalog = YAML.load_file(File.join(ROOT, rel))
  catalog.fetch("papers").each do |paper|
    id = paper["id"]
    note_rel = paper["note_path"]
    catalog_status = paper["status"].to_s.strip
    path = File.join(ROOT, note_rel.to_s)

    errors << "[#{vol} #{id}] catalog status 非法: #{catalog_status.inspect}" unless VALID_STATUSES.include?(catalog_status)

    unless note_rel && File.exist?(path)
      errors << "[#{vol} #{id}] 笔记缺失: #{note_rel}"
      next
    end

    checked += 1
    body = File.read(path, encoding: "UTF-8")

    status_line = body.lines.find { |l| l.start_with?("> 状态：") }
    if status_line.nil?
      errors << "[#{vol} #{id}] 缺 front-matter 状态行（> 状态：…）: #{note_rel}"
    else
      note_status = status_line.sub("> 状态：", "").strip
      errors << "[#{vol} #{id}] 状态值非法: #{note_status.inspect} (#{note_rel})" unless VALID_STATUSES.include?(note_status)
      if VALID_STATUSES.include?(note_status) && note_status != catalog_status
        errors << "[#{vol} #{id}] 账实不一致：笔记=#{note_status} ≠ catalog=#{catalog_status} (#{note_rel})"
      end
    end

    REQUIRED_SECTIONS.each do |section|
      errors << "[#{vol} #{id}] 缺小节 #{section} (#{note_rel})" unless body.include?("\n#{section}") || body.start_with?(section)
    end

    errors << "[#{vol} #{id}] 「理解检查」缺参考要点折叠块 (#{note_rel})" unless body.include?(REF_MARKER)
  end
end

if errors.empty?
  puts "notes ok: #{checked} notes（结构齐全、状态合法且与 catalog 一致）"
else
  warn errors.join("\n")
  exit 1
end
