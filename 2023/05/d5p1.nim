import sequtils
import strutils
import strscans

type Range = tuple[destStart, srcStart, length: int]

let lines = lines("input.txt").toSeq

var sources = lines[0].split(':')[1].splitWhitespace.mapIt(parseInt(it))
var ranges: seq[Range]

var i = 3

while i < lines.len:
    let line = lines[i]

    if not line.isEmptyOrWhitespace:
        var r: Range
        assert line.scanf("$i $i $i", r.destStart, r.srcStart, r.length)
        ranges.add r
        i.inc
    else:
        # finalize

        for source in sources.mitems:
            for r in ranges:
                if source >= r.srcStart and source < r.srcStart + r.length:
                    source = r.destStart + (source - r.srcStart)
                    break

        ranges.setLen 0
        i.inc 2

for source in sources.mitems:
    for r in ranges:
        if source >= r.srcStart and source < r.srcStart + r.length:
            source = r.destStart + (source - r.srcStart)
            break

echo sources.min