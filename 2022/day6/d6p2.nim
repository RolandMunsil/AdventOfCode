import sequtils

var last14: array[14, char]

for i, ch in readFile("input.txt"):
    last14[i mod 14] = ch

    if i >= 13 and last14.deduplicate.len == 14:
        echo i + 1
        break