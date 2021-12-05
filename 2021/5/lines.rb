#!/usr/bin/env ruby

require 'byebug'
require 'matrix'

class Segment
  def initialize(head, tail)
    @head = head
    @tail = tail
  end

  attr_reader :head, :tail

  def horz?
    head[1] == tail[1]
  end

  def vert?
    head[0] == tail[0]
  end

  def diag?
    (head[0] - tail[0]).abs == (head[1] - tail[1]).abs
  end

  def translate(dir)
    Segment.new(head - dir, tail - dir)
  end

  def points
    if horz?
      y = head[1]
      x_range.map { |x| [x, y] }
    elsif vert?
      x = head[0]
      y_range.map { |y| [x, y] }
    elsif diag?
      x_range.zip(y_range)
    end
  end

  def inspect
    "Segment((#{head[0]},#{head[1]}) -> (#{tail[0]},#{tail[1]}))"
  end

  private
  def range_dir(start, finish)
    start < finish ? :upto : :downto
  end

  def range(axis)
    dir = range_dir(head[axis], tail[axis])
    head[axis].send(dir, tail[axis]).lazy
  end

  def x_range
    range(0)
  end

  def y_range
    range(1)
  end
end


def parse_coord(coord_string)
  coord_string.split(',').map(&:to_i)
end

def read_input
  ARGF.read.split("\n").map do |line|
    head, tail = line.split(' -> ')
    Segment.new(Vector.elements(parse_coord(head)), Vector.elements(parse_coord(tail)))
  end
end


def compute_bounding_box(segments)
  xs = segments.flat_map { |segment| [segment.head[0], segment.tail[0]] }
  ys = segments.flat_map { |segment| [segment.head[1], segment.tail[1]] }

  [Vector.elements([xs.min, ys.min]), Vector.elements([xs.max, ys.max])]
end

# return rectilinear segments only
def part1_segments(segment)
  segment.horz? || segment.vert?
end

# return rectilinear or diagonal segments
def part2_segments(segment)
  part1_segments(segment) || segment.diag?
end

def print2d(arr)
  puts arr.map { |row| row.join(" ") }.join("\n")
end

def populate_coverage(segments)
  bbox = compute_bounding_box(segments)
  puts "bbox: #{bbox.inspect}"

  origin = bbox[0]
  # change basis so that min bbox element is at (0, 0)
  segments = segments.map { |segment| segment.translate(origin) }

  size = bbox[1] - bbox[0]
  coverage = Array.new(size[0] + 1) { |_| Array.new(size[1] + 1, 0) }

  # Change this to part1_segments to get Part 2
  valid_segments = segments.select(&method(:part2_segments))
  valid_segments.each do |segment|
    puts "Running #{segment.inspect}"
    segment.points.each do |x, y|
      puts "Applying #{x} #{y}"
      coverage[x][y] += 1
    end
  end

  puts "Coverage"
  print2d(coverage)

  coverage
end

def main
  segments = read_input
  puts segments.inspect

  coverage = populate_coverage(segments)
  num_overlaps = coverage.flatten.count { |x| x >= 2 }
  puts "num_overlaps: #{num_overlaps}"
end

main
