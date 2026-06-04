#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "set"
require "yaml"

repo = ENV.fetch("GITHUB_REPO", "shihao-zhang/ai-classic-papers-for-pms")
root = File.expand_path("..", __dir__)

labels_config = YAML.load_file(File.join(root, ".github", "labels.yml"))
catalog = YAML.load_file(File.join(root, "catalog", "papers.yml"))

def run!(*args)
  puts "$ #{args.join(' ')}"
  ok = system(*args)
  return if ok

  abort "command failed: #{args.join(' ')}"
end

def capture_json!(*args)
  stdout, stderr, status = Open3.capture3(*args)
  return JSON.parse(stdout) if status.success?

  warn stderr unless stderr.empty?
  abort "command failed: #{args.join(' ')}"
end

puts "Syncing labels for #{repo}..."
labels_config.fetch("labels").each do |label|
  run!(
    "gh", "label", "create", label.fetch("name"),
    "--repo", repo,
    "--color", label.fetch("color"),
    "--description", label.fetch("description"),
    "--force"
  )
end

existing_titles = capture_json!(
  "gh", "issue", "list",
  "--repo", repo,
  "--state", "all",
  "--limit", "200",
  "--json", "title"
).map { |issue| issue.fetch("title") }.to_set

created = 0
skipped = 0

puts "Creating missing paper issues..."
catalog.fetch("papers").each do |paper|
  title = "[Paper] #{paper.fetch('id')}. #{paper.fetch('short_title')}"

  if existing_titles.include?(title)
    skipped += 1
    puts "skip existing: #{title}"
    next
  end

  labels = ["paper", paper.fetch("category"), "status:not-started"].join(",")
  body = <<~BODY
    ## Paper

    #{paper.fetch('short_title')} - #{paper.fetch('title')} (#{paper.fetch('year')})

    #{paper.fetch('paper_url')}

    ## Note

    #{paper.fetch('note_path')}

    ## Learning goal

    Understand what this paper changed, why it became canonical, and what it teaches an AI product manager.

    ## Done when

    - [ ] Note has all required sections.
    - [ ] Product manager insights are concrete.
    - [ ] Understanding checks are useful.
    - [ ] No High/Medium review findings remain.
  BODY

  run!(
    "gh", "issue", "create",
    "--repo", repo,
    "--title", title,
    "--label", labels,
    "--body", body
  )
  created += 1
end

puts "Done. Created #{created} issue(s), skipped #{skipped} existing issue(s)."
