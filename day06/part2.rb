#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def execute_op(n1, n2, op)
  if op == '*'
    n1 * n2
  else
    n1 + n2
  end
end

def calculate(numbers, op)
  numbers = numbers.clone
  result = numbers.shift

  numbers.each do |num|
    result = execute_op(result, num, op)
  end

  result
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?).map(&:rstrip)

# Find positions of each operation, those are aligned with numbers in each problem
ops = data.pop
ops_positions = []
0.upto(ops.length - 1) do |op_pos|
  ops_positions << op_pos if ops[op_pos] != ' '
end

# Pad all data lines to be the same (easier to parse the last problem)
max_len = data.map(&:length).max
data.each do |line|
  next if line.length == max_len

  padding = ' ' * (max_len - line.length)
  line << padding
end

total_sum = 0

ops_count = ops_positions.count
0.upto(ops_count - 1) do |op_idx|
  block_start = ops_positions[op_idx]
  block_end = op_idx < ops_count - 1 ? ops_positions[op_idx + 1] - 2 : max_len - 1

  num_block = data.map { |line| line[block_start..block_end] }
  op = ops[block_start]

  numbers = []
  0.upto(block_end - block_start) do |p|
    number = +''
    num_block.each do |line|
      digit = line[p]
      number << digit
    end
    numbers << number.strip.to_i
  end

  total_sum += calculate(numbers, op)
end

puts "Sum: #{total_sum}"
