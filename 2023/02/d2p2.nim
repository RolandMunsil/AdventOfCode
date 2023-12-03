import sequtils
import strscans
import strutils

var sum = 0

for line in lines "input.txt":
    var 
        gameNum: int
        cubesStr: string
    
    assert line.scanf("Game $i: $*$.", gameNum, cubesStr)

    var minRed = 0
    var minGreen = 0
    var minBlue = 0

    for cubeSet in cubesStr.split(';').mapIt(it.split(',').mapIt(it.splitWhitespace)):
        for countAndColor in cubeSet:
            let nCubes = parseInt(countAndColor[0])

            if countAndColor[1] == "red":
                minRed = max(nCubes, minRed)
            if countAndColor[1] == "green":
                minGreen = max(nCubes, minGreen)      
            if countAndColor[1] == "blue":
                minBlue = max(nCubes, minBlue)  
        
    sum.inc minBlue * minGreen * minRed

echo sum