grid = File.read('2025/04/input.txt').lines

accessible = 0

grid.each_with_index do |line, i|
  line.chars.each_with_index do |ch, j|
    next if ch != '@'
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
    count = checklist.count { |ic, jc| grid[ic].chars[jc] == '@' }
    accessible += 1 if count < 4
  end
end

puts accessible