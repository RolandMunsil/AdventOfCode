import strscans
import sequtils
import strutils
import tables

func usedSpace(bin: seq[int]): int = bin.foldl(a + b, 0) + bin.len - 1

# var tabs = ""

var table: Table[(seq[int], string), int]

proc nArrangements(sizes: seq[int], row: string): int = 
    let key = (sizes, row)
    if table.hasKey(key):
        return table[key]
    
    let wiggleRoom = row.len - usedSpace(sizes)

    # debugEcho sizes, ' ', row

    # if wiggleRoom < 0:
    #     return 0

    let iMaxSize = sizes.maxIndex
    let maxSize = sizes[iMaxSize]
    let sizesBelow = if iMaxSize > sizes.low: sizes[0..iMaxSize-1] else: @[]
    let sizesAbove = if iMaxSize < sizes.high: sizes[iMaxSize+1..^1] else: @[]
    let iChLowStart = sizesBelow.foldl(a + b, 0) + sizesBelow.len
    let iChHighStart = iChLowStart + wiggleRoom

    result = 0

    # tabs &= '\t'

    for iChStart in iChLowStart..iChHighStart:
        let iChEnd = iChStart + maxSize - 1
        if iChStart > row.low and row[iChStart - 1] == '#':
            continue
        if iChEnd < row.high and row[iChEnd + 1] == '#':
            continue
        if row[iChStart..iChEnd].anyIt(it == '.'):
            continue

        var thisResult = 1

        if sizesBelow.len == 0:
            if iChStart-2 >= row.low and row[row.low..iChStart-2].anyIt(it == '#'):
                thisResult = 0
        else:
            let rowBelow = row[row.low..iChStart - 2]
            thisResult *= nArrangements(sizesBelow, rowBelow)
        
        if sizesAbove.len == 0:
            if iChEnd+2 <= row.high and row[iChEnd+2..row.high].anyIt(it == '#'):
                thisResult = 0
        else:
            let rowAbove = row[iChEnd + 2..row.high]
            thisResult *= nArrangements(sizesAbove, rowAbove)

        result += thisResult

    # tabs = tabs[0..tabs.high-1]

    table[key] = result
    # debugEcho tabs,row, " + ", sizes, " => ", result

var sum = 0

for line in lines "input.txt":
    let (_, rowBit, sizesStr) = line.scanTuple("$* $*$.")
    let sizesBit = sizesStr.split(',').mapIt(it.parseInt)

    var row = rowBit & '?' & rowBit & '?' & rowBit & '?' & rowBit & '?' & rowBit
    let sizes = sizesBit & sizesBit & sizesBit & sizesBit & sizesBit

    row = row.split('.').filterIt(it.len > 0).join(".")

    sum.inc nArrangements(sizes, row)
    echo sum, " tbl: ", table.len
    # discard readLine(stdin)

echo sum