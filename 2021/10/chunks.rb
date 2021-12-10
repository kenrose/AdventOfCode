require 'byebug'

def read_input
  lines = ARGF.read.split("\n")
end

MATCHES = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}


PART2_DIGITS = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4,
}

REVERSE_MATCHES = MATCHES.invert

CLOSING = MATCHES.keys
OPENING = MATCHES.values

SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

def parse(line)
  stack = []
  line.chars.each do |c|
    if OPENING.include?(c)
      stack.push(c)
    elsif CLOSING.include?(c)
      peek = stack.last
      if peek != MATCHES[c]
        return c
      else
        stack.pop
      end
    end
  end

  if stack.empty?
    return 'valid'
  else
    return stack
  end
end


def part1(result)
  corrupted = result.select { |r| r.class == String && r.size == 1 }
  scores = corrupted.map { |r| SCORES[r] }
  total_score = scores.sum
  puts "Total Score: #{total_score}"

end

def score(remaining_stack)
  remaining_stack.reverse.map { |c| PART2_DIGITS[c] }.join.to_i(5)
end

def part2(result)
  incomplete = result.select { |r| r.class == Array }
  scores = incomplete.map { |remaining_stack| score(remaining_stack) }
  scores.sort!
  middle_score = scores[scores.size / 2]
  puts "Middle Score: #{middle_score}"
end


lines = read_input
result = lines.map { |line| parse(line) }
part2(result)


# [({(<(())[]>[[{[]{<()<>>
