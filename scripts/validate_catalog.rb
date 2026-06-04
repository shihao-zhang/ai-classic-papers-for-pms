#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

catalog_path = File.expand_path("../catalog/papers.yml", __dir__)
catalog = YAML.load_file(catalog_path)
papers = catalog.fetch("papers")

errors = []

errors << "expected 36 papers, got #{papers.length}" unless papers.length == 36

ids = papers.map { |paper| paper["id"] }
expected_ids = (1..36).to_a
errors << "ids must be 1..36" unless ids == expected_ids

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
  puts "catalog ok: #{papers.length} papers"
else
  warn errors.join("\n")
  exit 1
end
