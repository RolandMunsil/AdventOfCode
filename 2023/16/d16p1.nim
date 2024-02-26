import sequtils
import strformat

let grid = lines("input.txt").toSeq

var energized: seq[string]

for iRow, row in grid:
    energized.add("")
    for ch in row:
        energized[iRow] &= '.'

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

var alreadyTraced: seq[(Pos, Dir)]

proc traceBeam(posStart: Pos, dirStart: Dir) =
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
        
        energized[pos.y][pos.x] = '#'

        if pos.val == '/':
            dir = (-dir.y, -dir.x)
            # if   dir == NORTH: dir = EAST
            # elif dir == SOUTH: dir = WEST
            # elif dir == EAST:  dir = NORTH
            # elif dir == WEST:  dir = SOUTH
        elif pos.val == '\\':
            dir = (dir.y, dir.x)
            # if   dir == NORTH: dir = WEST
            # elif dir == SOUTH: dir = EAST
            # elif dir == EAST:  dir = SOUTH
            # elif dir == WEST:  dir = NORTH
        elif pos.val == '|' and (dir == WEST or dir == EAST):
            traceBeam(pos, NORTH)
            traceBeam(pos, SOUTH)
            return
        elif pos.val == '-' and (dir == NORTH or dir == SOUTH):
            traceBeam(pos, WEST)
            traceBeam(pos, EAST)
            return

traceBeam((-1, 0), (1, 0))

echo energized.mapIt(it.countIt(it == '#')).foldl(a + b)
            
