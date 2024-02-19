import sequtils
import tables
import strformat

var grid = lines("input.txt").toSeq.mapIt(it.toSeq)

proc rollWest(grid: var seq[seq[char]]): void =
    for row in grid.mitems:
        var newRow: seq[char]
        for c in 0..row.high:
            let ch = row[c]
            if ch == 'O':
                newRow.add 'O'
            elif ch == '#':
                while newRow.len < c:
                    newRow.add '.'
                newRow.add '#'
        while newRow.len < row.len:
            newRow.add '.'
        row = newRow

proc rotateClockwise(grid: var seq[seq[char]]): void =
    var newGrid: seq[seq[char]]

    for iDestRow in 0..grid.high:
        var newRow: seq[char]
        for iSrcRow in countdown(grid.high, 0):
            newRow.add grid[iSrcRow][iDestRow]
        newGrid.add newRow
    
    grid = newGrid

proc calcTotalLoadNorth(grid: seq[seq[char]]): int =
    for r in 0..<grid.len:
        result.inc grid[r].countIt(it == 'O') * (grid.len - r)

# source N is grid N

grid.rotateClockwise()
grid.rotateClockwise()
grid.rotateClockwise()

# source N is grid W

var cache: seq[seq[seq[char]]]
cache.add grid

for nCycles in 1..250:
    for i2 in 1..4:
        grid.rollWest()
        grid.rotateClockwise()

    if grid in cache:
        echo &"{nCycles} = {cache.find grid}"
        let nCyclesLoopStart = cache.find grid
        let loopLength = nCycles - nCyclesLoopStart
        let srcCycles = ((1000000000 - nCyclesLoopStart) mod loopLength) + nCyclesLoopStart
        grid = cache[srcCycles]
        break

    cache.add grid

    # grid.rotateClockwise()

    # echo()
    # echo()
    # for row in grid: echo row.foldl(a & b, "")
    # echo calcTotalLoadNorth(grid)

    # grid.rotateClockwise()
    # grid.rotateClockwise()
    # grid.rotateClockwise()

grid.rotateClockwise()

# source N is grid N

echo calcTotalLoadNorth(grid)