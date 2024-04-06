import sets
import sequtils
import tables

type Pos = tuple[x, y: int]
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])

let grid = lines("input.txt").toSeq

proc val(pos: Pos): char = grid[pos.y][pos.x]
proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low and pos.x <= grid[0].high
proc isWalkable(pos: Pos): bool = pos.isValid and pos.val != '#'

proc moveCands(pos: Pos): seq[Pos] = @[(0, 1), (0, -1), (1, 0), (-1, 0)].mapIt(pos + it).filterIt(it.isWalkable)

let startPos: Pos = (1, 0)
let endPos: Pos = (grid[0].high - 1, grid.high)

var posToNeighbors: Table[Pos, seq[(Pos, int)]]

block:
    var unedgedNodes = @[startPos].toHashSet

    while unedgedNodes.len > 0:
        var node = unedgedNodes.pop()

        var neighbors: seq[(Pos, int)]

        for moveCand in node.moveCands():
            var edge = @[moveCand]
            while true:
                let cands = edge[^1].moveCands().filterIt(it != node and it notin edge)
                if cands.len == 1:
                    edge.add cands[0]
                else:
                    break
            
            neighbors.add (edge[^1], edge.len)

            if edge[^1] notin posToNeighbors:
                unedgedNodes.incl edge[^1]
        
        posToNeighbors[node] = neighbors

proc longestPath(initialPath: seq[Pos], initialCost: int): int =
    var curPath = initialPath
    var curCost = initialCost
    while true:
        let cands = posToNeighbors[curPath[^1]].filterIt(it[0] notin curPath)

        if cands.len == 0:
            if curPath[^1] == endPos:
                return curCost
            else:
                return -1000
        elif cands.len == 1:
            curPath.add cands[0][0]
            curCost += cands[0][1]
        else:
            return cands.mapIt(longestPath(curPath & @[it[0]], curCost + it[1])).max()

echo longestPath(@[startPos], 0)