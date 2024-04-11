import math
import sequtils
import strformat
import strscans
import strutils

func pmod(a, b: int64): int64 = ((a mod b) + b) mod b

type Vec = tuple[x, y, z: int64]
proc `+`(v1: Vec, v2: Vec): Vec = (v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
proc `-`(v1: Vec, v2: Vec): Vec = (v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
proc `*`(v1: Vec, n: int): Vec = (v1.x * n, v1.y * n, v1.z * n)

# func lineIntersectsRayAtIntegerStepAlongRay(pos1, vel1, pos2, vel2: Vec): bool =
#     let
#         x1 = pos1.x
#         y1 = pos1.y
#         vx1 = vel1.x
#         vy1 = vel1.y
#         x2 = pos2.x
#         y2 = pos2.y
#         vx2 = vel2.x
#         vy2 = vel2.y

#     let t = (float(y1 - y2) + ((vy1 / vx1) * float(x2 - x1))) / (vy2.float - ((vy1 / vx1) * vx2.float))
#     # let a = ((x2 - x1) + (vx2 * b)) / vx1

#     debugEcho pos1
#     debugEcho vel1
#     debugEcho pos2
#     debugEcho vel2
#     debugEcho b

#     if t == Inf: return false
#     if t < 0: return false

#     let possibleCrossPt: Vec = (round(float(x2 + vx2) * t).int64, round(float(y2 + vy2) * t).int64, round(float(pos2.z + vel2.z) * t).int64)

#     debugEcho possibleCrossPt

#     if abs((possibleCrossPt.x - pos2.x).pmod vel2.x) != 0: return false
#     if abs((possibleCrossPt.y - pos2.y).pmod vel2.y) != 0: return false
#     if abs((possibleCrossPt.z - pos2.z).pmod vel2.z) != 0: return false

#     return true



type Hailstone = object
    pos, vel: Vec

var hailstones: seq[Hailstone]

for line in lines "input.txt":
    var hailstone: Hailstone
    var bits = line.split(" @ ").mapIt(it.split(", "))
    hailstone.pos.x = bits[0][0].parseBiggestInt
    hailstone.pos.y = bits[0][1].parseBiggestInt
    hailstone.pos.z = bits[0][2].parseBiggestInt
    hailstone.vel.x = bits[1][0].parseBiggestInt
    hailstone.vel.y = bits[1][1].parseBiggestInt
    hailstone.vel.z = bits[1][2].parseBiggestInt
    # echo hailstone

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

        try:
            let b = ((y1 - y2) + ((vy1 / vx1) * (x2 - x1))) / (vy2 - ((vy1 / vx1) * vx2))
            # let b = -((-vx1)*(y1-y2)-(-vy1)*(x1-x2)) / ((-vx1)*(-vy2)-(-vy1)*(-vx2))
            let a = ((x2 - x1) + (vx2 * b)) / vx1

            #echo hailstone
            #echo hailstoneOther
            if a == Inf:
                # echo "No intersection"
                continue

            # echo &"  a={a}"
            # echo &"  b={b}"
            
            let nA = round(a).int
            let nB = round(b).int

            let pA = hailstone.pos + hailstone.vel * nA
            let pB = hailstoneOther.pos + hailstoneOther.vel * nB
            # echo &"  pA={pA}"
            # echo &"  pB={pB}"

            if pA == pB:
                echo "WOWZA!!!!!"
                assert false
        except:
            echo "uh oh"

        # if a < 0 or b < 0:
        #     # echo "Crossed in past"
        #     continue

        # let crossPt = (x1 + vx1 * a, y1 + vy1 * a)
        # if crossPt[0] >= 200000000000000f and crossPt[1] >= 200000000000000f and crossPt[0] <= 400000000000000f and crossPt[1] <= 400000000000000f:
        #     # echo &"{crossPt} - within test area"
        #     nIntersect.inc
        # # else:
        #     # echo &"{crossPt} - outside test area"
        # # echo ""

    hailstones.add(hailstone)

# for h in hailstones:
    # block:
    #     let sameX = hailstones.filterIt(it.pos.x == h.pos.x)
    #     if sameX.len > 1: echo &"sameX: {sameX}"

    #     let sameY = hailstones.filterIt(it.pos.y == h.pos.y)
    #     if sameY.len > 1: echo &"sameY: {sameY}"

    #     let sameZ = hailstones.filterIt(it.pos.z == h.pos.z)
    #     if sameZ.len > 1: echo &"sameZ: {sameZ}"  

    # let sameV = hailstones.filterIt(it.vel == h.vel)
    # if sameV.len > 1: echo &"sameV: {sameV}"

    # block:
    #     let sameX = hailstones.filterIt(it.vel.x == h.vel.x)
    #     if sameX.len > 1: echo &"sameX: {sameX}"

    #     let sameY = hailstones.filterIt(it.vel.y == h.vel.y)
    #     if sameY.len > 1: echo &"sameY: {sameY}"

    #     let sameZ = hailstones.filterIt(it.vel.z == h.vel.z)
    #     if sameZ.len > 1: echo &"sameZ: {sameZ}"

echo "done"
# let h1 = hailstones[0]
# let h2 = hailstones[1]

# for t1 in 0..1000:
#     for t2 in 0..1000:
#         let pos = h1.pos + h1.vel * t1
#         var vel = (h2.pos + h2.vel * t2) - pos
#         let gcd = vel.x.gcd vel.y.gcd vel.z
#         vel.x = vel.x div gcd
#         vel.y = vel.y div gcd
#         vel.z = vel.z div gcd

#         for hailstone in hailstones:
#             if lineIntersectsRayAtIntegerStepAlongRay(pos, vel, hailstone.pos, hailstone.vel):
#                 echo &"found! {pos} @ {vel}"


