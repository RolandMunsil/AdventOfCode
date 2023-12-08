import sequtils
import strscans
import tables
import sets
import strformat
import math

let lines = lines("input.txt").toSeq

var nodeMap: Table[string, (string, string)]

for (_, node, nodeL, nodeR) in lines[2..^1].mapIt(it.scanTuple("$* = ($*, $*)")):
    nodeMap[node] = (nodeL, nodeR)

let instructions = lines[0]

# build skip table

type SkipInfo = tuple[resultNode: string, zTurns: HashSet[int]]
var skipMap: Table[string, SkipInfo]

for node in nodeMap.keys:
    var curNode = node
    var skipInfo: SkipInfo
    for i, c in instructions:
        if instructions[i] == 'L':
            curNode = nodeMap[curNode][0]
        else:
            curNode = nodeMap[curNode][1]

        if curNode[2] == 'Z':
            skipInfo.zTurns.incl(i + 1)
    skipInfo.resultNode = curNode
    skipMap[node] = skipInfo

#for entry in skipMap.pairs:
#    echo entry

let startNodes: seq[string] = nodeMap.keys.toSeq.filterIt(it[2] == 'A')

type ZTurnLoop = tuple[zTurnFirst: int, loopLength: int]

var loopSets: seq[seq[ZTurnLoop]]

for node in startNodes:
    var zTurns: seq[int]

    var prevNodes: seq[string]
    var curNode = node

    while curNode notin prevNodes:
        let skipInfo = skipMap[curNode]

        if skipInfo.zTurns.len > 0:
            for zTurn in skipInfo.zTurns:
                zTurns.add(zTurn + (prevNodes.len * instructions.len))

        prevNodes.add(curNode)
        curNode = skipInfo.resultNode
    
    let totalTurns = prevNodes.len * instructions.len
    let turnsFromStartToLoop = prevNodes.find(curNode) * instructions.len
    let loopLength = totalTurns - turnsFromStartToLoop

    echo (totalTurns, turnsFromStartToLoop, loopLength)

    loopSets.add(@[])

    for zTurn in zTurns:
        loopSets[^1].add((zTurn, loopLength))

    echo &"{prevNodes} -> {curNode} ({zTurns})"

echo loopSets

# TODO: this answer relies on the fact that every one of these paths 
#  loops immediately after hitting its first Z node. What's a more general solution?

echo loopsets.mapIt(it[0].loopLength).foldl(lcm(a, b))