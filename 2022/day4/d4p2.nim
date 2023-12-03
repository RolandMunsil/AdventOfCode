import parseutils

var count = 0

for line in lines "input.txt":
    var n: array[4, int]
    var ch = 0
    for i in 0..<4: ch += parseInt(line, n[i], ch) + 1
    if (n[0] <= n[3] and n[1] >= n[2]): inc count

echo count
