#!/usr/bin/env ruby

require 'byebug'

class Board
  def initialize(rows)
    @rows = rows
    @num_rows = @rows.size
    @num_cols = @rows[1].size
    @marked = Array.new(@num_rows) { Array.new(@num_cols, false) }
    @last_drawn = nil
  end

  def mark(drawn_number)
    flattened_index = @rows.flatten.find_index(drawn_number)
    if flattened_index
      row, col = convert(flattened_index)
      @marked[row][col] = true
      @last_drawn = drawn_number
    end
  end

  def won?
    rows_won? || cols_won?
  end

  def score
    sum = 0
    (0 ... @num_rows).each do |r|
      (0 ... @num_cols).each do |c|
        if !@marked[r][c]
          sum += @rows[r][c]
        end
      end
    end

    sum * @last_drawn
  end

  private
  def convert(flattened_index)
    row = (flattened_index / @num_rows)
    col = (flattened_index % @num_rows)
    [row, col]
  end

  def has_winning_row?(marked_rows)
    !!marked_rows.find_index { |row| row.all? { |x| x } }
  end

  def rows_won?
    has_winning_row?(@marked)
  end

  def cols_won?
    has_winning_row?(@marked.transpose)
  end
end

input_data = ARGF.read.split("\n")

numbers = input_data.shift.split(',').map(&:to_i)

puts numbers

puts input_data

boards = input_data.each_slice(6).map do |data|
  board_rows = data[1..-1].map { |line| line.split(" ").map(&:to_i) }
  Board.new(board_rows)
end

def part1(numbers, boards)
  numbers.each do |number|
    boards.each do |board|
      board.mark(number)
    end

    winning_board_index = boards.find_index { |board| board.won? }
    if winning_board_index
      puts "Board #{winning_board_index} won after playing #{number}"
      puts "Score: #{boards[winning_board_index].score}"
      break
    end
  end
end


def part2(numbers, boards)
  last_winners = []
  numbers.each do |number|
    boards.each do |board|
      board.mark(number)
    end

    winners, still_losing = boards.partition { |board| board.won? }

    if winners.size > 0
      puts "Board #{winners.size} winning boards after playing #{number}"
      puts "Scores: #{winners.map(&:score).join(',')}"
      last_winners = winners
      boards = still_losing
    end
  end
end


part2(numbers, boards)
