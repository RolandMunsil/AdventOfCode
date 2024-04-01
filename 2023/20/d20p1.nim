import deques
import sequtils
import strformat
import strscans
import strutils
import tables

type ModuleKind = enum broadcast, flipflop, conjunction
type PulseKind = enum lo, hi

type Module = object
    kind: ModuleKind
    dests: seq[string]
    ffState: bool
    conjState: Table[string, PulseKind]

# load modules

var modules: Table[string, Module]

for line in lines "input.txt":
    var module: Module
    var strDests: string

    if line.startsWith("broadcaster"):
        assert line.scanf("broadcaster -> $*", strDests)
        module.kind = broadcast
        module.dests = strDests.split(", ")
        modules["broadcaster"] = module
    else: 
        var moduleName: string
        
        if line[0] == '%':
            assert line.scanf("%$w -> $*", moduleName, strDests)
            module.kind = flipflop
            module.ffState = false
            module.dests = strDests.split(", ")
        elif line[0] == '&':
            assert line.scanf("&$w -> $*", moduleName, strDests)
            module.kind = conjunction
            module.dests = strDests.split(", ")
        
        modules[moduleName] = module

# setup memory banks for conjunction modules

for name, module in modules:
    for dest in module.dests:
        if dest notin modules: continue
            
        if modules[dest].kind == conjunction:
            modules[dest].conjState[name] = lo

var loPulseCt: uint64 = 0
var hiPulseCt: uint64 = 0

proc pushButton() =
    loPulseCt.inc # button push

    var toProcess = modules["broadcaster"].dests.mapIt(("broadcaster", it, lo)).toDeque

    while toProcess.len > 0:
        var (source, dest, pulsekind) = toProcess.popFirst()
        if pulsekind == lo: loPulseCt.inc else: hiPulseCt.inc
        # echo &"{source} -{pulsekind}-> {dest}"
        if dest notin modules: continue

        var pModuleDest = addr modules[dest]

        if pModuleDest[].kind == flipflop and pulsekind == lo:
            pModuleDest[].ffState = not pModuleDest[].ffState

            let pulseBroadcast = if pModuleDest[].ffState: hi else: lo

            for newDest in pModuleDest[].dests: toProcess.addLast((dest, newDest, pulseBroadcast))
        elif pModuleDest[].kind == conjunction:
            pModuleDest[].conjState[source] = pulsekind
            
            let pulseBroadcast = if pModuleDest[].conjState.values.toSeq.allIt(it == hi): lo else: hi

            for newDest in pModuleDest[].dests: toProcess.addLast((dest, newDest, pulseBroadcast))

for n in 1..1000:
    pushButton()

echo loPulseCt * hiPulseCt
