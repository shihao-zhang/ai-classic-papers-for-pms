#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

catalog_path = File.expand_path("../catalog/papers-season-2.yml", __dir__)
catalog = YAML.load_file(catalog_path)
papers = catalog.fetch("papers")

errors = []

ids = papers.map { |paper| paper["id"] }
expected_ids = (1..papers.length).map { |n| format("s%02d", n) }
errors << "ids must be s01..s#{format('%02d', papers.length)} in order" unless ids == expected_ids

slugs = papers.map { |paper| paper["slug"] }
duplicates = slugs.group_by(&:itself).select { |_slug, values| values.length > 1 }.keys
errors << "duplicate slugs: #{duplicates.join(', ')}" unless duplicates.empty?

required_fields = %w[id slug category category_name short_title title year type paper_url note_path status]
papers.each do |paper|
  required_fields.each do |field|
    value = paper[field]
    errors << "paper #{paper['id']} missing #{field}" if value.nil? || value.to_s.strip.empty?
  end

  note_path = paper["note_path"]
  errors << "paper #{paper['id']} note missing: #{note_path}" unless note_path && File.exist?(File.expand_path("../#{note_path}", __dir__))
end

if errors.empty?
  puts "season-2 catalog ok: #{papers.length} papers"
else
  warn errors.join("\n")
  exit 1
end
