import algorithm
import sequtils

type Pos = tuple[x: int, y: int]

func `+`(pos1: Pos, pos2: Pos): Pos = (pos1.x + pos2.x, pos1.y + pos2.y)

type Rock = object
    bottomLeft: Pos
    shape: seq[Pos]

const shapes = [
    @[(0, 0), (1, 0), (2, 0), (3, 0)],
    @[(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)],
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

proc isObstructed(rock: Rock): bool =
    rock.shape.anyIt((it + rock.bottomLeft).isObstructed)

# proc printDebug(rock: Rock) =
#     var strs = @["+-------+"]
#     for row in stoppedRocks:
#         var str = "|"
#         for x in 0..<7:
#             if row[x]:
#                 str.add '#'
#             else:
#                 str.add '.'
#         str.add '|'
#         strs.add str
    
#     for rockPos in rock.shape.mapIt(it + rock.bottomLeft):
#         while (1 + rockPos.y > strs.high):
#             strs.add("|.......|")
        
#         strs[1 + rockPos.y][1 + rockPos.x] = '@'

#     echo ""
#     for row in strs.reversed(): echo row


for i in 0..<2022:
    var rock = Rock(
        bottomLeft: (2, stoppedRocks.len + 3), 
        shape: shapes[i mod 5])

    # printDebug rock

    while true:
        # jet push

        let shift = if jetPat[iJetPat] == '>': 1 else: -1
        iJetPat = (iJetPat + 1) mod jetPat.len
        rock.bottomLeft.x += shift
        if rock.isObstructed:
            rock.bottomLeft.x -= shift

        # printDebug rock

        # move down
    
        rock.bottomLeft.y.dec
        if rock.isObstructed:
            rock.bottomLeft.y.inc
            break
        
        # printDebug rock
    
    for rockPos in rock.shape.mapIt(it + rock.bottomLeft):
        while (rockPos.y > stoppedRocks.high):
            stoppedRocks.add([false, false, false, false, false, false, false])
        
        stoppedRocks[rockPos.y][rockPos.x] = true
    
    # printDebug rock

    # discard readLine(stdin)

echo stoppedRocks.len
