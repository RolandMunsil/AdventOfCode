import sequtils

let grid = lines("input.txt").toSeq

var totalLoad = 0

for c in 0..<grid[0].len:
    var nextRockLoad = grid.len

    for r in 0..<grid.len:
        let ch = grid[r][c]

        if ch == '#':
            nextRockLoad = (grid.len - r) - 1
        elif ch == 'O':
            totalLoad.inc nextRockLoad
            nextRockLoad.dec

echo totalLoad