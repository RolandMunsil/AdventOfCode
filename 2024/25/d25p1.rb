locks = []
keys = []

File.read('2024/25/input.txt').strip.split("\n\n").map(&:lines).each do |lines|
  is_key = lines[0] == ".....\n"
  heights = (0..4).map { |col| lines.count { |line| line[col] == '#' } - 1 }
  locks.append heights unless is_key
  keys.append heights if is_key
end

puts(locks.sum do |lock|
  keys.count do |key|
    (0..4).all? { |col| lock[col] + key[col] < 6 }
  end
end)