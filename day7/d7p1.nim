import strscans
import strutils
import tables
import sequtils

var
    curPath: seq[string]
    pathToSize: CountTable[string]

for line in lines "input.txt":
    var 
        dir: string
        fsize: int
        fname: string
    
    if line.scanf("$$ cd $*$.", dir):
        case dir
        of "..": discard curPath.pop()
        of "/": curPath = @["/"]
        else: curPath.add dir
    elif line.scanf("$i $*$.", fsize, fname):
        for n in 1..curPath.len:
            pathToSize.inc(curPath[0..n-1].join("|"), fsize)

echo pathToSize.values.toSeq.filterIt(it <= 100_000).foldl(a + b)