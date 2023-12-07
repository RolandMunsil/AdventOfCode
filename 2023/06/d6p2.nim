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

echo (0..time).countIt(((time - it) * it) > dist)