def all_combinations(nums)
  case nums
  in [Integer => integer]
    [integer]
  else
    n2 = nums[-1]
    all_combinations(nums[0..-2]).flat_map { |n1| [n1 + n2, n1 * n2, (n1.to_s + n2.to_s).to_i]}.uniq
  end
end

puts (File.read("2024/07/input.txt").lines.map do |line|
  strTestVal, strNums = line.split(':')
  testVal = strTestVal.to_i
  nums = strNums.strip.split.map { |n| n.to_i }
  if all_combinations(nums).include? testVal then testVal else 0 end
end).sum