import sequtils
import strformat

let grid = lines("input.txt").toSeq

type Pos = tuple[x: int, y: int]
proc val(pos: Pos): char = grid[pos.y][pos.x]
proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low and pos.x <= grid[0].high

type Dir = tuple[x: int, y: int]
const NORTH: Dir = (0, -1)
const SOUTH: Dir = (0, 1)
const EAST: Dir  = (1, 0)
const WEST: Dir  = (-1, 0)

func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `+=`(pos: var Pos, other: (int, int)) = pos = pos + other

proc traceBeam(posStart: Pos, dirStart: Dir, energyGrid: var seq[string], alreadyTraced: var seq[(Pos, Dir)]) =
    let check = (posStart, dirStart)
    
    if check in alreadyTraced:
        return
    else:
        alreadyTraced &= check
    
    var pos = posStart
    var dir = dirStart

    while true:
        pos += dir
        if not pos.isValid:
            return
        
        energyGrid[pos.y][pos.x] = '#'

        if pos.val == '/':
            dir = (-dir.y, -dir.x)
        elif pos.val == '\\':
            dir = (dir.y, dir.x)
        elif pos.val == '|' and (dir == WEST or dir == EAST):
            traceBeam(pos, NORTH, energyGrid, alreadyTraced)
            traceBeam(pos, SOUTH, energyGrid, alreadyTraced)
            return
        elif pos.val == '-' and (dir == NORTH or dir == SOUTH):
            traceBeam(pos, WEST, energyGrid, alreadyTraced)
            traceBeam(pos, EAST, energyGrid, alreadyTraced)
            return

proc countEnergizedTiles(posStart: Pos, dirStart: Dir): int =
    var energyGrid: seq[string]
    for iRow, row in grid:
        energyGrid.add("")
        for ch in row:
            energyGrid[iRow] &= '.'
    
    var alreadyTraced: seq[(Pos, Dir)]

    traceBeam(posStart, dirStart, energyGrid, alreadyTraced)

    # for line in energyGrid: echo line

    return energyGrid.mapIt(it.countIt(it == '#')).foldl(a + b)


var maxEnergy = 0

for i in 0..grid.high:
    maxEnergy = maxEnergy.max countEnergizedTiles((-1, i), (1, 0))
    maxEnergy = maxEnergy.max countEnergizedTiles((grid.len, i), (-1, 0))
    maxEnergy = maxEnergy.max countEnergizedTiles((i, -1), (0, 1))
    maxEnergy = maxEnergy.max countEnergizedTiles((i, grid.len), (0, -1))
            
echo maxEnergy