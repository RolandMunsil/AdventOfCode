import sequtils

let grid = "input.txt".lines.toSeq

template rowScore(strRow: typed, colCh: int): int =
    var 
        leftBlockerCol = 0
        rightBlockerCol = strRow.len - 1
    for col, ch in strRow:
        if ch >= strRow[colCh]:
            if col < colCh: leftBlockerCol = col
            elif col > colCh: 
                rightBlockerCol = col
                break

    (colCh - leftBlockerCol) * (rightBlockerCol - colCh)

var bestScore = 0

for row, strRow in grid:
    for col, ch in strRow:
        let strCol = grid.mapIt(it[col])
        bestScore = bestScore.max(rowScore(strRow.toSeq, col) * rowScore(strCol, row))

echo bestScore