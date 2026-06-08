#!/usr/bin/env ruby
# frozen_string_literal: true

# Generate season-2 note skeletons from templates/paper-note.md.
# Idempotent: existing note files are left untouched (never overwrites content).

require "yaml"
require "fileutils"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

root = File.expand_path("..", __dir__)
catalog = YAML.load_file(File.join(root, "catalog/papers-season-2.yml"))
template = File.read(File.join(root, "templates/paper-note.md"))

created = []
skipped = []

catalog.fetch("papers").each do |paper|
  path = File.join(root, paper.fetch("note_path"))
  if File.exist?(path)
    skipped << paper["note_path"]
    next
  end

  body = template.dup
  body = body.gsub("{{short_title}}", paper["short_title"].to_s)
  body = body.gsub("{{title}}", paper["title"].to_s)
  body = body.gsub("{{category_name}}", paper["category_name"].to_s)
  body = body.gsub("{{year}}", paper["year"].to_s)
  body = body.gsub("{{paper_url}}", paper["paper_url"].to_s)
  body = body.sub("> 状态：draft", "> 状态：#{paper['status']}")

  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, body)
  created << paper["note_path"]
end

puts "created #{created.length} skeleton(s):"
created.each { |p| puts "  + #{p}" }
unless skipped.empty?
  puts "skipped #{skipped.length} existing note(s):"
  skipped.each { |p| puts "  = #{p}" }
end
