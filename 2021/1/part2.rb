#!/usr/bin/env ruby

input = STDIN.read.split("\n").map(&:to_i)

windows = input.each_cons(3)

windows.each do |a, b, c|
  puts [a, b, c].inspect
end

sums = windows.map { |triple| triple.sum }
puts sums

def num_increments(input)
  gradient = input.each_cons(2).map { |prev, curr| curr <=> prev }
  gradient.count { |x| x > 0 }
end

# gradient = input.each_cons(2).map { |prev, curr| curr <=> prev }
# num_increments = gradient.count { |x| x > 0 }

puts num_increments(sums)
