grid = File.read('2025/04/input.txt').lines

removed = Set[]

loop do
  removed_count_before = removed.count
  grid.each_with_index do |line, i|
    line.chars.each_with_index do |ch, j|
      next if ch != '@'
      next if removed.include? [i, j]
      checklist = [
        [i + 1, j    ],
        [i + 1, j + 1],
        [i    , j + 1],
        [i - 1, j + 1],
        [i - 1, j    ],
        [i - 1, j - 1],
        [i    , j - 1],
        [i + 1, j - 1]
      ]

      checklist = checklist.filter { |ic, jc| ic >= 0 && ic < grid.length && jc >= 0 && jc < grid[0].length }
      checklist = checklist.filter { |a| !(removed.include? a) }
      count = checklist.count { |ic, jc| grid[ic].chars[jc] == '@' }
      removed.add [i, j] if count < 4
    end
  end
  break if removed.count == removed_count_before
end

puts removed.count