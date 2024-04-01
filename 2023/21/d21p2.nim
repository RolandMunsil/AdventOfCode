import math
import sets
import sequtils
import strformat
var grid = lines("input.txt").toSeq.mapIt(it.toSeq)

func pmod(a, b: int): int = ((a mod b) + b) mod b

type Pos = tuple[x: int, y: int]
proc val(pos: Pos): char = grid[pos.y.pmod grid.len][pos.x.pmod grid[0].len]
proc cell(pos: Pos): Pos = (floor(pos.x / grid[0].len).int, floor(pos.y / grid.len).int)
# proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low and pos.x <= grid[0].high
# proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func sgn(pos: Pos): Pos = (pos.x.sgn, pos.y.sgn)

proc isRock(pos: Pos): bool = pos.val == '#'
proc neighbors(pos: Pos): seq[Pos] = @[pos+(0,1), pos+(0,-1), pos+(1, 0), pos+(-1, 0)]

var startPos: Pos

block findAndReplaceStart:
    for y, line in grid:
        for x, c in line:
            if c == 'S':
                startPos = (x, y)
                grid[y][x] = '.'
                break findAndReplaceStart



const totalSteps = 26501365

proc calcReachedInSection(stripDir: Pos): uint64 =
    var n = 0
    var prevTiles: HashSet[Pos]
    var curTiles = @[startPos].toHashSet
    var curEdgeTiles = curTiles
    var tilesAtStepInStrip = @[initHashSet[Pos]()]
    var normEdgeTilesAtStep = @[initHashSet[Pos]()]

    var okToSearchForLoop = false
    var loopStart = -1
    var loopLength = -1
    var stepA = -1
    var stepB = -1
    var stepC = -1

    while true:
        n.inc

        block:
            var newTiles = prevTiles
            var newEdgeTiles: HashSet[Pos]
            for pos in curEdgeTiles:
                newEdgeTiles.incl (pos.neighbors.filterIt((not it.isRock) and (it notin newTiles)).toHashSet)
            newTiles.incl newEdgeTiles

            prevTiles = curTiles
            curTiles = newTiles
            curEdgeTiles = newEdgeTiles

            tilesAtStepInStrip.add curTiles.toSeq.filterIt(it.cell.sgn == stripDir).toHashSet

        if n < 2:
            normEdgeTilesAtStep.add tilesAtStepInStrip[n]
        else:
            let edgePoints = tilesAtStepInStrip[n] - tilesAtStepInStrip[n - 2]
            normEdgeTilesAtStep.add edgePoints.mapIt((it.x.pmod grid[0].len, it.y.pmod grid.len)).toHashSet

        if not okToSearchForLoop and tilesAtStepInStrip[n].len > 0:
            okToSearchForLoop = true

        if okToSearchForLoop and loopStart == -1:
            for nOld in countdown(n - 2, 1, 2): # count down in steps of 2
                if normEdgeTilesAtStep[n] == normEdgeTilesAtStep[nOld]:
                    loopStart = nOld
                    loopLength = n - nOld

                    stepA = loopStart + ((totalSteps - loopStart) mod loopLength)
                    stepB = stepA + loopLength
                    stepC = stepB + loopLength

        if n == stepC:
            # block:
            #     for tiles in @[tilesAtStepInStrip[stepA], tilesAtStepInStrip[stepB], tilesAtStepInStrip[stepC]]:
            #         let xs = tiles.toSeq.mapIt(it.x)
            #         let ys = tiles.toSeq.mapIt(it.y)

            #         for y in ys.min..ys.max:
            #             for x in xs.min..xs.max:
            #                 let pos = (x, y)
            #                 if pos in tiles:
            #                     stdout.write 'O'
            #                 elif pos.isRock:
            #                     stdout.write '#'
            #                 else:
            #                     stdout.write ' '
            #             stdout.write '\n'

            #         stdout.write '\n'

            #         for yC in 1..(0, ys.max).cell.y:
            #             for xC in 1..(xs.max, 0).cell.x:
            #                 stdout.write tiles.toSeq.filterIt(it.cell == (xC, yC)).len
            #                 stdout.write " "
            #             stdout.write '\n'

            #         stdout.write '\n'

            let tilesA: uint64 = tilesAtStepInStrip[stepA].len.uint64
            let tilesB: uint64 = tilesAtStepInStrip[stepB].len.uint64
            let tilesC: uint64 = tilesAtStepInStrip[stepC].len.uint64
            let nLoop: uint64 = (totalSteps - stepA).uint64 div loopLength.uint64
            assert nLoop.int64 * loopLength + stepA == totalSteps

            # echo &"{stepA} -> {stepB} -> {stepC} | {tilesA} -> {tilesB} -> {tilesC}"

            if stripDir.x == 0 or stripDir.y == 0:
                assert tilesB - tilesA == tilesC - tilesB
                assert (tilesC - (2 * tilesB) + tilesA) == 0
            else:
                assert tilesB - tilesA != tilesC - tilesB
                assert (tilesC - (2 * tilesB) + tilesA) != 0

            return tilesA +
                ((tilesB - tilesA) * nLoop) +
                (((tilesC - (2 * tilesB)) + tilesA) * (((nLoop - 1) * nLoop) div 2))

        if n == totalSteps:
            return tilesAtStepInStrip[n].len.uint64

echo calcReachedInSection((0, 0))
echo calcReachedInSection((1, 0))
echo calcReachedInSection((-1, 0))
echo calcReachedInSection((0, 1))
echo calcReachedInSection((0, -1))
echo calcReachedInSection((1, 1))
echo calcReachedInSection((-1, 1))
echo calcReachedInSection((-1, -1))
echo calcReachedInSection((1, -1))

echo ""

echo @[
    calcReachedInSection((0, 0)),
    calcReachedInSection((1, 0)),
    calcReachedInSection((-1, 0)),
    calcReachedInSection((0, 1)),
    calcReachedInSection((0, -1)),
    calcReachedInSection((1, 1)),
    calcReachedInSection((-1, 1)),
    calcReachedInSection((-1, -1)),
    calcReachedInSection((1, -1)),
].foldl(a + b)


# echo "\nexpected:"

# block:
#     var curPoss = @[startPos].toHashSet
#     for nStep in 1..totalSteps:
#         var curPossNew: HashSet[Pos]
#         for pos in curPoss:
#             curPossNew.incl pos.neighbors.filterIt(not it.isRock).toHashSet
#         curPoss = curPossNew
#     echo curPoss.len

#     echo curPoss.toSeq.countIt(it.cell.sgn == (0, 0))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (1, 0))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (-1, 0))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (0, 1))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (0, -1))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (1, 1))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (-1, 1))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (-1, -1))
#     echo curPoss.toSeq.countIt(it.cell.sgn == (1, -1))