import sequtils
import strutils

func strFromSeq(s: seq[char]): string =
    result = newStringOfCap(s.len)
    for c in s:
        result.add(c)

let nums = 
    lines("input.txt")
    .toSeq
    .mapIt(it.filterIt(it.isDigit))
    .map(strFromSeq)
    .map(parseInt)

let time = nums[0]
let dist = nums[1]

var nWays = 0

for msHold in 0..time:
    let ms = (time - msHold) * msHold
    if ms >= dist: nWays.inc

echo nWays