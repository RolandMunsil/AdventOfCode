import strutils

var sum = 0
for line in lines "input.txt":
    var firstDigit: char

    for i in 0..<line.len:
        if line[i].isDigit:
            firstDigit = line[i]
            break
        if line.continuesWith("one", i):
            firstDigit = '1'
            break
        if line.continuesWith("two", i):
            firstDigit = '2'
            break
        if line.continuesWith("three", i):
            firstDigit = '3'
            break
        if line.continuesWith("four", i):
            firstDigit = '4'
            break
        if line.continuesWith("five", i):
            firstDigit = '5'
            break
        if line.continuesWith("six", i):
            firstDigit = '6'
            break
        if line.continuesWith("seven", i):
            firstDigit = '7'
            break
        if line.continuesWith("eight", i):
            firstDigit = '8'
            break
        if line.continuesWith("nine", i):
            firstDigit = '9'
            break

    var lastDigit: char

    for i in countdown(line.len - 1, 0):
        if line[i].isDigit:
            lastDigit = line[i]
            break
        if line.continuesWith("one", i):
            lastDigit = '1'
            break
        if line.continuesWith("two", i):
            lastDigit = '2'
            break
        if line.continuesWith("three", i):
            lastDigit = '3'
            break
        if line.continuesWith("four", i):
            lastDigit = '4'
            break
        if line.continuesWith("five", i):
            lastDigit = '5'
            break
        if line.continuesWith("six", i):
            lastDigit = '6'
            break
        if line.continuesWith("seven", i):
            lastDigit = '7'
            break
        if line.continuesWith("eight", i):
            lastDigit = '8'
            break
        if line.continuesWith("nine", i):
            lastDigit = '9'
            break

    sum.inc parseInt(firstDigit & lastDigit)
echo sum