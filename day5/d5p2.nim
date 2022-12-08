import strutils
import strscans
import sequtils

const nStacks = 9

var stacks: array[1..nStacks, seq[char]]

for line in lines "input.txt":
    if line.len == 0: continue
    if line[1] == '1': continue

    if line.startsWith "move":
        var nCargo, src, dst: int
        discard line.scanf("move $i from $i to $i", nCargo, src, dst)
        stacks[dst].add stacks[src][^nCargo..^1]
        stacks[src] = stacks[src][0 ..< ^nCargo]
    else:
        for i in 1..nStacks:
            let ch = line[i * 4 - 3]
            if ch != ' ': stacks[i].insert(ch, 0)

func top(stack: seq[char]): char = stack[^1]
echo stacks.map(top).join()