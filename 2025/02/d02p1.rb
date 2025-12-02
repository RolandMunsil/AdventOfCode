ranges = File.read('2025/02/input.txt').strip.split(',').map { |range| range.split('-').map(&:to_i) }

invalid = []

ranges.each do |lo, hi|
  (lo..hi).each do |id|
    idstr = id.to_s
    next if idstr.length.odd?
    s = idstr.length / 2
    invalid.append(id) if idstr[0...s] == idstr[s...]
  end
end

puts invalid.sum