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

class BruteforceDial < Dial
  def turn(command)
    direction = command[0]
    steps = command[1..].to_i
    hit_zero = 0

    sign = direction == 'R' ? 1 : -1
    steps.times do
      @pos += sign
      @pos %= 100
      hit_zero += 1 if pos.zero?
    end

    @zero_count += hit_zero
  end
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?)

fast_dial = Dial.new
bruteforce_dial = BruteforceDial.new

data.each do |command|
  puts '---------------------------'
  puts "Pos: #{fast_dial.pos}, command: #{command}"
  fast_dial.turn(command)
  bruteforce_dial.turn(command)

  puts "  - pos: f:#{fast_dial.pos} / b:#{bruteforce_dial.pos}"
  puts "  - zeroes: f:#{fast_dial.zero_count} / b:#{bruteforce_dial.zero_count}"

  raise 'ERROR! Pos misaligned' if fast_dial.pos != bruteforce_dial.pos
  raise 'ERROR! Zeros misaligned' if fast_dial.zero_count != bruteforce_dial.zero_count
end

puts "Total zeroes: #{fast_dial.zero_count}"

# REAL answer attempts:
# 5524 - too low
# 6386 - correct
