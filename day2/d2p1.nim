proc `+%`(x, y: int): int =
    result = x mod y
    if result < 0: result += y

var score = 0

let inputFile: File = io.open("input.txt")
while not inputFile.endOfFile():
    let line = inputFile.readLine()
    let elfPlay = ord(line[0]) - ord('A')
    let myPlay = ord(line[2]) - ord('X')

    score += (myPlay + 1) + (((1 + myPlay - elfPlay) +% 3) * 3)

echo score