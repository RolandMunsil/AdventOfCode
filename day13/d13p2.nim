import algorithm
import sequtils
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

proc cmpPackets(x: string, y: string): int =
    strL = x
    strR = y
    iL = 1
    iR = 1
    return compareLists()

var packets = "input.txt".lines.toSeq.filterIt(not it.isEmptyOrWhitespace)
packets.add "[[2]]"
packets.add "[[6]]"
packets.sort(cmpPackets)
echo (packets.find("[[2]]") + 1) * (packets.find("[[6]]") + 1)