import sequtils
import strscans
import tables

let lines = lines("input.txt").toSeq

var nodeMap: Table[string, (string, string)]

for (_, node, nodeL, nodeR) in lines[2..^1].mapIt(it.scanTuple("$* = ($*, $*)")):
    nodeMap[node] = (nodeL, nodeR)

let instructions = lines[0]

var i = 0
var curNode = "AAA"
var steps = 0

while curNode != "ZZZ":
    if instructions[i] == 'L':
        curNode = nodeMap[curNode][0]
    else:
        curNode = nodeMap[curNode][1]

    i = (i + 1) mod instructions.len
    steps.inc

echo steps