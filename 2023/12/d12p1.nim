import strscans
import sequtils
import strutils
import bitops


var sum = 0 

for line in lines "input.txt":
    let (_, row, sizesStr) = line.scanTuple("$* $*$.")
    let sizes = sizesStr.split(',').mapIt(it.parseInt)

    let nUnknown = row.countIt(it == '?')

    for k in 0..<(1 shl nUnknown):
        var curSizes = sizes
        var curBit = nUnknown - 1

        var chPrev = '.'
        var matches = true

        for ch in row:
            var chR = ch
            if ch == '?':
                assert curBit >= 0
                if k.testBit(curBit):
                    chR = '#'
                else:
                    chR = '.'
                curBit.dec

            if chR == '.' and chPrev == '#':
                if curSizes[0] == 0:
                    curSizes.delete(0)
                else:
                    matches = false
                    break
            elif chR == '#':
                if curSizes.len == 0:
                    matches = false
                    break
                curSizes[0].dec

            chPrev = chR
        
        if chPrev == '#':
            if curSizes[0] == 0:
                curSizes.delete(0)
            else:
                matches = false
        
        if curSizes.len != 0:
            matches = false

        if matches: sum.inc

echo sum