import strscans
import sequtils

type Pos = tuple
    x: int
    y: int

var pH: Pos = (0, 0)
var pT: Pos = (0, 0)

var tailTrail: seq[Pos]

tailTrail.add pT

for line in lines "input.txt":
    var 
        dir: char
        amnt: int
    
    discard line.scanf("$c $i", dir, amnt)
    for n in 1..amnt:
        case dir:
        of 'R':
            inc pH.x
            if pH.x == pT.x + 2:
                pT = (pH.x - 1, pH.y)
                tailTrail.add pT
        of 'L':
            dec pH.x
            if pH.x == pT.x - 2:
                pT = (pH.x + 1, pH.y)
                tailTrail.add pT
        of 'U':
            inc pH.y
            if pH.y == pT.y + 2:
                pT = (pH.x, pH.y - 1)
                tailTrail.add pT
        of 'D':
            dec pH.y
            if pH.y == pT.y - 2:
                pT = (pH.x, pH.y + 1)
                tailTrail.add pT
        else:
            discard

echo tailTrail.deduplicate.len