import strscans

var cyc = 1
var x = 1

var sigsum = 0

for line in lines "input.txt":
    if line == "noop":
        if (cyc - 20) mod 40 == 0: sigsum += cyc * x
        inc cyc
    else:
        if (cyc - 20) mod 40 == 0: sigsum += cyc * x
        var i: int
        discard line.scanf("addx $i", i)
        inc cyc
        if (cyc - 20) mod 40 == 0: sigsum += cyc * x
        x += i
        inc cyc

echo sigsum