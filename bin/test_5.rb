#!/usr/bin/env ruby

# This implementation now streams to disk.

FACTS_PER_RESOURCE = 1000

count = ARGV[0].to_i
unless count > 0
  puts "Give a 'count' as first argument."
  exit(1)
end

filename = ARGV[1]
unless filename
  puts "Give a 'filename' as second argument."
  exit(1)
end

require 'dbd'

start = Time.now

graph = Dbd::Graph.new

(0...count).each do |i|
  provenance_resource = Dbd::ProvenanceResource.new
  provenance_resource << Dbd::Context.new(predicate: "prov:test" , object: "A" * 10)

  resource = Dbd::Resource.new(context_subject: provenance_resource.subject)
  (0...FACTS_PER_RESOURCE).each do |j|
    resource << Dbd::Fact.new(predicate: "test", object: "#{'B' * 80} #{i * FACTS_PER_RESOURCE + j}")
  end

  graph << provenance_resource << resource
  puts ("added resource #{i} to the graph")
end

puts "Graph is ready (took #{Time.now - start}s), now starting the write to disk"

graph.to_CSV_file(filename)
