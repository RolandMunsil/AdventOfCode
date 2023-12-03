import sequtils
import strutils

let map = "input.txt".lines.toSeq

type Loc = tuple[x: int, y: int]

proc valid(loc: Loc): bool =
    return loc.y >= 0 and loc.y < map.len and loc.x >= 0 and loc.x < map[loc.y].len

proc elev(loc: Loc): int =
    assert valid(loc) 
    var ch = map[loc.y][loc.x]
    if ch == 'E': ch = 'z'
    if ch == 'S': ch = 'a'
    return ch.ord

func `+`(loc1: Loc, loc2: Loc): Loc =
    (loc1.x + loc2.x, loc1.y + loc2.y)

var destLoc: Loc

for i, str in map:
    for j, ch in str:
        if ch == 'E': destLoc = (j, i)

var reachedLocs = map # char set to '_' means it has been reached
var reachableBorder = @[destLoc]

var stepCt = 0

while not reachableBorder.anyIt(it.elev == 'a'.ord):
    # if stepCt mod 100 == 0:
    #     echo reachedLocs.join("\n")
    #     echo reachableBorder
    var reachableBorderNext: seq[Loc]

    for loc in reachableBorder:
        let neighbors = [
            loc + (1, 0),
            loc + (-1, 0),
            loc + (0, 1),
            loc + (0, -1)
        ]

        for neighbor in neighbors:
            if not neighbor.valid: continue
            if reachedLocs[neighbor.y][neighbor.x] == '_': continue
            if neighbor in reachableBorder: continue
            if neighbor in reachableBorderNext: continue

            if elev(loc) <= elev(neighbor) + 1: reachableBorderNext.add(neighbor)

        reachedLocs[loc.y][loc.x] = '_'
    
    reachableBorder = reachableBorderNext
    inc stepCt

echo stepCt
