#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
map = File.readlines(input_file).reject(&:blank?)

# We start with a single ray emitted from the position of the S in the first row
rays = [map.first.index('S')]

split_count = 0

# Process all lines one by one
1.upto(map.count - 1) do |line_idx|
  line = map[line_idx]

  new_rays = Set.new
  rays.each do |ray|
    # If we hit a splitter, the ray stops and we emit two other rays
    if line[ray] == '^'
      new_rays << ray - 1
      new_rays << ray + 1
      split_count += 1
    else
      # Otherwise the ray continues
      new_rays << ray
    end
  end
  rays = new_rays
end

puts "Split count: #{split_count}"
