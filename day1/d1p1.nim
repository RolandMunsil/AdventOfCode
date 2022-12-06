import strutils

var maxCals = 0

var curCals = 0

let inputFile: File = io.open("input.txt")
while not inputFile.endOfFile():
    let line = inputFile.readLine()

    if line.isEmptyOrWhitespace():
        if curCals > maxCals: maxCals = curCals
        curCals = 0
    else:
        curCals += line.parseInt()

echo maxCals
    