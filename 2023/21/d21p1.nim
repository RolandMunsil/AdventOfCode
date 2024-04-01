import sets
import sequtils

var grid = lines("input.txt").toSeq.mapIt(it.toSeq)

type Pos = tuple[x: int, y: int]
proc val(pos: Pos): char = grid[pos.y][pos.x]
proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low and pos.x <= grid[0].high
proc isRock(pos: Pos): bool = pos.val == '#'
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `+=`(pos: var Pos, other: (int, int)) = pos = pos + other
func `-`(pos: Pos, other: (int, int)): Pos = (pos.x - other[0], pos.y - other[1])
func `*`(pos: Pos, other: int): Pos = (pos.x * other, pos.y * other)
func `-`(pos: Pos): Pos = (-pos.x, -pos.y)

var startPos: Pos

block findAndReplaceStart:
    for y, line in grid:
        for x, c in line:
            if c == 'S':
                startPos = (x, y)
                grid[y][x] = '.'
                break findAndReplaceStart

var curPoss = @[startPos].toHashSet

for nStep in 1..64:
    var curPossNew: HashSet[Pos]
    for pos in curPoss:
        curPossNew.incl @[pos+(0,1), pos+(0,-1), pos+(1, 0), pos+(-1, 0)].filterIt(it.isValid and not it.isRock).toHashSet
    curPoss = curPossNew

echo curPoss.len