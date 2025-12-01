#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def execute_turn(turn, dial_pos)
  direction = turn[0]
  steps = turn[1..].to_i

  sign = direction == 'L' ? 1 : -1
  dial_pos += sign * steps
  dial_pos % 100
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?)

dial_pos = 50
zero_count = 0

data.each do |turn|
  dial_pos = execute_turn(turn, dial_pos)
  zero_count += 1 if dial_pos.zero?
end

puts "Total zeroes: #{zero_count}"
