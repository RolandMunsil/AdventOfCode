import sets
import strscans

var setXNoBeacon: HashSet[int]
var setXBeacon: HashSet[int]

const row = 2000000

for line in lines "input.txt":
    var
        sensX: int
        sensY: int
        beacX: int
        beacY: int
    
    discard line.scanf("Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", sensX, sensY, beacX, beacY)
    if beacY == row: setXBeacon.incl beacX

    let 
        distance = abs(sensX - beacX) + abs(sensY - beacY)
        yDist = abs(sensY - row)
        xRange = distance - yDist

    for xOff in -xRange..xRange:
        setXNoBeacon.incl sensX + xOff

for x in setXBeacon:
    setXNoBeacon.excl x

echo setXNoBeacon.len