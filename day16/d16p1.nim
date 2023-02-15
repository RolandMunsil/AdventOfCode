import sequtils
import strformat
import strscans
import strutils
import tables
import times

# Load the graph

type Valve = object
    rate: int
    tunnels: seq[string]

var valves: Table[string, Valve]

for line in lines "input.txt":
    var 
        valve: Valve
        label: string
        tunnelsStr: string
    
    if not line.scanf("Valve $* has flow rate=$i; tunnels lead to valves $*$.", label, valve.rate, tunnelsStr):
        doAssert line.scanf("Valve $* has flow rate=$i; tunnel leads to valve $*$.", label, valve.rate, tunnelsStr)

    valve.tunnels = tunnelsStr.split ", "
    valves[label] = valve

# Turn the defined graph into a more compact graph just connecting the valves we can open,
#  storing distances between the connections

type CoreValve = object
    label: string
    rate: int
    paths: Table[string, int]

var startValve: ref CoreValve
var coreValves: seq[ref CoreValve]

for label, valve in valves:
    if valve.rate == 0 and label != "AA": # Exception for AA since it's where we start
        continue

    var coreValve: ref CoreValve
    new(coreValve)
    coreValve.label = label
    coreValve.rate = valve.rate

    # search the graph to find other core valves

    var moves = 1
    var visited = @[label]
    var candidatesCur = valve.tunnels
    var candidatesNext: seq[string]

    while candidatesCur.len > 0:
        for candidate in candidatesCur:
            let valve = valves[candidate]
            if valve.rate > 0:
                coreValve.paths[candidate] = moves
            for dest in valve.tunnels:
                if dest notin visited and dest notin candidatesCur:
                    candidatesNext.add dest
            visited.add candidate
        
        moves.inc
        candidatesCur = candidatesNext
        candidatesNext = @[]
    
    if label == "AA":
        startValve = coreValve
    else:
        coreValves.add coreValve

# Look for the best path

let t0 = epochTime()

var maxRelease = 0

block findmax:
    var curRoute = @[startValve]
    while true:
        var mins = 0
        var totalReleased = 0

        block simulateAndExplore:
            var i = 0
            while true:
                if i == curRoute.high:
                    # Try just adding another node
                    for valve in coreValves:
                        if valve notin curRoute:
                            curRoute.add valve
                            break
                    # if we failed to add another node, break from the loop
                    if i > curRoute.high:
                        break

                mins.inc curRoute[i].paths[curRoute[i+1].label] + 1

                if mins < 30:
                    totalReleased.inc curRoute[i+1].rate * (30 - mins)
                else:
                    break

                i.inc
        
        if totalReleased > maxRelease: echo &"{curRoute.mapIt(it.label)} | {totalReleased}"
        maxRelease = max(totalReleased, maxRelease)

        block findNextRoute:
            while true:
                if curRoute.len == 1:
                    assert curRoute[0] == startValve
                    break findmax

                let iTail = coreValves.find(curRoute[^1])
                if iTail < coreValves.high:
                    for valve in coreValves[iTail+1..^1]:
                        if valve notin curRoute:
                            curRoute[^1] = valve
                            break findNextRoute
                
                # ran out of neighbors - try cycling the next one
                discard curRoute.pop()

echo maxRelease

echo (epochTime() - t0).formatFloat(format = ffDecimal, precision = 3)