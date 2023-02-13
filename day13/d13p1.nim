import sequtils
import strformat
import strutils

var strL: string
var strR: string
var iL: int
var iR: int

proc chL(): char = strL[iL]
proc chR(): char = strR[iR]

proc compareLists(): int =
    # starts at first character after '['

    result = 0

    while true:
        if chL().isDigit and chR().isDigit:
            # compare as numbers

            var nL = 0
            while chL().isDigit:
                nL *= 10
                nL += chL().ord - '0'.ord
                iL.inc
            
            var nR = 0
            while chR().isDigit:
                nR *= 10
                nR += chR().ord - '0'.ord
                iR.inc
            
            result = cmp(nL, nR)
        elif chL() == '[' and chR() == '[':
            iL.inc
            iR.inc
            result = compareLists()
        elif chL().isDigit and chR() == '[':
            var iLLocal = iL
            while strL[iLLocal].isDigit: iLLocal.inc
            strL.insert("]", iLLocal)

            iR.inc
            result = compareLists()
        elif chL() == '[' and chR().isDigit:
            var iRLocal = iR
            while strR[iRLocal].isDigit: iRLocal.inc
            strR.insert("]", iRLocal)

            iL.inc
            result = compareLists()
        
        if result != 0: 
            return result

        if chL() == ',' and chR() == ',':
            iL.inc
            iR.inc
        elif chL() == ']' and chR() == ']':
            iL.inc
            iR.inc
            return 0
        elif chL() == ']' and chR() != ']':
            return -1
        elif chL() != ']' and chR() == ']':
            return 1
                
let lines = "input.txt".lines.toSeq

var i = 0
var sum = 0
while i < lines.len:
    strL = lines[i]
    strR = lines[i + 1]
    iL = 1
    iR = 1
    let res = compareLists()
    if res == -1:
        sum.inc i div 3 + 1
    i.inc 3
echo sum