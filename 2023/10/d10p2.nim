import sequtils
import sets

let grid = lines("input.txt").toSeq

var sPos: (int, int)

for r, row in grid:
    for c, ch in row:
        if ch == 'S':
            sPos = (r, c)
            break

proc pipeAt(tup: (int, int)): char = 
    if tup[0] < grid.low or tup[0] > grid.high:
        return '.'
    if tup[1] < grid[tup[0]].low or tup[1] > grid[tup[0]].high:
        return '.'
    return grid[tup[0]][tup[1]]

proc westPos(tup: (int, int)): (int, int) = (tup[0], tup[1] - 1)
proc eastPos(tup: (int, int)): (int, int) = (tup[0], tup[1] + 1)
proc northPos(tup: (int, int)): (int, int) = (tup[0] - 1, tup[1])
proc southPos(tup: (int, int)): (int, int) = (tup[0] + 1, tup[1])

func connectsWest(ch: char): bool = ch == '-' or ch == 'J' or ch == '7'
func connectsEast(ch: char): bool = ch == '-' or ch == 'L' or ch == 'F'
func connectsNorth(ch: char): bool = ch == '|' or ch == 'J' or ch == 'L'
func connectsSouth(ch: char): bool = ch == '|' or ch == 'F' or ch == '7'


var inPipe = toHashSet([sPos])
var loopEdges: seq[(int, int)]

var possibleSPipes = toHashSet(['-', '|', 'J', '7', 'L', 'F'])

if connectsEast(pipeAt(sPos.westPos)):
    loopEdges.add(sPos.westPos)
    possibleSPipes = possibleSPipes * toHashSet(['-', 'J', '7'])
if connectsWest(pipeAt(sPos.eastPos)):
    loopEdges.add(sPos.eastPos)
    possibleSPipes = possibleSPipes * toHashSet(['-', 'L', 'F'])
if connectsSouth(pipeAt(sPos.northPos)):
    loopEdges.add(sPos.northPos)
    possibleSPipes = possibleSPipes * toHashSet(['|', 'J', 'L'])
if connectsNorth(pipeAt(sPos.southPos)):
    loopEdges.add(sPos.southPos)
    possibleSPipes = possibleSPipes * toHashSet(['|', 'F', '7'])

let sPipe = possibleSPipes.pop

while loopEdges.len > 0:
    for e in loopEdges: inPipe.incl e

    var nextLoopEdges: seq[(int, int)]
    
    for loopEdge in loopEdges:
        if pipeAt(loopEdge).connectsWest and pipeAt(loopEdge.westPos).connectsEast and loopEdge.westPos notin inPipe:
            nextLoopEdges.add loopEdge.westPos
        elif pipeAt(loopEdge).connectsEast and pipeAt(loopEdge.eastPos).connectsWest and loopEdge.eastPos notin inPipe:
            nextLoopEdges.add loopEdge.eastPos
        elif pipeAt(loopEdge).connectsNorth and pipeAt(loopEdge.northPos).connectsSouth and loopEdge.northPos notin inPipe:
            nextLoopEdges.add loopEdge.northPos
        elif pipeAt(loopEdge).connectsSouth and pipeAt(loopEdge.southPos).connectsNorth and loopEdge.southPos notin inPipe:
            nextLoopEdges.add loopEdge.southPos
    
    loopEdges = nextLoopEdges

var nInside = 0

for r, row in grid:
    var passedNorthConnector = false
    var passedSouthConnector = false

    for c in 0..row.high:
        var ch = row[c]
        if ch == 'S': ch = sPipe

        if (r, c) in inPipe:
            if connectsNorth(ch): passedNorthConnector = not passedNorthConnector
            if connectsSouth(ch): passedSouthConnector = not passedSouthConnector
        else:
            if passedNorthConnector and passedSouthConnector:
                nInside.inc
    
echo nInside

