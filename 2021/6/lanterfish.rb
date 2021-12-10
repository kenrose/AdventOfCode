#!/usr/bin/env ruby

require 'byebug'

def read_input
  ARGF.read.split(",").map(&:to_i)
end


def print_input(input)
  input.join(',')
end

def print_hash(hash)
  hash.inspect
end

NUM_DAYS = 256
def part1(input)
  puts "Initial State: #{print_input(input)}"
  (1..NUM_DAYS).each do |day|
    decrement = input.flat_map do |timer|
      if timer == 0
        [6, 8]
      else
        [timer - 1]
      end
    end
    orig, new = decrement.partition { |timer| timer < 8 }

    input = orig + new
    puts "After #{day} days: #{print_input(input)}"
  end

  puts "Total fish: #{input.size}"
end

# Store the results in a map.  The order of the fish doesn't matter, just the counts.
def part2_orig(input)
  puts "Initial State: #{print_input(input)}"

  population_counts = input.group_by { |timer| timer }.map { |timer, ts| [timer, ts.size] }.to_h
  puts "Initial State: #{print_hash(population_counts)}"


  (1..NUM_DAYS).each do |day|
    num_new = population_counts[0]
    decrement = population_counts.map do |timer, count|
      [timer - 1, count]
    end.to_h

    if decrement[-1]
      decrement[6] = 0 unless decrement[6]
      decrement[6] += decrement[-1]
      decrement.delete(-1)
    end

    result = num_new ? decrement.merge({8 => num_new}) : decrement

    population_counts = result
    puts "After #{day} days: #{print_hash(population_counts)}"
  end

  puts "Total fish: #{population_counts.values.sum}"
end


def part2_improved(input)
  puts "Initial State: #{print_input(input)}"

  population_counts = input.group_by { |timer| timer }.map { |timer, ts| [timer, ts.size] }.to_h
  population_counts.default = 0
  puts "Initial State: #{print_hash(population_counts)}"

  (1..NUM_DAYS).each do |day|
    num_new = population_counts[0]

    (1..8).each do |timer|
      population_counts[timer - 1] = population_counts[timer]
    end

    population_counts[6] += num_new
    population_counts[8] = num_new

    puts "After #{day} days: #{print_hash(population_counts)}"
  end

  puts "Total fish: #{population_counts.values.sum}"
end


input = read_input
part2_improved(input)
