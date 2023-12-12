import sequtils
import sugar

var image = lines("input.txt").toSeq.mapIt(it.toSeq)

# expand image

let emptyCols = collect(newSeq):
    for col in countdown(image[0].high, 0):
        if image.mapIt(it[col]).allIt(it == '.'): col

var iRow = 0
while iRow <= image.high:
    var row = image[iRow]

    for emptyCol in emptyCols:
        row.insert('.', emptyCol)
    
    image[iRow] = row

    if row.allIt(it == '.'):
        image.insert(row, iRow)
        iRow.inc
    
    iRow.inc

# find galaxies

let galaxies = collect(newSeq):
    for r, row in image:
        for c, col in row:
            if col == '#': (r, c)

var sum = 0

for i1, g1 in galaxies:
    for i2 in (i1+1)..galaxies.high:
        let g2 = galaxies[i2]
        sum.inc abs(g1[0] - g2[0]) + abs(g1[1] - g2[1])

echo sum