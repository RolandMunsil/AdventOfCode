import strscans
import sequtils
import math

type Pos = tuple
    x: int
    y: int

var knots: seq[Pos] = (0, 0).repeat(10) # 0 = head, 9 = tail
var tailTrail: seq[Pos]

tailTrail.add knots[9]

func handleMove(pH: var Pos, pT: var Pos) =
    let diff: Pos = (pH.x - pT.x , pH.y - pT.y)
    if max(diff.x.abs, diff.y.abs) < 2:
        return
    else:
        pT = (pT.x + diff.x.sgn, pT.y + diff.y.sgn)

for line in lines "input.txt":
    var 
        dir: char
        amnt: int
    discard line.scanf("$c $i", dir, amnt)

    for n in 1..amnt:
        case dir:
            of 'R': inc knots[0].x
            of 'L': dec knots[0].x
            of 'U': inc knots[0].y
            of 'D': dec knots[0].y
            else: discard

        for i in 0..<knots.len - 1:
            handleMove(knots[i], knots[i + 1])

        if tailTrail[^1] != knots[9]: tailTrail.add knots[9]
                    
echo tailTrail.deduplicate.len