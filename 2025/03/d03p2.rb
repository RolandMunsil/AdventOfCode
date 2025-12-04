banks = File.read('2025/03/input.txt').lines.map { |line| line.strip.chars.map(&:to_i) }

def best_joltage(bank, digits_needed)
  9.downto(1) do |digit|
    first_index = bank[..-digits_needed].index digit
    next if first_index.nil?
    return digit if digits_needed == 1

    next_start_index = first_index + 1
    additional_digits_needed = digits_needed - 1
    next if (bank.length - next_start_index) < additional_digits_needed

    return best_joltage(bank[next_start_index..], additional_digits_needed) + (digit * 10.pow(digits_needed - 1))
  end
end

total_joltage = banks.sum do |bank|
  best_joltage(bank, 12)
end

puts total_joltage