lines = File.read('2024/19/input.txt').strip.lines

$towels = lines[0].split(', ')
designs = lines[2..].map(&:strip)

$design_to_makeable = Hash.new

def can_make(design)
  return true if design.empty?
  return $design_to_makeable[design] if $design_to_makeable.key? design
  makeable = $towels.any? { |t| design.start_with?(t) && can_make(design[t.length..]) }
  $design_to_makeable[design] = makeable
  return makeable
end

puts(designs.count { |d| can_make(d) })