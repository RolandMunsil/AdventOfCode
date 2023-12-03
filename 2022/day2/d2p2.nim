proc `+%`(x, y: int): int =
    result = x mod y
    if result < 0: result += y

var score = 0

let inputFile: File = io.open("input.txt")
while not inputFile.endOfFile():
    let line = inputFile.readLine()
    let elfPlay = ord(line[0]) - ord('A')
    let myGoal = ord(line[2]) - ord('X')

    let myPlay = (elfPlay + (myGoal - 1)) +% 3

    score += myPlay + 1
    if elfPlay == myPlay:
        score += 3
    elif ((myPlay - elfPlay) +% 3) == 1:
        score += 6

echo score