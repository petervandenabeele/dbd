#!/usr/bin/env ruby

# This is a very primitive implementation:
# the CSV is first fully built and only then
# written to disk. Needs to be modified to
# stream to disk.

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
context = Dbd::Context.new
context << Dbd::ContextFact.new(predicate: "prov:test" , object: "A" * 10)

resource = Dbd::Resource.new(context_subject: context.subject)
(0...count).each do |i|
  resource << Dbd::Fact.new(predicate: "test", object: "#{'B' * 80} #{i}")
end

graph = Dbd::Graph.new
graph << context << resource

File.open(filename, 'w') do |f|
  f << graph.to_CSV
end
