#!/usr/bin/env ruby

input = STDIN.read.split("\n").map(&:to_i)

gradient = input.each_cons(2).map { |prev, curr| curr <=> prev }
num_increments = gradient.count { |x| x > 0 }

puts num_increments
