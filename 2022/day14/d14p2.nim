import math
import os
import strformat
import strutils
import sequtils
import sets

template opPt(pt1: seq[int], pt2: seq[int], operation: untyped): seq[int] =
    var result: seq[int]
    block:
        let 
            a {.inject.} = pt1[0] 
            b {.inject.} = pt2[0]
        result.add(operation)
    block:
        let 
            a {.inject.} = pt1[1] 
            b {.inject.} = pt2[1]
        result.add(operation)
    result

var map: HashSet[seq[int]]

for line in lines "input.txt":
    var ptPrev: seq[int]
    for pt in line.split(" -> ").mapIt(it.split(',').mapIt(it.parseInt())):
        if ptPrev != @[]:
            let vec = opPt(pt, ptPrev, sgn(a - b))
            var ptCur = opPt(ptPrev, vec, a + b)
            while ptCur != pt:
                map.incl ptCur
                ptCur = opPt(ptCur, vec, a + b)

        map.incl pt
        ptPrev = pt

# for y in 0..172:
#     for x in 440..560:
#         if map.contains @[x, y]: stdout.write '#' else: stdout.write '.'
#     stdout.write "\n"

let aboveFloorY = 1 + map.items.toSeq.mapIt(it[1]).max
var nSand = 0

while true:
    var ptSand = @[500, 0]
    while true:
        if ptSand[1] == aboveFloorY:
            map.incl ptSand
            nSand.inc
            break

        if not map.contains opPt(ptSand, @[0, 1], a + b):
            ptSand = opPt(ptSand, @[0, 1], a + b)
        elif not map.contains opPt(ptSand, @[-1, 1], a + b):
            ptSand = opPt(ptSand, @[-1, 1], a + b)
        elif not map.contains opPt(ptSand, @[1, 1], a + b):
            ptSand = opPt(ptSand, @[1, 1], a + b)
        else:
            map.incl ptSand
            nSand.inc
            break

    if ptSand == @[500, 0]:
        break

echo nSand

    