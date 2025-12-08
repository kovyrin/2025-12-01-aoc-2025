#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
map = File.readlines(input_file).reject(&:blank?)

# We start with a single ray emitted from the position of the S in the first row
rays = { map.first.index('S') => 1 }

# Process all lines one by one
1.upto(map.count - 1) do |line_idx|
  puts "Line #{line_idx} starting with #{rays.values.sum} rays"
  line = map[line_idx]

  new_rays = Hash.new(0)
  rays.each do |pos, count|
    # If we hit a splitter, the ray stops and we emit two other rays
    if line[pos] == '^'
      new_rays[pos - 1] += count
      new_rays[pos + 1] += count
    else
      # Otherwise all the rays at this position continue
      new_rays[pos] += count
    end
  end
  rays = new_rays
  puts " - ended with #{rays.values.sum} rays"
end

puts "Total rays at the end: #{rays.values.sum}"
