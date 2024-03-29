import strscans
import strutils
import sequtils

let lines = lines("input.txt").toSeq
var cardCt: seq[int]
cardCt.add(0) # Card 0 (which doesn't exist, but i want to make the indices match the card nums)
for i in 0..<lines.len: cardCt.add 1

for line in lines:
    var
        cardNum: int
        strWinningNums: string
        strHaveNums: string
    assert line.scanf("Card$s$i: $*| $*$.", cardNum, strWinningNums, strHaveNums)

    let winningNums = strWinningNums.splitWhitespace.mapIt(parseInt(it))
    let haveNums = strHaveNums.splitWhitespace.mapIt(parseInt(it))
    let nHaveWinning = haveNums.filterIt(it in winningNums).len

    for cardOffs in 1..nHaveWinning:
        cardCt[cardNum + cardOffs].inc cardCt[cardNum]

echo cardCt.foldl(a + b)