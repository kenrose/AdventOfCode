require 'byebug'
require 'set'

# Different four digit displays
# Each display has random wires for each connection
# Signal wires b and g are on, but it should be c and f
# So either b wire hooked up to c segment / g -> f seg
# or b -> f and g -> c


# You write down the 10 unique patterns you see.
# You then have a four digit number from the display

# Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

def read_input
  lines = ARGF.read.split("\n")
  lines.map do |line|
    readings, output = line.split(' | ')
    { readings: readings.split(' '), output: output.split(' ') }
  end
end


def part1
  special_lengths = Set.new([2, 4, 3, 7])
  input = read_input
  result = input.flat_map do |line|
    line[:output].select { |digit| special_lengths.include?(digit.size)}
  end
  total = result.count
  puts "Number output with length in #{special_lengths}: #{total}"
end


SEGMENTS = {
  1 => 'cf',

  7 => 'acf',

  4 => 'bcdf',

  2 => 'acdeg',
  3 => 'acdfg',
  5 => 'abdfg',

  0 => 'abcefg',
  6 => 'abdefg',
  9 => 'abcdfg',

  8 => 'abcdefg'
}

class String
  def to_set
    self.chars.to_set
  end
end

def compute_lookup(readings)
    mapping = Array.new(10)

    mapping[1] = readings.find { |r| r.length == 2 }.to_set
    mapping[7] = readings.find { |r| r.length == 3 }.to_set
    mapping[4] = readings.find { |r| r.length == 4 }.to_set
    mapping[8] = readings.find { |r| r.length == 7 }.to_set

    # 6 segments: 0, 6, 9
    length_six = readings.select { |r| r.length == 6 }.map(&:to_set)

    # Of the entries with 6 segments, 9 must be the one that has the same segments as 4
    mapping[9] = length_six.find { |s| mapping[4] < s }

    # Of the entries with 6 segments, 6 must be the one that does not have the same segments as 1
    mapping[6] = length_six.find { |s| !(mapping[1] < s) }

    # 0 is the final remaining entry with 6 segments
    mapping[0] = (length_six - [mapping[6]] - [mapping[9]]).first

    # 5 segments: 2, 3, 5
    length_five = readings.select { |r| r.length == 5 }.map(&:to_set)

    # Of the entries with 5 segments, 3 must be the one that has the same segments as 1
    mapping[3] = length_five.find { |s| mapping[1] < s }

    # Of the entries with 5 segments, 5 must have all the same segments as 6
    mapping[5] = length_five.find { |s| s < mapping[6] }
    mapping[2] = (length_five - [mapping[3]] - [mapping[5]]).first


    # mapping[one] = 1
    # mapping[seven] = 7
    # mapping[four] = 4
    # mapping[eight] = 8
    # mapping[nine] = 9

    result = mapping.each_with_index.map { |k,i| [k.sort.join, i] }.to_h

end

def part2
  # Of the entries with 5 segments, 3 must be the one that has the same segments as 1

  # If you know 6, 5 must be a subset of 6

  input = read_input
  total = 0
  input.each do |line|
    lookup = compute_lookup(line[:readings])
    sorted_output = line[:output].map { |s| s.chars.sort.join }
    result = sorted_output.map { |encoded| lookup[encoded] }.map(&:to_s).join
    total += result.to_i
    puts "Deciphered #{line[:output].join(' ')} as #{result}"
  end

  puts "Total: #{total}"
end


part2
