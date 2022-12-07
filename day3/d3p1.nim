var sum = 0

for line in lines "input.txt":
    let firstHalf = line[0..<(line.len div 2)]
    let secondHalf = line[(line.len div 2)..^1]
    
    for c in secondHalf:
        if c in firstHalf:
            sum += (int(c) and 0b1_1111) + ((not int(c) and 0b10_0000) shr 5) * 26
            break

echo sum