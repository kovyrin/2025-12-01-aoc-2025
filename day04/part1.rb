#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

ROLL = '@'

class Map
  def initialize(data, default = '.')
    @data = data
    @default = default
  end

  def initialize_copy(source)
    super
    @data = @data.clone.map(&:dup)
  end

  def print
    @data.each do |line|
      puts line
    end
  end

  def width
    @data.first.length
  end

  def height
    @data.count
  end

  def out_of_bounds?(x, y)
    return true if x.negative? || y >= width
    return true if y.negative? || y >= height

    false
  end

  def get(x, y)
    out_of_bounds?(x, y) ? @default : @data[y][x]
  end

  def set(x, y, val)
    raise ArgumentError, 'out of bounds' if out_of_bounds?(x, y)

    @data[y][x] = val
  end

  def each_cell
    0.upto(width - 1) do |x|
      0.upto(height - 1) do |y|
        yield(x, y)
      end
    end
  end

  NEIGHBOURS = [-1, 0, +1].freeze

  def each_neighbour(x, y)
    NEIGHBOURS.each do |dx|
      NEIGHBOURS.each do |dy|
        nx = x + dx
        ny = y + dy

        next if nx == x && ny == y
        next if out_of_bounds?(nx, ny)

        yield(nx, ny)
      end
    end
  end
end

def accessible?(map, x, y)
  return false if map.get(x, y) != ROLL

  rolls = 0

  map.each_neighbour(x, y) do |nx, ny|
    rolls += 1 if map.get(nx, ny) == ROLL
  end

  rolls < 4
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")

data = File.readlines(input_file).reject(&:blank?).map(&:strip)
map = Map.new(data)

accessible = 0

result_map = map.clone

map.each_cell do |x, y|
  if accessible?(map, x, y)
    result_map.set(x, y, 'x')
    accessible += 1
  end
end

puts "Accessible: #{accessible}"
result_map.print if input_type == 'test'
