require 'byebug'

class HeightMap
  def initialize(rows)
    @rows = rows
    @num_rows = rows.size
    @num_cols = rows.first.size

    @basins = Array.new(@num_rows) { |_| Array.new(@num_cols) }
  end

  def low_points
    result = []
    @rows.each_with_index do |row, i|
      row.each_with_index do |val, j|
        result << [i,j] if (is_low_point?(i, j))
      end
    end

    result
  end

  def fill_basins
    basin_id = 0

    @rows.each_with_index do |row, i|
      row.each_with_index do |val, j|
        next if val == 9
        next if @basins[i][j]

        fill(i, j, basin_id)
        basin_id += 1
      end
    end


    num_basins = basin_id
    flattened_basins = @basins.flatten
    basin_sizes = (0 ... num_basins).map do |basin_id|
      flattened_basins.count { |id| id == basin_id }
    end

    basin_sizes.sort.reverse.take(3).reduce(:*)
  end

  def get(i, j)
    @rows[i][j]
  end

  private
  def fill(i, j, basin_id)
    return if get(i, j) == 9
    return if @basins[i][j]

    @basins[i][j] = basin_id

    fill(i - 1, j, basin_id) if i > 0
    fill(i + 1, j, basin_id) if i < @num_rows - 1
    fill(i, j - 1, basin_id) if j > 0
    fill(i, j + 1, basin_id) if j < @num_cols - 1
  end

  def is_low_point?(i, j)
    cmp = []
    if i > 0
      cmp << (get(i, j) <=> get(i - 1, j))
    end

    if i < @num_rows - 1
      cmp << (get(i, j) <=> get(i + 1, j))
    end

    if j > 0
      cmp << (get(i, j) <=> get(i, j - 1))
    end

    if j < @num_cols - 1
      cmp << (get(i, j) <=> get(i, j + 1))
    end

    cmp.all? { |x| x == -1 }
  end
end

def board_input
  rows = ARGF.read.split("\n")
  rows.map { |row| row.chars.map(&:to_i) }
end


def part1(h)
  low_points = h.low_points
  risk_levels = low_points.map { |i, j| 1 + h.get(i, j) }
  total_risk_level = risk_levels.sum
  puts "Sum of risk levels: #{total_risk_level}"
end


def part2(h)
  result = h.fill_basins
  puts "Product of 3 largest basins: #{product}"
end

rows = board_input
h = HeightMap.new(rows)
# part1(h)
part2(h)
