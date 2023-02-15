import sequtils
import strformat
import strscans
import strutils
import tables

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

type State = tuple[node: ref CoreValve, releaseRate: int, mins: int, totalReleased: int]

func getNewState(stateCur: State, nextNode: ref CoreValve): State =
    let moves = stateCur.node.paths[nextNode.label]
    let time = moves + 1

    var stateNew: State
    
    stateNew.mins = stateCur.mins + time
    stateNew.totalReleased = stateCur.totalReleased + (stateCur.releaseRate * min(time, 30 - stateCur.mins))

    if stateNew.mins < 30:
        stateNew.node = nextNode
        stateNew.releaseRate = stateCur.releaseRate + stateNew.node.rate
    
    return stateNew

# Look for the best path

var maxRelease = 0

block findmax:
    var curRoute: seq[ref CoreValve]
    var routePostStates: seq[State]
    while true:
        var state: State
        state.node = startValve

        block simulateAndExplore:
            var i = 0

            if routePostStates.len > 0:
                state = routePostStates[^1]
                i = routePostStates.len

            while true:
                if i > curRoute.high:
                    # Try just adding another node
                    for valve in coreValves:
                        if valve notin curRoute:
                            curRoute.add valve
                            break
                    # if we failed to add another node, break from the loop
                    if i > curRoute.high:
                        break

                state = getNewState(state, curRoute[i])
                if routePostStates.len == i:
                    routePostStates.add state

                if state.mins >= 30:
                    break

                i.inc

            if state.mins < 30:
                state.totalReleased.inc state.releaseRate * (30 - state.mins)
                state.mins = 30
        
        if state.totalReleased > maxRelease: echo &"{curRoute.mapIt(it.label)} | {state.totalReleased}"
        maxRelease = max(state.totalReleased, maxRelease)

        block findNextRoute:
            while true:
                if curRoute.len == 0:
                    break findmax

                let iTail = coreValves.find(curRoute[^1])
                if iTail < coreValves.high:
                    for valve in coreValves[iTail+1..^1]:
                        if valve notin curRoute:
                            curRoute[^1] = valve
                            discard routePostStates.pop()
                            break findNextRoute
                
                # ran out of neighbors - try cycling the next one
                discard curRoute.pop()
                discard routePostStates.pop()

echo maxRelease