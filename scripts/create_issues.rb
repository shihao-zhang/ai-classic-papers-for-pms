#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "shellwords"

catalog = YAML.load_file(File.expand_path("../catalog/papers.yml", __dir__))

catalog.fetch("papers").each do |paper|
  title = "[Paper] #{paper['id']}. #{paper['short_title']}"
  labels = ["paper", paper["category"], "status:not-started"].join(",")
  body = <<~BODY
    ## Paper

    #{paper['short_title']} — #{paper['title']} (#{paper['year']})

    #{paper['paper_url']}

    ## Note

    #{paper['note_path']}

    ## Learning goal

    Understand what this paper changed, why it became canonical, and what it teaches an AI product manager.

    ## Done when

    - [ ] Note has all required sections.
    - [ ] Product manager insights are concrete.
    - [ ] Understanding checks are useful.
    - [ ] No High/Medium review findings remain.
  BODY

  command = [
    "gh", "issue", "create",
    "--title", title,
    "--label", labels,
    "--body", body
  ]

  puts command.shelljoin
end
