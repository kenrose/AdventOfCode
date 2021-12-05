#!/usr/bin/env ruby

input = STDIN.read.split("\n")

num_bits = input[0].size
on_freqs = Array.new(num_bits, 0)

input.each do |bin_string|
  bits = bin_string.split('')
  bits.each_with_index do |bit, i|
    on_freqs[i] += bit.to_i
  end
end

n = input.size
gamma_bin_arr = on_freqs.map { |sum| (sum >= n / 2) ? 1 : 0 }
epsilon_bin_arr = gamma_bin_arr.map { |b| 1 - b }

def bin_array_to_num(bin_arr)
  bin_arr.map(&:to_s).join.to_i(2)
end

puts "n: #{n}"
puts on_freqs.join(",")

gamma = bin_array_to_num(gamma_bin_arr)
epsilon = bin_array_to_num(epsilon_bin_arr)
product = gamma * epsilon

puts "gamma: #{gamma}"
puts "epsilon: #{epsilon}"
puts "product: #{product}"
