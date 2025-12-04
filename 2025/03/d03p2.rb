banks = File.read('2025/03/input.txt').lines.map { |line| line.strip.chars.map(&:to_i) }

def best_joltage(bank, digits_needed)
  digit = bank[..-digits_needed].max
  return digit if digits_needed == 1
  return best_joltage(bank[(bank.index(digit) + 1)..], digits_needed - 1) + (digit * 10.pow(digits_needed - 1))
end

total_joltage = banks.sum do |bank|
  best_joltage(bank, 12)
end

puts total_joltage