import strformat
import strscans

type Vec = tuple[x, y, z: int]
type Hailstone = object
    pos, vel: Vec

var hailstones: seq[Hailstone]

var nIntersect = 0

for line in lines "input.txt":
    var hailstone: Hailstone
    discard line.scanf("$i,$s$i,$s$i$s@$s$i,$s$i,$s$i", 
        hailstone.pos.x, 
        hailstone.pos.y, 
        hailstone.pos.z, 
        hailstone.vel.x, 
        hailstone.vel.y,
        hailstone.vel.z)
    
    for hailstoneOther in hailstones:
        let
            x1 = hailstone.pos.x.float
            y1 = hailstone.pos.y.float
            vx1 = hailstone.vel.x.float
            vy1 = hailstone.vel.y.float
            x2 = hailstoneOther.pos.x.float
            y2 = hailstoneOther.pos.y.float
            vx2 = hailstoneOther.vel.x.float
            vy2 = hailstoneOther.vel.y.float

        let b = ((y1 - y2) + ((vy1 / vx1) * (x2 - x1))) / (vy2 - ((vy1 / vx1) * vx2))
        # let b = -((-vx1)*(y1-y2)-(-vy1)*(x1-x2)) / ((-vx1)*(-vy2)-(-vy1)*(-vx2))
        let a = ((x2 - x1) + (vx2 * b)) / vx1

        #echo hailstone
        #echo hailstoneOther
        if a == Inf:
            # echo "No intersection"
            continue

        if a < 0 or b < 0:
            # echo "Crossed in past"
            continue

        let crossPt = (x1 + vx1 * a, y1 + vy1 * a)
        if crossPt[0] >= 200000000000000f and crossPt[1] >= 200000000000000f and crossPt[0] <= 400000000000000f and crossPt[1] <= 400000000000000f:
            # echo &"{crossPt} - within test area"
            nIntersect.inc
        # else:
            # echo &"{crossPt} - outside test area"
        # echo ""

    hailstones.add(hailstone)

echo nIntersect