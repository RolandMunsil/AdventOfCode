import sequtils
import strutils
import sets
import tables

let lines = lines("input.txt").toSeq

# find symbol locations

var gearList: seq[(int, int)]

for y in 0..<lines.len:
    for x in 0..<lines[y].len:
        let c = lines[y][x]
        if c == '*':
            gearList.add((x, y))

# grab numbers

var gearToNearPartNums: Table[(int, int), seq[int]]

for y in 0..<lines.len:
    var curNum = 0
    var nearbyGears: HashSet[(int, int)]
    for x in 0..<lines[y].len:
        let c = lines[y][x]

        if c.isDigit:
            curNum = curNum * 10 + (c.ord - '0'.ord)

            # check if this number is next to a gear

            for xOffs in -1..1:
                for yOffs in -1..1:
                    let pos = (x + xOffs, y + yOffs)
                    if gearList.contains pos:
                        nearbyGears.incl pos
        else:
            if curNum != 0:
                for gear in nearbyGears:
                    gearToNearPartNums.mgetOrPut(gear, @[]).add(curNum)
            curNum = 0
            nearbyGears.clear

    if curNum != 0:
        for gear in nearbyGears:
            gearToNearPartNums.mgetOrPut(gear, @[]).add(curNum)

echo gearToNearPartNums.values.toSeq.filterIt(it.len == 2).mapIt(it[0] * it[1]).foldl(a + b)