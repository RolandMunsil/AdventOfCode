import sequtils
import strutils

let lines = lines("input.txt").toSeq

# find symbol locations

var symbolPosList: seq[(int, int)]

for y in 0..<lines.len:
    for x in 0..<lines[y].len:
        let c = lines[y][x]
        if not c.isDigit and c != '.':
            symbolPosList.add((x, y))

# grab numbers

var sum = 0

for y in 0..<lines.len:
    var curNum = 0
    var nextToSymbol = false
    for x in 0..<lines[y].len:
        let c = lines[y][x]

        if c.isDigit:
            curNum = curNum * 10 + (c.ord - '0'.ord)

            # check if this number is next to a digit

            if not nextToSymbol:
                for xOffs in -1..1:
                    for yOffs in -1..1:
                        if symbolPosList.contains((x + xOffs, y + yOffs)):
                            nextToSymbol = true
        else:
            if curNum != 0 and nextToSymbol:
                sum.inc curNum
            curNum = 0
            nextToSymbol = false

    if curNum != 0 and nextToSymbol:
        sum.inc curNum

echo sum