ranges = File.read('2025/02/input.txt').strip.split(',').map { |range| range.split('-').map(&:to_i) }

invalid = []

ranges.each do |lo, hi|
  (lo..hi).each do |id|
    idstr = id.to_s
    len = idstr.length
    next if len < 2
    (2..len).each do |count|
      next if (len % count) != 0
      size = len / count
      strs = (0...count).map { |i| idstr[0 + (i * size), size] }
      if strs.uniq.length == 1
        invalid.append(id)
        break
      end
    end
  end
end

puts invalid.sum