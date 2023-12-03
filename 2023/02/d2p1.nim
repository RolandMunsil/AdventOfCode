import sequtils
import strscans
import strutils

var sum = 0

for line in lines "input.txt":
    var 
        gameNum: int
        cubesStr: string
    
    assert line.scanf("Game $i: $*$.", gameNum, cubesStr)

    block confirmPossible: 
        for cubeSet in cubesStr.split(';').mapIt(it.split(',').mapIt(it.splitWhitespace)):
            for countAndColor in cubeSet:
                let nCubes = parseInt(countAndColor[0])

                if nCubes > 12 and countAndColor[1] == "red":
                    break confirmPossible
                if nCubes > 13 and countAndColor[1] == "green":
                    break confirmPossible                
                if nCubes > 14 and countAndColor[1] == "blue":
                    break confirmPossible
        
        sum.inc gameNum

echo sum