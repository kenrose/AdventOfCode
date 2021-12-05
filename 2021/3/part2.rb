#!/usr/bin/env ruby

require 'byebug'

def compute_on_freqs(report, num_bits)
  on_freqs = Array.new(num_bits, 0)

  report.each do |bin_string|
    bits = bin_string.split('')
    bits.each_with_index do |bit, i|
      on_freqs[i] += bit.to_i
    end
  end

  on_freqs
end

def bin_array_to_num(bin_arr)
  bin_arr.map(&:to_s).join.to_i(2)
end


def compute_oxygen_generator_rating(diagnostic_report)
  available = diagnostic_report
  num_bits = diagnostic_report[0].size
  (0...num_bits).each do |bit_index|
    on_freqs = compute_on_freqs(available, num_bits)
    num_on_bits = on_freqs[bit_index]
    num_off_bits = available.size - num_on_bits
    most_common_value = (num_on_bits >= num_off_bits) ? '1' : '0'

    new_available = available.select { |bin_string| bin_string[bit_index] == most_common_value }
    available = new_available

    break if available.size == 1
  end
  available
end


def compute_co2_scrubber_rating(diagnostic_report)
  available = diagnostic_report
  num_bits = diagnostic_report[0].size
  (0...num_bits).each do |bit_index|
    on_freqs = compute_on_freqs(available, num_bits)
    num_on_bits = on_freqs[bit_index]
    num_off_bits = available.size - num_on_bits
    least_common_value = (num_off_bits <= num_on_bits) ? '0' : '1'

    new_available = available.select { |bin_string| bin_string[bit_index] == least_common_value }
    available = new_available

    break if available.size == 1
  end
  available
end


diagnostic_report = ARGF.read.split("\n")

n = diagnostic_report.size

oxygen_generator_rating_bin_array = compute_oxygen_generator_rating(diagnostic_report)
co2_scrubber_rating_bin_array = compute_co2_scrubber_rating(diagnostic_report)

oxygen_generator_rating = bin_array_to_num(oxygen_generator_rating_bin_array)
co2_scrubber_rating = bin_array_to_num(co2_scrubber_rating_bin_array)

puts "n: #{n}"

puts "oxygen_generator_rating: #{oxygen_generator_rating}"
puts "co2_scrubber_rating: #{co2_scrubber_rating}"
product = oxygen_generator_rating * co2_scrubber_rating
puts "product: #{product}"
