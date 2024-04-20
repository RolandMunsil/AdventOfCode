import tables
import sets
import sequtils
import strformat
import strutils

var nodes: seq[string]
var wires: seq[(uint16, uint16)]
var graph: Table[uint16, set[uint16]]

for line in lines "input.txt":
    let parts = line.split ": "
    let node = parts[0]
    let connNodes = parts[1].splitWhitespace

    if node notin nodes:
        nodes.add node
    let iNode = uint16(nodes.find node)

    for connNode in connNodes:
        if connNode notin nodes:
            nodes.add connNode
        let iConnNode = uint16(nodes.find connNode)

        let wire = (min(iNode, iConnNode), max(iNode, iConnNode))

        if wire notin wires:
            wires.add wire
        let iWire = uint16(wires.find wire)

        graph.mgetOrPut(iNode, {}).incl iWire
        graph.mgetOrPut(iConnNode, {}).incl iWire


# for (node, connSet) in graph.pairs:
#     echo &"{node}: {connSet}"
# echo wires.len
# echo graph.len

let baseNode: uint16 = 0
var nInSameGroup = 1

for nodeToFind in 1.uint16..nodes.high.uint16:

    var prevPathsWires: set[uint16]
    var notFourPaths = false

    for nPaths in 1..4:
        var visited: set[uint16]
        var frontier = @[baseNode]
        var cameFrom: Table[uint16, uint16]

        block findPath:
            while frontier.len > 0:
                let frNode = frontier.pop()
                visited.incl frNode

                let wires = (graph[frNode] - prevPathsWires).mapIt(wires[it])

                for wire in wires:
                    for wireNode in @[wire[0], wire[1]]:
                        if wireNode notin visited and wireNode notin frontier:
                            cameFrom[wireNode] = frNode
                            if wireNode == nodeToFind:
                                break findPath
                            frontier.add wireNode

        if nodeToFind notin cameFrom:
            notFourPaths = true
            break

        var pathReverse = @[nodeToFind]
        var pathWires: set[uint16]

        while pathReverse[^1] != baseNode:
            pathReverse.add cameFrom[pathReverse[^1]]
            let wire = (min(pathReverse[^1], pathReverse[^2]), max(pathReverse[^1], pathReverse[^2]))
            pathWires.incl (wires.find wire).uint16

        assert len(prevPathsWires * pathWires) == 0

        prevPathsWires.incl pathWires

    if not notFourPaths:
        echo &"{nodeToFind} ({nodes[nodeToFind]})"
        nInSameGroup.inc

echo &"{nInSameGroup} * {nodes.len - nInSameGroup} = {nInSameGroup * (nodes.len - nInSameGroup)}"