#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def fresh?(id, ranges)
  ranges.any? { |r| r.include?(id) }
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

fresh_count = 0

data.each do |line|
  id = line.to_i
  if fresh?(id, ranges)
    puts "Fresh: #{id}"
    fresh_count += 1
  end
end

puts "Total fresh: #{fresh_count}"
