#!/usr/bin/env ruby

# This implementation streams from disk
#
# See test_5.rb for usage and basic performance test

filename = ARGV[0]
unless filename
  puts "Give a 'filename' as argument."
  exit(1)
end

require 'dbd'

start = Time.now

graph = Dbd::Graph.new.from_unsorted_CSV_file(filename)

puts "Graph is ready (took #{Time.now - start}s)."

puts "graph.size is #{graph.size}"

puts "first fact is:"
puts graph.first.string_values

puts "last fact is:"
puts graph.last.string_values
