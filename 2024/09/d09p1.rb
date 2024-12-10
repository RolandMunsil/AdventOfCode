nums = File.read('2024/09/input.txt').strip.chars.map { |ch| ch.to_i }

sum = 0

curPos = 0
curFileNum = 0

curFinalFileNum = (nums.length - 1) / 2

while nums.length != 0
  fileLen = nums.delete_at 0
  fileLen.times do |i|
    sum += curPos * curFileNum
    curPos += 1
  end

  break if nums.length == 0

  spaceLen = nums.delete_at 0
  spaceLen.times do |i|
    if nums[-1] == 0
      nums.delete_at(-1)
      break if nums.length == 0

      nums.delete_at(-1)
      curFinalFileNum -= 1
    end

    sum += curPos * curFinalFileNum
    curPos += 1
    nums[-1] -= 1
  end

  curFileNum += 1
end

print sum
