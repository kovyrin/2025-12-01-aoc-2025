#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

class Dial
  attr_reader :pos, :zero_count

  def initialize
    @pos = 50
    @zero_count = 0
  end

  def turn(command)
    direction = command[0]
    steps = command[1..].to_i

    # Normalize the number of rotations, each 100 steps lands us in the same spot while producing one 0-click
    hit_zero = steps.abs / 100
    steps = steps.abs % 100

    starting_pos = pos

    sign = direction == 'R' ? 1 : -1
    @pos += sign * steps

    # Count if we landed on 0
    hit_zero += 1 if pos.zero?

    # We went through 0
    hit_zero += 1 if starting_pos != 0 && pos.negative?
    hit_zero += 1 if pos >= 100

    @zero_count += hit_zero
    @pos %= 100
  end
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?)

fast_dial = Dial.new

data.each do |command|
  fast_dial.turn(command)
end

puts "Total zeroes: #{fast_dial.zero_count}"
