banks = File.read('2025/03/input.txt').lines.map { |line| line.strip.chars.map(&:to_i) }

def best_joltage(bank, digits_needed)
  return 0 if digits_needed > bank.length
  return bank.max if digits_needed == 1

  digits_with_indices = bank[..-digits_needed].each_with_index.group_by { |digit, index| digit }.each_pair.sort { |p1, p2| p2[0] <=> p1[0] }

  digits_with_indices.each do |digit, indices|
    subjoltages = indices.map do |_, index| 
      best_joltage(bank[(index+1)..], digits_needed - 1)
    end

    best_subjoltage = subjoltages.max

    if best_subjoltage > 0
      return best_subjoltage + (digit * 10.pow(digits_needed - 1))
    end
  end
end

total_joltage = banks.sum do |bank|
  best_joltage(bank, 12)
end

puts total_joltage