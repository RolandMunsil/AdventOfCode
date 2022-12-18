import strscans

var cyc = 0
var x = 1

proc emit(cyc: int, x: int) =
    let pos = cyc mod 40 
    if pos == 0: stdout.write '\n'
    stdout.write (if abs(pos - x) <= 1: '#' else: '.')

for line in lines "input.txt":
    if line == "noop":
        emit(cyc, x)
        inc cyc
    else:
        emit(cyc, x)
        var i: int
        discard line.scanf("addx $i", i)
        inc cyc
        emit(cyc, x)
        x += i
        inc cyc

stdout.flushFile