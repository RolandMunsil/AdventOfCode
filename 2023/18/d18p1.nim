import sequtils
import sets
import strscans

type Pos = tuple[x: int, y: int]
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `+=`(pos: var Pos, other: (int, int)) = pos = pos + other
func `-`(pos: Pos, other: (int, int)): Pos = (pos.x - other[0], pos.y - other[1])
func `*`(pos: Pos, other: int): Pos = (pos.x * other, pos.y * other)
func `-`(pos: Pos): Pos = (-pos.x, -pos.y)

var dugPosSet: HashSet[Pos]
var curPos: Pos = (0, 0)

for line in lines("input.txt"):
    var
        dir: char
        n: int
        color: int
    discard line.scanf("$c $i (#$h)", dir, n, color)

    var dirVec: Pos

    case dir:
    of 'U': dirVec = (0, -1)
    of 'D': dirVec = (0,  1)
    of 'L': dirVec = (-1, 0)
    of 'R': dirVec = ( 1, 0)
    else: discard

    for i in 1..n:
        curPos += dirVec
        dugPosSet.incl curPos

let minX = dugPosSet.mapIt(it.x).foldl(min(a, b))
let minY = dugPosSet.mapIt(it.y).foldl(min(a, b))
let maxX = dugPosSet.mapIt(it.x).foldl(max(a, b))
let maxY = dugPosSet.mapIt(it.y).foldl(max(a, b))

var interiorSet: HashSet[Pos] 

for y in minY..maxY:
    var above = false
    var below = false
    for x in minX..maxX:
        if (x, y) in dugPosSet:
            if (x, y - 1) in dugPosSet:
                above = not above
            if (x, y + 1) in dugPosSet:
                below = not below
        else:
            if above and below:
                interiorSet.incl (x, y)

dugPosSet.incl interiorSet

for y in minY..maxY:
    for x in minX..maxX:
        stdout.write (if (x, y) in dugPosSet: '#' else: '.')
    stdout.write('\n')

echo dugPosSet.len
