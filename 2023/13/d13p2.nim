import sugar
import sequtils
import strutils


proc getReflecVals(pattern: seq[string]): seq[int] = 
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
        
        if allMatch: result.add nRowsLeft * 100

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

        if allMatch: result.add nRowsLeft

var sum = 0

for pattern in readFile("input.txt").split("\n\n").mapIt(it.splitWhitespace):
    block findVal:
        let incorrect = getReflecVals(pattern)[0]

        for r in pattern.low..pattern.high:
            for c in pattern[r].low..pattern[r].high:
                var patternCopy = pattern
                if pattern[r][c] == '#':
                    patternCopy[r][c] = '.'
                else:
                    patternCopy[r][c] = '#'
                
                let vals = getReflecVals(patternCopy).filterIt(it != incorrect)

                if vals.len > 0:
                    sum.inc vals[0]
                    break findVal
        
        assert false

echo sum
