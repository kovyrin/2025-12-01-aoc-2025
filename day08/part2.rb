#!/usr/bin/env ruby
# frozen_string_literal: true

require 'active_support/all'

class Point
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def distance_to(p2)
    Math.sqrt((p2.x - x)**2 + (p2.y - y)**2 + (p2.z - z)**2)
  end

  def to_s
    "#{x},#{y},#{z}"
  end
end

def discover_connections(connections:, start:, visited: Set.new)
  visited << start

  # Discover all the points connected to the neighbours
  connections[start].each do |p|
    discover_connections(connections:, start: p, visited:) unless visited.include?(p)
  end

  visited
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?)

points = data.map do |l|
  x, y, z = l.split(',').map(&:to_i)
  Point.new(x, y, z)
end

count = points.count
distances = []

0.upto(count - 2) do |p1|
  (p1 + 1).upto(count - 1) do |p2|
    d = points[p1].distance_to(points[p2])
    distances << { p1:, p2:, d: }
  end
end

distances.sort_by! { |d| d[:d] }

connections = Hash.new { |hash, key| hash[key] = Set.new }

distances.each do |x|
  p1 = points[x[:p1]]
  p2 = points[x[:p2]]

  # Connect these two points
  connections[p1] << p2
  connections[p2] << p1

  # Start from p1 and discover all transitive connections
  connected = discover_connections(connections:, start: p1)

  # We stop only on a fully connected graph
  next unless connected.count == points.count

  puts "Fully connected by #{p1} <--> #{p2}"
  puts "  x*x = #{p1.x * p2.x}"
  break
end

# Fully connected by 26707,99946,11535 <--> 27126,85196,7192
# x * x = 724_454_082
