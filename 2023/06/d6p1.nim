import sequtils
import strutils

let nums = 
    lines("input.txt")
    .toSeq
    .mapIt(it.splitWhitespace()[1..^1].mapIt(parseInt(it)))

var nWaysTotal = 1

for (time, dist) in zip(nums[0], nums[1]):
    var nWays = 0

    for msHold in 0..time:
        let mm = (time - msHold) * msHold
        if mm > dist: nWays.inc
    
    nWaysTotal *= nWays

echo nWaysTotal