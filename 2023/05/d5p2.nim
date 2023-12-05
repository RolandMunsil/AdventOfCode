import sequtils
import strutils
import strscans
import strformat

type Range = tuple[start, len: int]
type RangeMap = tuple[destStart, srcStart, len: int]

let lines = lines("input.txt").toSeq

var seedNums = lines[0].split(':')[1].splitWhitespace.mapIt(parseInt(it))

var sourceRanges: seq[Range] = (0..<(seedNums.len div 2)).mapIt((seedNums[it * 2], seedNums[it * 2 + 1]))
var rangeMaps: seq[RangeMap]

var i = 3

while i < lines.len:
    let line = lines[i]

    if not line.isEmptyOrWhitespace:
        var r: RangeMap
        assert line.scanf("$i $i $i", r.destStart, r.srcStart, r.len)
        rangeMaps.add r
        i.inc
    else:
        # split the ranges so that every range is fully within a range map

        var unsplitRanges = sourceRanges
        var splitRanges: seq[Range]

        while unsplitRanges.len > 0:
            let srcRange = unsplitRanges.pop

            assert srcRange.len > 0

            var split = false

            for rm in rangeMaps:
                let srcRangeEnd = srcRange.start + srcRange.len
                let rmSrcEnd = rm.srcStart + rm.len

                # range crosses low end of range map

                if srcRange.start < rm.srcStart and srcRangeEnd > rm.srcStart:
                    unsplitRanges.add (srcRange.start, rm.srcStart - srcRange.start)
                    unsplitRanges.add (rm.srcStart, srcRangeEnd - rm.srcStart)
                    split = true
                    break

                # range crosses high end of range map
            
                if srcRange.start < rmSrcEnd and srcRangeEnd > rmSrcEnd:
                    unsplitRanges.add (srcRange.start, rmSrcEnd - srcRange.start)
                    unsplitRanges.add (rmSrcEnd, srcRangeEnd - rmSrcEnd)
                    split = true
                    break
            
            if not split:
                splitRanges.add srcRange
        
        # process the ranges

        for splitRange in splitRanges.mItems:
            for rm in rangeMaps:
                if splitRange.start >= rm.srcStart and splitRange.start < rm.srcStart + rm.len:
                    splitRange.start = rm.destStart + (splitRange.start - rm.srcStart)
                    break

        sourceRanges = splitRanges

        # reset range maps and move to next range list

        rangeMaps.setLen 0
        i.inc 2



# split the ranges so that every range is fully within a range map

var unsplitRanges = sourceRanges
var splitRanges: seq[Range]

while unsplitRanges.len > 0:
    let srcRange = unsplitRanges.pop

    var split = false

    for rm in rangeMaps:
        let srcRangeEnd = srcRange.start + srcRange.len
        let rmSrcEnd = rm.srcStart + rm.len

        # range crosses low end of range map

        if srcRange.start < rm.srcStart and srcRangeEnd > rm.srcStart:
            unsplitRanges.add (srcRange.start, rm.srcStart - srcRange.start)
            unsplitRanges.add (rm.srcStart, srcRangeEnd - rm.srcStart)
            split = true
            break

        # range crosses high end of range map
    
        if srcRange.start < rmSrcEnd and srcRangeEnd > rmSrcEnd:
            unsplitRanges.add (srcRange.start, rmSrcEnd - srcRange.start)
            unsplitRanges.add (rmSrcEnd, srcRangeEnd - rmSrcEnd)
            split = true
            break
    
    if not split:
        splitRanges.add srcRange

# process the ranges

for splitRange in splitRanges.mItems:
    for rm in rangeMaps:
        if splitRange.start >= rm.srcStart and splitRange.start < rm.srcStart + rm.len:
            splitRange.start = rm.destStart + (splitRange.start - rm.srcStart)
            break

sourceRanges = splitRanges

echo sourceRanges.min.start