ranges = []
loading_ranges = true

total_fresh = 0

File.read('2025/05/input.txt').lines.each do |line|
  if line.strip.empty?
    loading_ranges = false
    next
  end

  if loading_ranges
    ranges.append line.strip.split('-').map(&:to_i)
  else
    id = line.strip.to_i
    total_fresh += 1 if ranges.any? { |range| range[0] <= id && id <= range[1] }
  end
end

puts total_fresh