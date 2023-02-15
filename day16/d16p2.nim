import bitops
import math
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

const nMins = 26

proc findMaxRelease(availableValves: seq[ref CoreValve]): int = 
    var maxRelease = 0
    var curRoute = @[startValve]
    while true:
        var mins = 0
        var totalReleased = 0

        block simulateAndExplore:
            var i = 0
            while true:
                if i == curRoute.high:
                    # Try just adding another node
                    for valve in availableValves:
                        if valve notin curRoute:
                            curRoute.add valve
                            break
                    # if we failed to add another node, break from the loop
                    if i == curRoute.high:
                        break

                mins.inc curRoute[i].paths[curRoute[i+1].label] + 1

                if mins < nMins:
                    totalReleased.inc curRoute[i+1].rate * (nMins - mins)
                else:
                    break

                i.inc
        
        maxRelease = max(totalReleased, maxRelease)

        block findNextRoute:
            while true:
                if curRoute.len == 1:
                    assert curRoute[0] == startValve
                    return maxRelease

                let iTail = availableValves.find(curRoute[^1])
                if iTail < availableValves.high:
                    for valve in availableValves[iTail+1..^1]:
                        if valve notin curRoute:
                            curRoute[^1] = valve
                            break findNextRoute
                
                # ran out of neighbors - try cycling the next one
                discard curRoute.pop()

    return maxRelease

let t0 = epochTime()

var max = 0

for flags in 0..<2^(coreValves.len - 1):
    if flags.countSetBits != coreValves.len div 2: # sketchy assumption? but it does work
        continue

    var meValves: seq[ref CoreValve]
    var elValves: seq[ref CoreValve]
    
    for i, valve in coreValves:
        if flags.testBit(i):
            meValves.add valve
        else:
            elValves.add valve

    let sum = findMaxRelease(meValves) + findMaxRelease(elValves)
    if sum > max:
        max = sum
        echo &"{flags}/{2^(coreValves.len - 1)}: {sum}"

echo (epochTime() - t0).formatFloat(format = ffDecimal, precision = 3)