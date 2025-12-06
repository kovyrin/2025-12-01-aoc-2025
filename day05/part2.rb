#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def optimize_ranges(ranges)
  max_id = ranges.count - 1

  0.upto(max_id).each do |i1|
    0.upto(max_id).each do |i2|
      next if i1 == i2

      r1 = ranges[i1]
      r2 = ranges[i2]
      next unless r1.overlap?(r2)

      starts = [r1.first, r2.first]
      ends = [r1.last, r2.last]

      merged = ((starts.min)..(ends.max))
      ranges[i1] = merged
      ranges.delete_at(i2)

      return true
    end
  end

  false
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file)

ranges = []
loop do
  line = data.shift
  break if line.blank?

  ends = line.split('-').map(&:to_i)
  ranges << (ends[0]..ends[1])
end

ranges.sort_by(&:first)

# Optimization loop, do not stop until we don't have anything to optimize anymore
puts "Ranges left: #{ranges.count}" while optimize_ranges(ranges)

puts "Optimization complete, #{ranges.count} ranges left"

total_fresh = 0
ranges.each do |range|
  puts "Add: #{range.count}"
  total_fresh += range.count
end

puts "Total fresh: #{total_fresh}"

# 347468726696961 - solution
