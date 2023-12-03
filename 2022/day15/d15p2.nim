import sequtils
import strscans

type BeaconArea = tuple[x: int, y: int, dist: int]
func contains(ba: BeaconArea, x: int, y: int): bool = abs(ba.x - x) + abs(ba.y - y) <= ba.dist

var bas: seq[BeaconArea]

for line in lines "input.txt":
    var
        sensX: int
        sensY: int
        beacX: int
        beacY: int
    
    discard line.scanf("Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", sensX, sensY, beacX, beacY)

    let distance = abs(sensX - beacX) + abs(sensY - beacY)
    bas.add (sensX, sensY, distance)

block findBeacon:
    for ba in bas:
        let edgeDist = ba.dist+1
        for a in 0..edgeDist:
            let ia = edgeDist - a
            let cands = @[
                (ba.x + a, ba.y + ia),
                (ba.x - a, ba.y + ia),
                (ba.x + a, ba.y - ia),
                (ba.x - a, ba.y - ia)
            ]

            for cand in cands:
                let
                    x = cand[0]
                    y = cand[1]
                
                if x < 0 or x > 4000000 or y < 0 or y > 4000000:
                    continue
                elif not bas.anyIt(it.contains(cand[0], cand[1])):
                    echo cand[0] * 4000000 + cand[1]
                    break findBeacon

