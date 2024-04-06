import sequtils

type Pos = tuple[x, y: int]
func `+`(pos: Pos, other: (int, int)): Pos = (pos.x + other[0], pos.y + other[1])
func `+=`(pos: var Pos, other: (int, int)) = pos = pos + other
func `-`(pos: Pos, other: (int, int)): Pos = (pos.x - other[0], pos.y - other[1])
func `*`(pos: Pos, other: int): Pos = (pos.x * other, pos.y * other)
func `-`(pos: Pos): Pos = (-pos.x, -pos.y)

let grid = lines("input.txt").toSeq

proc val(pos: Pos): char = grid[pos.y][pos.x]
proc isValid(pos: Pos): bool = pos.y >= grid.low and pos.y <= grid.high and pos.x >= grid[0].low and pos.x <= grid[0].high
proc isNotForest(pos: Pos): bool = pos.isValid and pos.val != '#'

proc moveCands(pos: Pos): seq[Pos] =
    if pos.val == '^': return @[pos + (0, -1)]
    if pos.val == 'v': return @[pos + (0, 1)]
    if pos.val == '<': return @[pos + (-1, 0)]
    if pos.val == '>': return @[pos + (1, 0)]

    if isNotForest(pos + (0, 1)) and val(pos + (0, 1)) != '^':
        result.add(pos + (0, 1))
    if isNotForest(pos + (0, -1)) and val(pos + (0, -1)) != 'v':
        result.add(pos + (0, -1))
    if isNotForest(pos + (1, 0)) and val(pos + (1, 0)) != '<':
        result.add(pos + (1, 0))
    if isNotForest(pos + (-1, 0)) and val(pos + (-1, 0)) != '>':
        result.add(pos + (-1, 0))

let pathStart: seq[Pos] = @[(1, 1)]

proc longestPath(initialPath: seq[Pos]): int =
    var curPath = initialPath
    while true:
        let cands = curPath[^1].moveCands().filterIt(it notin curPath)

        if cands.len == 0:
            # for y in 0..grid.high:
            #     for x in 0..grid[0].high:
            #         if (x, y) in curPath:
            #             stdout.write 'O'
            #         else:
            #             stdout.write (x, y).val
            #     stdout.write "\n"
            # echo curPath.len
            # stdout.write "\n"

            return curPath.len
        elif cands.len == 1:
            curPath.add cands[0]
        else:
            return cands.mapIt(longestPath(curPath & @[it])).max()

echo longestPath pathStart
