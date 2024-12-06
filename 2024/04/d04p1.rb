grid = File.read('2024/04/input.txt').split.map { |line| line.chars }

paths = [
  [[0,0], [0,1], [0,2], [0,3]],
  [[0,0], [0,-1], [0,-2], [0,-3]],
  [[0,0], [1,0], [2,0], [3,0]],
  [[0,0], [-1,0], [-2,0], [-3,0]],
  [[0,0], [1,1], [2,2], [3,3]],
  [[0,0], [-1,1], [-2,2], [-3,3]],
  [[0,0], [-1,-1], [-2,-2], [-3,-3]],
  [[0,0], [1,-1], [2,-2], [3,-3]],
]

count = 0

for y in (0...grid.length)
  for x in (0...grid[y].length)
    for path in paths
      matches = true
      path.each_with_index do |pos, i|
        cy = y + pos[0]
        cx = x + pos[1] 
        matches = false if cy<0 || cx<0 || cy>=grid.length || cx>=grid[0].length || grid[cy][cx] != "XMAS"[i]
        break if !matches
      end
      count += 1 if matches
    end
  end
end

p count