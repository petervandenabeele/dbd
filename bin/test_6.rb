#!/usr/bin/env ruby

# This implementation streams from disk

filename = ARGV[0]
unless filename
  puts "Give a 'filename' as argument."
  exit(1)
end

require 'dbd'

start = Time.now

graph = File.open(filename) do |f|
  Dbd::Graph.from_CSV(f)
end

puts "Graph is ready (took #{Time.now - start}s)."

puts "graph.size is #{graph.size}"
