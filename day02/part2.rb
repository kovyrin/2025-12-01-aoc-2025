#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def invalid_id?(id)
  s = id.to_s
  len = s.length

  1.upto(len / 2) do |slice_len|
    slice_count = len / slice_len
    slice = s[0...slice_len]
    pattern = slice * slice_count
    return true if pattern == s
  end

  false
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
