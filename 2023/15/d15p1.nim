import strutils

var sum = 0

for step in readFile("input.txt").strip().split(","):
    var val: uint8 = 0

    for ch in step: val = uint8((val.int + ch.int) * 17)
    sum.inc val
echo sum