import sequtils

proc toCharSet(str: string): set[char] =
    for c in str: result.incl c

let lines = lines("input.txt").toSeq()

var sum = 0
for i in countup(0, lines.len - 1, 3):
    let c = (toCharSet(lines[i + 0]) * toCharSet(lines[i + 1]) * toCharSet(lines[i + 2])).toSeq()[0]
    sum += (int(c) and 0b1_1111) + ((not int(c) and 0b10_0000) shr 5) * 26
echo sum