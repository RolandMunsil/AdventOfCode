import algorithm
import sequtils
import strscans
import strutils
import tables

type Pos = tuple[x: int, y: int]
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `*`(pos: Pos, other: int): Pos = (pos.x * other, pos.y * other)

var yToVertLineXs: Table[int, seq[int]]
var yToHorizLines: Table[int, seq[seq[int]]]

var borderCt: uint64 = 0
var curPos: Pos = (0, 0)

for line in lines("input.txt"):
    var color: int
    discard line.splitWhitespace()[2].scanf("(#$h)", color)

    let n = color.shr 4
    let dirVec: Pos = @[(1, 0), (0,  1), (-1, 0), (0, -1)][color and 0xF]

    borderCt.inc n

    let endPos = curPos + (dirVec * n)

    if dirVec.x == 0:
        for i in 1..(n-1):
            yToVertLineXs.mgetOrPut(curPos.y + (dirVec.y * i), @[]).add curPos.x
    else: 
        yToHorizLines.mgetOrPut(curPos.y, @[]).add @[curPos.x, endPos.x].sorted()
    curPos = endPos

var fillct: uint64 = 0

for y, xs in yToVertLineXs.mpairs:
    if y notin yToHorizLines:
        xs.sort()
        for i in countup(0, xs.high, 2):
            fillct.inc ((xs[i + 1] - xs[i]) - 1)

for y, lines in yToHorizLines.mpairs:
    let xsVert = if y in yToVertLineXs: yToVertLineXs[y].sorted() else: @[]
    let xBoundsHoriz = lines.foldl(a & b)
    let allxs = (xsVert & xBoundsHoriz).sorted()

    var inside = false

    var i = 0
    while i < allXs.len:
        let x = allXs[i]

        if inside:
            fillct.inc (x - allXs[i - 1]) - 1

        if x in xsVert:
            inside = not inside
            i.inc
        elif x in xBoundsHoriz:
            let xNext = allXs[i + 1]
            if (y-1) in yToVertLineXs and ((x in yToVertLineXs[y - 1]) != (xNext in yToVertLineXs[y - 1])):                
                inside = not inside
            i = i + 2

echo borderCt + fillct