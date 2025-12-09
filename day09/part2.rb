#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

day = File.basename(__dir__).sub(/\Aday/, '')
part = File.basename(__FILE__)[/part(\d+)/, 1] || '?'

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?)

puts "Day #{day} part #{part} not implemented yet (loaded #{data.size} lines)"
