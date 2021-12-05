#!/usr/bin/env ruby

input = STDIN.read.split("\n")

horz = 0
depth = 0
aim = 0

input.each do |cmd|
  direction, amount = cmd.split(" ")
  amount = amount.to_i
  case direction
  when 'forward'
    horz += amount
    depth += aim * amount
  when 'up'
    aim -= amount
  when 'down'
    aim += amount
  end
end

puts "depth: #{depth}"
puts "horz: #{horz}"

product = depth * horz
puts "product: #{product}"
