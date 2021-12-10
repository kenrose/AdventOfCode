#!/usr/bin/env ruby

require 'byebug'

def read_input
  ARGF.read.split(",").map(&:to_i)
end

def compute_medians(sorted_input)
  half_way = sorted_input.size / 2
  if sorted_input.size % 2 == 0
    [sorted_input[half_way], sorted_input[half_way-1]]
  else
    [sorted_input[half_way]]
  end
end

def fuel_cost_1(input, target)
  input.map { |i| (target - i).abs }.sum
end


# We want the number, x, such that we minimize the following sum
#
#   Sum_{p in positions} |x - p|
#
# That's just the median.
#
# https://math.stackexchange.com/questions/113270/the-median-minimizes-the-sum-of-absolute-deviations-the-ell-1-norm

def part1(positions)
  medians = compute_medians(positions)
  puts "Medians: #{medians}"

  min_fuel_cost = medians.map { |target| fuel_cost_1(positions, target) }.min
  puts "min_fuel_cost: #{min_fuel_cost}"
end


# Returns the cost of moving 'steps' in fuel_cost
def fuel_cost_2(steps)
  steps * (steps + 1) / 2
end

def part2(positions)
  smallest = positions.first
  largest = positions.last
  costs = (smallest .. largest).map do |target|
    positions.map { |position| fuel_cost_2((target - position).abs) }
  end
  sums = costs.map(&:sum)
  puts "sums: #{sums.join(',')}"
  min_fuel_cost = sums.min
  puts "min_fuel_cost: #{min_fuel_cost}"
end

positions = read_input.sort
puts "Have #{positions.size} positions"
puts "Positions: #{positions.join(',')}"

part2(positions)
