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

def paint_cluster(p, cluster, clusters, connections)
  clusters[p] = cluster

  # Paint all connected points with the same cluster
  connections[p].each do |connected_p|
    paint_cluster(connected_p, cluster, clusters, connections) if clusters[connected_p].nil?
  end
end

input_type = ENV['REAL'] ? 'real' : 'test'
input_file = File.join(__dir__, 'data', "input-#{input_type}.txt")
data = File.readlines(input_file).reject(&:blank?)
min_count = input_type == 'real' ? 1000 : 10

points = data.map do |l|
  x, y, z = l.split(',').map(&:to_i)
  Point.new(x, y, z)
end

count = points.count
min_distances = []

0.upto(count - 2) do |p1|
  (p1 + 1).upto(count - 1) do |p2|
    d = points[p1].distance_to(points[p2])
    min_distances << { p1:, p2:, d: }
  end
end

# Keep lowest N
min_distances.sort_by! { |d| d[:d] }
min_distances = min_distances[0...min_count]

connections = Hash.new { |hash, key| hash[key] = Set.new }
clusters = {}

min_distances.each do |x|
  p1 = points[x[:p1]]
  p2 = points[x[:p2]]

  # Create a map of all the connections
  connections[p1] << p2
  connections[p2] << p1

  # Initialize the list of clusters
  clusters[p1] = nil
  clusters[p2] = nil
end

current_cluster = 0
while clusters.values.any?(&:nil?)
  # Pick the first point for which we have not determined a cluster
  p = clusters.select { |_, c| c.nil? }.keys.first

  paint_cluster(p, current_cluster, clusters, connections)
  current_cluster += 1
end

top_clusters = clusters.values.group_by { |v| v }.values.map(&:count).sort.reverse[0...3]
product = top_clusters.reduce(1) { |product, n| product * n }
puts "Cluster sizes: #{top_clusters}, product: #{product}"

# 66912
