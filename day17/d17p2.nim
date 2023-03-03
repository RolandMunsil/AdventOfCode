import sequtils
import tables

type Pos = tuple[x: int, y: int]

func `+`(pos1: Pos, pos2: Pos): Pos = (pos1.x + pos2.x, pos1.y + pos2.y)

const shapes: array[5, seq[Pos]] = [
    @[(0, 0), (1, 0), (2, 0), (3, 0)],
    @[(1, 0), (0, 1), (2, 1), (1, 2)],
    @[(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)],
    @[(0, 0), (0, 1), (0, 2), (0, 3)],
    @[(0, 0), (1, 0), (0, 1), (1, 1)]
]

let jetPat = readFile "input.txt"
var iJetPat = 0

var stoppedRocks: seq[array[7, bool]]

proc isObstructed(pos: Pos): bool = 
    if pos.x < 0 or pos.x >= 7 or pos.y < 0:
        return true
    if pos.y > stoppedRocks.high:
        return false
    return stoppedRocks[pos.y][pos.x]

type CacheState = tuple
    iShape: int
    iJetPat: int
    stoppedRocksTopN: seq[array[7, bool]]

var startHeights: seq[int]
var stateToI: Table[CacheState, int]

const nShapes = 1000000000000

var i = 0
var nLayersMatter = 1

while i < nShapes:
    let startHeight = stoppedRocks.high + 1 # + 1 because high is a 0-based index
    startHeights.add(startHeight)

    var bottomLeft: Pos = (2, startHeight + 3)
    let iShape = i mod 5

    if startHeight >= nLayersMatter:
        let state = (iShape, iJetPat, stoppedRocks[^nLayersMatter..^1])
        
        if state notin stateToI:
            stateToI[state] = i
        else:
            let iMatch = stateToI[state]
            let matchStartHeight = startHeights[iMatch]

            let loopLen = i - iMatch
            let heightPerLoop = startHeight - matchStartHeight

            let remainShapes = nShapes - i

            var endHeight = 
                startHeight + 
                ((remainShapes div loopLen) * heightPerLoop) + # account for number of full loops
                (startHeights[iMatch + (remainShapes mod loopLen)] - matchStartHeight) # account for final shapes after last full loop

            echo endHeight
            break

    # Run sim

    while true:
        # Jet push

        if jetPat[iJetPat] == '>':
            bottomLeft.x.inc
            if shapes[iShape].anyIt((bottomLeft + it).isObstructed):
                bottomLeft.x.dec
        else:
            bottomLeft.x.dec
            if shapes[iShape].anyIt((bottomLeft + it).isObstructed):
                bottomLeft.x.inc

        iJetPat = (iJetPat + 1) mod jetPat.len

        # Move down
    
        bottomLeft.y.dec
        if shapes[iShape].anyIt((bottomLeft + it).isObstructed):
            bottomLeft.y.inc
            break

    # Adjust nLayersMatter based on number of layers that mattered

    let nLayersMattered = startHeight - bottomLeft.y + 1
    if nLayersMattered > nLayersMatter:
        nLayersMatter = nLayersMattered
        stateToI.clear()

    # Add rock to stoppedRocks

    for rockPos in shapes[iShape].mapIt(it + bottomLeft):
        while (rockPos.y > stoppedRocks.high):
            stoppedRocks.add([false, false, false, false, false, false, false])
            
        stoppedRocks[rockPos.y][rockPos.x] = true
  
    i.inc

if i == nShapes:
    # We didn't trigger the loop detection logic, so we still need to emit final height
    echo stoppedRocks.high + 1