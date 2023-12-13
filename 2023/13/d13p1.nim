import sugar
import sequtils
import strutils

var sum = 0

for pattern in readFile("input.txt").split("\n\n").mapIt(it.split):
    var foundMatch = false

    for nRowsLeft in 1..pattern.len-1:
        var lo = nRowsLeft - 1
        var hi = nRowsLeft

        var allMatch = true

        while lo >= pattern.low and hi <= pattern.high:
            if pattern[lo] != pattern[hi]:
                allMatch = false
                break
            lo.dec
            hi.inc
        
        if allMatch:
            sum.inc nRowsLeft * 100
            foundMatch = true
            break

    if foundMatch:
        continue

    let patternCols = (pattern[0].low..pattern[0].high).mapIt(pattern.map(row => row[it]))

    for nRowsLeft in 1..patternCols.len-1:
        var lo = nRowsLeft - 1
        var hi = nRowsLeft

        var allMatch = true

        while lo >= patternCols.low and hi <= patternCols.high:
            if patternCols[lo] != patternCols[hi]:
                allMatch = false
                break
            lo.dec
            hi.inc
        
        if allMatch:
            sum.inc nRowsLeft
            break

echo sum
