import sequtils

let grid = "input.txt".lines.toSeq

var visCount = 0

for row, strRow in grid:
    for col, ch in strRow:
        if row == 0 or col == 0 or row == grid.len - 1 or col == strRow.len - 1:
            visCount.inc
        elif strRow[0..col-1].allIt(it < ch):
            visCount.inc
        elif strRow[col+1..^1].allIt(it < ch):
            viscount.inc
        else:
            let strCol = grid.mapIt(it[col])

            if strCol[0..row-1].allIt(it < ch):
                visCount.inc
            elif strCol[row+1..^1].allIt(it < ch):
                viscount.inc

echo visCount