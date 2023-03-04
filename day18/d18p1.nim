import strscans
import sets

var setCubePos: HashSet[(int, int, int)]
var surfaceArea = 0

for line in lines "input.txt":
    var x, y, z: int
    discard line.scanf("$i,$i,$i", x, y, z)
    setCubePos.incl((x, y, z))

    let neighbors = [
        (x+1, y  , z  ),
        (x-1, y  , z  ),
        (x  , y+1, z  ),
        (x  , y-1, z  ),
        (x  , y  , z+1),
        (x  , y  , z-1),
    ]

    for neighbor in neighbors:
        if neighbor in setCubePos:
            surfaceArea.dec
        else:
            surfaceArea.inc

echo surfaceArea

