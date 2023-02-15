import algorithm
import sequtils
import strformat
import strscans
import strutils
import tables

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
    rate: int
    paths: Table[string, int]

var coreValves: Table[string, CoreValve]
var startValve: CoreValve

for label, valve in valves:
    if valve.rate == 0 and label != "AA": # Exception for AA since it's where we start
        continue

    var coreValve: CoreValve
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
        coreValves[label] = coreValve

var maxRelease = 0
let allValves = coreValves.keys.toSeq.sorted

block findmax:
    var curRouteIs = @[0]

    while true:
        var curNode = startValve
        var curReleaseRate = 0
        var curMin = 1
        var totalRelease = 0

        block simulateAndExplore:
            var i = 0
            while true:
                if i > curRouteIs.high:
                    # Try just adding another node
                    for option in 0..allValves.high:
                        if option notin curRouteIs:
                            curRouteIs.add option
                            break
                    # if we failed to add another node, break from the loop
                    if i > curRouteIs.high:
                        break

                let nodeName = allValves[curRouteIs[i]]
                i.inc

                let moves = curNode.paths[nodeName]
                let time = moves + 1

                for m in 0..<time:
                    totalRelease.inc curReleaseRate
                    curMin.inc

                    if curMin > 30:
                        break simulateAndExplore

                curNode = coreValves[nodeName]
                curReleaseRate.inc curNode.rate

            while curMin <= 30:
                totalRelease.inc curReleaseRate
                curMin.inc
        
        if totalRelease > maxRelease: echo &"{curRouteIs.mapIt(allValves[it])} | {totalRelease}"
        maxRelease = max(totalRelease, maxRelease)

        block findNextRoute:
            while true:
                if curRouteIs.len == 0:
                    break findmax

                let iTail = curRouteIs[^1]

                if iTail < allValves.high:
                    for option in iTail+1..allValves.high:
                        if option notin curRouteIs:
                            curRouteIs[^1] = option
                            break findNextRoute
                
                # ran out of neighbors - try cycling the next one
                discard curRouteIs.pop()


echo maxRelease