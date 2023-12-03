import strscans
import sets

type Pos = tuple[x, y, z: int]

func neighbors(pos: Pos): array[6, Pos] = 
    [
        (pos.x+1, pos.y  , pos.z  ),
        (pos.x-1, pos.y  , pos.z  ),
        (pos.x  , pos.y+1, pos.z  ),
        (pos.x  , pos.y-1, pos.z  ),
        (pos.x  , pos.y  , pos.z+1),
        (pos.x  , pos.y  , pos.z-1),
    ]

# Read in cubes

var setCubePos: HashSet[Pos]
var xMin, xMax, yMin, yMax, zMin, zMax = 1 

for line in lines "input.txt":
    var x, y, z: int
    discard line.scanf("$i,$i,$i", x, y, z)
    setCubePos.incl((x, y, z))

    xMin = xMin.min(x)
    xMax = xMax.max(x)

    yMin = yMin.min(y)
    yMax = yMax.max(y)

    zMin = zMin.min(z)
    zMax = zMax.max(z)

# Determine what counts as "outside"

var setOutsideCubes: HashSet[Pos]
var newOutsideCubes: seq[Pos] = @[(xMin - 1, yMin - 1, zMin - 1)]

while newOutsideCubes.len > 0:
    let newOutsideCube = newOutsideCubes.pop()

    for neighbor in neighbors(newOutsideCube):
        if neighbor.x < xMin - 1 or neighbor.x > xMax + 1:
            continue
        if neighbor.y < yMin - 1 or neighbor.y > yMax + 1:
            continue
        if neighbor.z < zMin - 1 or neighbor.z > zMax + 1:
            continue
        if neighbor in setOutsideCubes or neighbor in setCubePos:
            continue

        if neighbor notin newOutsideCubes: newOutsideCubes.add neighbor

    setOutsideCubes.incl newOutsideCube

# Determine surface area

var surfaceArea = 0

for cube in setCubePos:
    for neighbor in neighbors(cube):
        if neighbor in setOutsideCubes:
            surfaceArea.inc

echo surfaceArea

