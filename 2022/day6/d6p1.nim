var last4: array[4, char]

for i, ch in readFile("input.txt"):
    last4[i mod 4] = ch

    if i >= 3 and
        last4[3] notin last4[0..2] and
        last4[2] notin last4[0..1] and
        last4[1] != last4[0]:
            echo i + 1
            break