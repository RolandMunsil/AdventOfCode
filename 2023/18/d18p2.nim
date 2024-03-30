import algorithm
import sequtils
import sets
import strformat
import strscans
import tables

type Pos = tuple[x: int, y: int]
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `+=`(pos: var Pos, other: (int, int)) = pos = pos + other
func `-`(pos: Pos, other: (int, int)): Pos = (pos.x - other[0], pos.y - other[1])
func `*`(pos: Pos, other: int): Pos = (pos.x * other, pos.y * other)
func `-`(pos: Pos): Pos = (-pos.x, -pos.y)

var curPos: Pos = (0, 0)

var yToVertLineXs: Table[int, seq[int]]
var yToHorizLines: Table[int, seq[seq[int]]]

var borderCt: uint64 = 0

for line in lines("input.txt"):
    var
        dir: char
        n: int
        color: int
    discard line.scanf("$c $i (#$h)", dir, n, color)

    n = color.shr 4
    dir = @['R', 'D', 'L', 'U'][color and 0xF]

    borderCt.inc n

    var dirVec: Pos

    case dir:
    of 'U': dirVec = (0, -1)
    of 'D': dirVec = (0,  1)
    of 'L': dirVec = (-1, 0)
    of 'R': dirVec = ( 1, 0)
    else: discard

    if dirVec.x == 0:
        for i in 1..n:
            curPos += dirVec
            if i != n:
                yToVertLineXs.mgetOrPut(curPos.y, @[]).add curPos.x
    else:
        yToHorizLines.mgetOrPut(curPos.y, @[]).add @[curPos.x, curPos.x + (dirVec.x * n)].sorted()
        curPos.x.inc (dirVec.x * n)

var fillct: uint64 = 0

for y, xs in yToVertLineXs.mpairs:
    if y notin yToHorizLines:
        xs.sort()
        for i in countup(0, xs.high, 2):
            fillct.inc ((xs[i + 1] - xs[i]) - 1)

const doEcho = false

for y, lines in yToHorizLines.mpairs:
    if y in yToVertLineXs:
        let xsVert = yToVertLineXs[y].sorted()
        let xBoundsHoriz = lines.foldl(a & b)
        if doEcho: echo &"{y - 1} | {yToVertLineXs[y - 1].sorted()} | {(y - 1) in yToHorizLines}"
        if doEcho: echo &"{y} | {xsVert} | {lines}"
        if doEcho: echo &"{y + 1} | {yToVertLineXs[y + 1].sorted()} | {(y + 1) in yToHorizLines}"
        let allxs = (xsVert & xBoundsHoriz).sorted()

        var inside = false

        var i = 0
        while i < allXs.len:
            let x = allXs[i]

            if doEcho: echo &"    x={x}"

            if inside:
                if doEcho: echo &"    inc {(x - allXs[i - 1]) - 1}"
                fillct.inc (x - allXs[i - 1]) - 1

            if x in xsVert:
                inside = not inside
                if doEcho: echo &"    inside -> {inside}"
                i.inc
            elif x in xBoundsHoriz:
                if doEcho: echo &"    horiz line"
                let xNext = allXs[i + 1]
                if (x in yToVertLineXs[y - 1]) != (xNext in yToVertLineXs[y - 1]):
                    inside = not inside
                    if doEcho: echo &"        inside -> {inside}"
                i = i + 2

echo borderCt + fillct

# correct answer is apparently  62762509300678
# but this code keeps giving me 62762508792994