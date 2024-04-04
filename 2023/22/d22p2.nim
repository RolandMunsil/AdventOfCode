import algorithm
import sets
import sequtils
import strformat
import strscans
import tables

type Pos = tuple[x, y, z: int]

func below(pos: Pos): Pos = (pos.x, pos.y, pos.z - 1)
func above(pos: Pos): Pos = (pos.x, pos.y, pos.z + 1)

type Brick = seq[Pos]

var bricks: seq[Brick]

for line in lines "input.txt":
    var p1, p2: Pos
    discard line.scanf("$i,$i,$i~$i,$i,$i", p1.x, p1.y, p1.z, p2.x, p2.y, p2.z)

    var brick: Brick

    for x in min(p1.x, p2.x)..max(p1.x, p2.x):
        for y in min(p1.y, p2.y)..max(p1.y, p2.y):
            for z in min(p1.z, p2.z)..max(p1.z, p2.z):
                brick.add (x, y, z)

    bricks.add brick

func isPosOccupied(bricks: seq[Brick], pos: Pos): bool = pos.z <= 0 or bricks.anyIt(it.anyIt(it == pos))

func applyGravity(bricks: seq[Brick]): seq[Brick] =
    result = bricks.sorted do (a, b: Brick) -> int:
        result = cmp(a.mapIt(it.z).min(), b.mapIt(it.z).min())

    for brick in result.mitems:
        let lowestZ = brick.mapIt(it.z).min()
        var lowestAllowedZ = 1

        for pos in brick.filterIt(it.z == lowestZ):
            for z in countdown(pos.z - 1, 1):
                if result.isPosOccupied (pos.x, pos.y, z):
                    lowestAllowedZ = max(lowestAllowedZ, z + 1)
                    break
        
        for pos in brick.mitems:
            pos.z = pos.z - (lowestZ - lowestAllowedZ)

let settledBricks = applyGravity(bricks)

var posToISettledBrick: Table[Pos, int]

for i, brick in settledBricks:
    for pos in brick:
        posToISettledBrick[pos] = i

var iSettledBrickToISupports: Table[int, HashSet[int]]

for i, brick in settledBricks:
    let lowestZ = brick.mapIt(it.z).min()
    var supports: HashSet[int]
    for pos in brick.filterIt(it.z == lowestZ):
        if pos.below in posToISettledBrick: supports.incl posToISettledBrick[pos.below]
    iSettledBrickToISupports[i] = supports


proc calcNFall(iSettledBrick: int): int =
    var iBricksRemoved = @[iSettledBrick].toHashSet
    var iBricksRemain = posToISettledBrick.values.toSeq.toHashSet - iBricksRemoved

    while true:
        var iBricksNewRemove: HashSet[int]
        for iBrickRemain in iBricksRemain:
            let iSupports = iSettledBrickToISupports[iBrickRemain]
            if iSupports.len == 0:
                continue # brick is on the ground

            if iSupports <= iBricksRemoved:
                iBricksNewRemove.incl iBrickRemain
        
        if iBricksNewRemove.len == 0:
            break

        iBricksRemoved.incl iBricksNewRemove
        iBricksRemain.excl iBricksNewRemove

    return iBricksRemoved.len - 1

echo (settledBricks.low..settledBricks.high).mapIt(calcNFall(it)).foldl(a + b)