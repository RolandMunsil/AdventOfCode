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

tuples = tris

while tuples.length > 1
  tuples = tuples.map do |tup|
    add_cands = node_to_neighbors[tup.to_a[0]] - tup
    add_cands = add_cands.filter { |cand| tup.all? { |node| node_to_neighbors[node].include? cand } }
    add_cands.map { |cand| tup | Set.new([cand]) }
  end.flatten(1).uniq
end

puts tuples[0].to_a.sort.join(',')