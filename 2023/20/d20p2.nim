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

# echo "digraph {"
# for name, module in modules:
#     if module.kind == flipflop:
#         echo &"{name} [color=red]"
#     elif module.kind == conjunction:
#         echo &"{name} [color=blue]"
    
#     for dest in module.dests:
#         echo &"{name} -> {dest}"
# echo "}"

# setup memory banks for conjunction modules

for name, module in modules:
    for dest in module.dests:
        if dest notin modules: continue
            
        if modules[dest].kind == conjunction:
            modules[dest].conjState[name] = lo

let counterModuleNames = modules.pairs.toSeq.filterIt(it[1].kind == conjunction and it[1].dests.len > 1).mapIt(it[0])
var counterFirstTrigger: Table[string, int]

var pushCount = 0

proc pushButton() =
    var toProcess = modules["broadcaster"].dests.mapIt(("broadcaster", it, lo)).toDeque

    while toProcess.len > 0:
        var (source, dest, pulsekind) = toProcess.popFirst()
        if dest notin modules: continue

        var pModuleDest = addr modules[dest]

        if pModuleDest[].kind == flipflop and pulsekind == lo:
            pModuleDest[].ffState = not pModuleDest[].ffState

            let pulseBroadcast = if pModuleDest[].ffState: hi else: lo

            for newDest in pModuleDest[].dests: toProcess.addLast((dest, newDest, pulseBroadcast))
        elif pModuleDest[].kind == conjunction:
            pModuleDest[].conjState[source] = pulsekind
            
            let pulseBroadcast = if pModuleDest[].conjState.values.toSeq.allIt(it == hi): lo else: hi

            if pulseBroadcast == lo and dest in counterModuleNames and dest notin counterFirstTrigger:
                counterFirstTrigger[dest] = pushCount

            for newDest in pModuleDest[].dests: toProcess.addLast((dest, newDest, pulseBroadcast))

while counterFirstTrigger.len < counterModuleNames.len:
    pushCount.inc
    pushButton()

echo counterFirstTrigger.values.toSeq.foldl(a * b)
