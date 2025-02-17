lines = File.read('2024/19/input.txt').strip.lines.map(&:strip)

$towels = lines[0].split(', ')
designs = lines[2..]

$design_to_n_ways = {}

def n_ways(design)
  return 1 if design.empty?
  return $design_to_n_ways[design] if $design_to_n_ways.key? design
  count = $towels.filter { |t| design.start_with?(t) }.sum { |t| n_ways(design[t.length..]) }
  $design_to_n_ways[design] = count
  return count
end

puts(designs.sum { |d| n_ways(d) })