#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def invalid_id?(id)
  s = id.to_s
  len = s.length
  half = s[0..(len / 2 - 1)]
  s == half + half
end

def count_invalid_ids(range)
  range.select { |id| invalid_id?(id) }.sum
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).first

ranges = data.split(',').map do |range|
  first, last = range.split('-')
  (first.to_i)..(last.to_i)
end

invalid_sum = ranges.sum do |range|
  count_invalid_ids(range)
end

puts "Invalid sum: #{invalid_sum}"
