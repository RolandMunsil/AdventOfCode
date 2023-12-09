import sequtils
import strutils

var sum = 0

for line in lines "input.txt":
    var pyramid: seq[seq[int]]
    pyramid.add line.splitWhitespace.mapIt(parseInt(it))

    while not pyramid[^1].allIt(it == 0):
        let topLevel = pyramid[^1]
        var newLevel: seq[int]

        for i in 1..<topLevel.len:
            newLevel.add(topLevel[i] - topLevel[i - 1])
        
        pyramid.add newLevel
    
    sum.inc pyramid.mapIt(it[^1]).foldl(a + b)

echo sum