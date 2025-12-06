ranges = []

total_fresh = 0

File.read('2025/05/input.txt').lines.each do |line|
  break if line.strip.empty?

  new_range = line.strip.split('-').map(&:to_i)
  ranges.each do |range|
    new_range[0] = range[1] + 1 if range[0] <= new_range[0] && new_range[0] <= range[1]
    new_range[1] = range[0] - 1 if range[0] <= new_range[1] && new_range[1] <= range[1]
    break if new_range[1] < new_range[0]
    total_fresh -= (1 + range[1] - range[0]) if new_range[0] <= range[0] && new_range[1] >= range[1]
  end
  next if new_range[1] < new_range[0]
  total_fresh += (1 + new_range[1] - new_range[0])
  ranges.append new_range
end

puts total_fresh