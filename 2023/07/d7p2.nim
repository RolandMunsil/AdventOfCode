import sequtils
import strutils
import algorithm
import tables

var list = lines("input.txt").toSeq.mapIt(it.splitWhitespace).mapIt((it[0], parseInt(it[1])))

func cts(hand: string): seq[int] = 
    let ctTable = newCountTable(hand)

    var ctJoker: int
    if ctTable.pop('J', ctJoker):
        if ctJoker == 5:
            return @[5]
        else:
            result = ctTable.values.toSeq.sorted
            result[^1].inc ctJoker
    else:
        return ctTable.values.toSeq.sorted

func handRank(hand: string): int =
    let cts = cts(hand)
    if cts == @[5]:         # Five of a kind
        return 7
    if cts == @[1, 4]:      # Four of a kind
        return 6
    if cts == @[2, 3]:      # Full house
        return 5
    if cts == @[1, 1, 3]:   # Three of a kind
        return 4
    if cts == @[1, 2, 2]:   # Two pair
        return 3
    if cts == @[1, 1, 1, 2]:# One pair
        return 2
    assert cts == @[1, 1, 1, 1, 1]
    return 1

const cardsInOrder = @[ 'J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']

func cmpCards(c1: char, c2: char): int =
    return cmp(cardsInOrder.find(c1), cardsInOrder.find(c2))

list.sort do (a, b: (string, int)) -> int:
    let aHand = a[0]
    let bHand = b[0]

    result = cmp(handRank(aHand), handRank(bHand))

    if result == 0: 
        for i in 0..<5:
            result = cmpCards(aHand[i], bHand[i])
            if result != 0: return

var winnings = 0

for i, elem in list:
    echo elem
    winnings += (i + 1) * elem[1]

echo winnings