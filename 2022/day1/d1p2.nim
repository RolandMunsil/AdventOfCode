import strutils
import algorithm

var 
    elfCals: seq[int]
    curCals = 0

let inputFile: File = io.open("input.txt")
while not inputFile.endOfFile():
    let line = inputFile.readLine()

    if line.isEmptyOrWhitespace():
        elfCals.add(curCals)
        curCals = 0
    else:
        curCals += line.parseInt()

elfcals.sort(order = SortOrder.Descending)

echo elfcals[0] + elfcals[1] + elfcals[2]
    