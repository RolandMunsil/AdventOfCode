banks = File.read('2025/03/input.txt').lines.map { |line| line.strip.chars.map(&:to_i) }

total_joltage = banks.sum do |bank|
  tens = bank[..-2].max
  tens_index = bank.index(tens)
  ones = bank[(tens_index + 1)..].max
  tens * 10 + ones
end

puts total_joltage