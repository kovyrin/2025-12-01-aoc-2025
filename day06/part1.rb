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

def calculate_column(col, nums, op)
  numbers = nums.map do |line|
    line[col]
  end

  puts " Calculating #{numbers.join(op)}:"
  result = numbers.shift
  numbers.each do |num|
    result = execute_op(result, num, op)
  end
  puts "   - result: #{result}"

  result
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?).map(&:strip)

ops = data.pop.strip.gsub(' ', '')

nums = data.map do |line|
  line.split(/\s+/).map(&:to_i)
end

puts nums.inspect

width = nums.first.count
result_sum = 0

0.upto(width - 1) do |col|
  result = calculate_column(col, nums, ops[col])
  puts "Column #{col} result (op=#{ops[col]}): #{result}"
  result_sum += result
end

puts "Total: #{result_sum}"
