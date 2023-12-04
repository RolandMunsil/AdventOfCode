import sequtils
import strutils

# initial solution

var sum = 0
for line in lines "input.txt":
    let digits = line.filterIt(it.isDigit)
    sum.inc parseInt(digits[0] & digits[^1])
echo sum

# one-liner (which i made after reviewing nim docs)

echo lines("input.txt").toSeq.mapIt(it.filterIt(it.isDigit)).mapIt(parseInt(it[0] & it[^1])).foldl(a + b)

# more efficient one-liner

echo lines("input.txt").toSeq.mapIt(parseInt(it[it.find(Digits)] & it[it.rfind(Digits)])).foldl(a + b)