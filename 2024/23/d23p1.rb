node_to_neighbors = Hash.new { |k, v| k[v] = Set.new}
File.read('2024/23/input.txt').strip.lines.map { |l| l.strip.split '-'}.each do |l, r|
  node_to_neighbors[l].add r
  node_to_neighbors[r].add l
end

tris = node_to_neighbors.map do |node, neighbors|
  neighbors.to_a.combination(2).filter do |neigh1, neigh2|
    node_to_neighbors[neigh1].include? neigh2
  end.map { |n1, n2| Set.new([node, n1, n2]) }
end.flatten(1).uniq
puts(tris.count { |tri| tri.any? { |n| n[0] == 't' } })