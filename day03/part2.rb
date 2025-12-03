#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def jolts_for_bank(bank, length)
  return 0 if length.zero?

  # Slice of the bank that can contain our first battery
  slice_for_start = 0..(bank.count - length)

  # Find the biggest battery we can to serve as the first one
  start = 0
  slice_for_start.each do |pos|
    start = pos if bank[pos] > bank[start]
  end

  bank[start] * (10**(length - 1)) + jolts_for_bank(bank[start + 1..], length - 1)
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?).map { |s| s.strip.split('').map(&:to_i) }

sum = 0

data.each do |batteries|
  jolts = jolts_for_bank(batteries, 12)
  puts "  - #{batteries.join} => #{jolts}"
  sum += jolts
end

puts "Total jolts: #{sum}"
