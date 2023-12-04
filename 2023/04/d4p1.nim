import strscans
import strutils
import sequtils
import bitops

var pts = 0

for line in lines "input.txt":
    var
        cardNum: int # ignored
        strWinningNums: string
        strHaveNums: string
    assert line.scanf("Card$s$i: $*| $*$.", cardNum, strWinningNums, strHaveNums)

    let winningNums = strWinningNums.splitWhitespace.mapIt(parseInt(it))
    let haveNums = strHaveNums.splitWhitespace.mapIt(parseInt(it))
    let nHaveWinning = haveNums.filterIt(it in winningNums).len

    if nHaveWinning > 0: pts.inc (1 shl (nHaveWinning - 1))

echo pts