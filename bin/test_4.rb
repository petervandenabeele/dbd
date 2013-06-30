#!/usr/bin/env ruby

count = ARGV[0].to_i
unless count > 0
  puts "Give a 'count' as first argument."
  exit(1)
end

require 'csv'

row_data = [
  "59ffbb3b-1e48-4c1f-81d8-d93afc84c966",
  "2013-06-28 19:14:55.975000806 UTC",
  "a11f290e-c441-41bc-8b8c-4e6c27b1b6fc",
  "c73e6241-d46f-4952-8377-c11372346d15",
  "test",
  "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 0"]

puts "starting CSV.open"

start_time = Time.now

csv_string = CSV.generate(force_quotes: true) do |csv|
  count.times do
    csv << row_data
  end
end

puts "CSV.open took #{Time.now - start_time} seconds"
