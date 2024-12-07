# VS code is being weird and not letting me indent with 2 spaces, so I gave up and am using 4
#  spaces. Don't hate me ruby purists!

def all_combinations(nums)
    case nums
    in [Integer => integer]
        [integer]
    else
        all_combinations(nums[0..-2]).flat_map { |n| [n + nums[-1], n * nums[-1]]}.uniq
    end
end

puts (File.read("2024/07/input.txt").lines.map do |line|
    strTestVal, strNums = line.split(':')
    testVal = strTestVal.to_i
    nums = strNums.strip.split.map { |n| n.to_i }
    if all_combinations(nums).include? testVal then testVal else 0 end
end).sum