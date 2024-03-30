import heapqueue
import parseutils
import sequtils
import strformat
import tables

let grid = lines("input.txt").toSeq.mapIt(it.mapIt(it.ord - '0'.ord))

type Pos = tuple[x: int, y: int]
proc val(pos: Pos): int = grid[pos.y][pos.x]
proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low and pos.x <= grid[0].high
proc pathCost(path: seq[Pos]): int = path.mapIt(val(it)).foldl(a + b)

type Axis = tuple[x: int, y: int]
const HORIZ: Axis = (1, 0)
const VERT: Axis = (0, 1)


func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `-`(pos: Pos, other: (int, int)): Pos = (pos.x - other[0], pos.y - other[1])
func `+=`(pos: var Pos, other: (int, int)) = pos = pos + other
func `-`(pos: Pos): Pos = (-pos.x, -pos.y)

##

let startPos: Pos = (0, 0)
let endPos: Pos = (grid.high, grid.high)

type Node = tuple[pos: Pos, axis: Axis]
type NodeAndPri = tuple[node: Node, pri: int]
proc `<`(a, b: NodeAndPri): bool = a.pri < b.pri

# based heavily on Red Blob Games' code here https://www.redblobgames.com/pathfinding/a-star/introduction.html#dijkstra

var priQueue: HeapQueue[NodeAndPri] = [((startPos, HORIZ), 0), ((startPos, VERT), 0)].toHeapQueue
var minCostTo: Table[Node, int] = {(startPos, HORIZ): 0, (startPos, VERT): 0}.toTable

while priQueue.len > 0:
    var node = priQueue.pop().node

    if node.pos == endPos:
        echo minCostTo[node]
        break

    let edges = @[
        @[node.pos + node.axis],
        @[node.pos + node.axis, node.pos + node.axis + node.axis],
        @[node.pos + node.axis, node.pos + node.axis + node.axis, node.pos + node.axis + node.axis + node.axis],
        @[node.pos - node.axis],
        @[node.pos - node.axis, node.pos - node.axis - node.axis],
        @[node.pos - node.axis, node.pos - node.axis - node.axis, node.pos - node.axis - node.axis - node.axis]
    ].filterIt(it[^1].isValid)

    for edge in edges:
        let totalCost = minCostTo[node] + edge.pathCost
        let nextNode: Node = (edge[^1], (node.axis[1], node.axis[0]))

        if nextNode notin minCostTo or minCostTo[nextNode] > totalCost:
            minCostTo[nextNode] = totalCost
            priQueue.push (nextNode, totalCost)