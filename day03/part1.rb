#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

def jolts_for_bank(bank)
  b1 = 0
  (b1 + 1).upto(bank.count - 2) do |pos|
    b1 = pos if bank[pos] > bank[b1]
  end

  b2 = b1 + 1
  (b2 + 1).upto(bank.count - 1) do |pos|
    b2 = pos if bank[pos] > bank[b2]
  end

  bank[b1] * 10 + bank[b2]
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?).map { |s| s.strip.split('').map(&:to_i) }

sum = 0

data.each do |batteries|
  jolts = jolts_for_bank(batteries)
  puts "  - #{batteries.join} => #{jolts}"
  sum += jolts
end

puts "Total jolts: #{sum}"
