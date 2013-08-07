#!/usr/bin/env ruby

# This implementation now streams to disk.
#
# Some performance (ruby 2.0 on MacBook Pro)
# /Users/peter_v/dbd/bin $ time ./test_5.rb 100 t_5_100
# added resource 0 to the graph
# ...
# added resource 99 to the graph
# Graph is ready (took 4.285428s), now starting the write to disk
#
# real  0m8.515s
# user  0m8.331s
# sys 0m0.181s
# ...
# /Users/peter_v/dbd/bin $ time ./test_6.rb t_5_100
# Graph is ready (took 14.455278s).
# graph.size is 100100
#
# real  0m14.922s
# user  0m14.728s
# sys 0m0.189s
#
# From version 0.0.13 with newline escaping, the times went up:
# writing (test_5)
# real  0m11.656s
#
# reading back (test_6)
# real  0m18.442s

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
  context = Dbd::Context.new
  context << Dbd::ContextFact.new(predicate: "prov:test" , object: "A" * 10)

  resource = Dbd::Resource.new(context_subject: context.subject)
  (0...FACTS_PER_RESOURCE).each do |j|
    resource << Dbd::Fact.new(predicate: "test", object: "#{'B' * 75} #{i * FACTS_PER_RESOURCE + j} \n CD")
  end

  graph << context << resource
  puts ("added resource #{i} to the graph")
end

puts "Graph is ready (took #{Time.now - start}s), now starting the write to disk"

graph.to_CSV_file(filename)
