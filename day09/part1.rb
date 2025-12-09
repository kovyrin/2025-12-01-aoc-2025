#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
coords = File.readlines(input_file).reject(&:blank?).map(&:strip).map { |l| l.split(',').map(&:to_i) }

max_area = 0

coords.combination(2) do |p1, p2|
  width = (p1[0] - p2[0]).abs + 1
  height = (p1[1] - p2[1]).abs + 1

  area = width * height
  max_area = area if area > max_area
end

puts "Max area: #{max_area}"
