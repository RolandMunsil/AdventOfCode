import sequtils
import sugar

var image = lines("input.txt").toSeq.mapIt(it.toSeq)

let emptyRows = collect(newSeq):
    for r, row in image:
        if row.allIt(it == '.'): r

let emptyCols = collect(newSeq):
    for col in countdown(image[0].high, 0):
        if image.mapIt(it[col]).allIt(it == '.'): col

# find galaxies

let galaxies = collect(newSeq):
    for r, row in image:
        for c, col in row:
            if col == '#': (r, c)

const expansion = 999999

var sum = 0

for i1, g1 in galaxies:
    for i2 in (i1+1)..galaxies.high:
        let g2 = galaxies[i2]
        sum.inc abs(g1[0] - g2[0]) + abs(g1[1] - g2[1])

        for emptyRow in emptyRows:
            if g1[0] > g2[0] and g1[0] > emptyRow and emptyRow > g2[0]:
                sum.inc expansion
            elif g1[0] < g2[0] and g1[0] < emptyRow and emptyRow < g2[0]:
                sum.inc expansion

        for emptyCol in emptyCols:
            if g1[1] > g2[1] and g1[1] > emptyCol and emptyCol > g2[1]:
                sum.inc expansion
            elif g1[1] < g2[1] and g1[1] < emptyCol and emptyCol < g2[1]:
                sum.inc expansion

echo sum