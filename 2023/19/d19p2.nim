import sequtils
import strscans
import strutils
import tables

var parsingRules = true

type Rule = object
    hasCheck: bool
    v: char
    op: char
    val: int
    result: string

var workflows: Table[string, seq[Rule]]

for line in lines "input.txt":
    if line.isEmptyOrWhitespace:
        parsingRules = false
        break

    if parsingRules:
        var 
            workflowName: string
            strRules: string
        discard line.scanf("$w{$*}", workflowName, strRules)

        var rules: seq[Rule]
        for strRule in strRules.split(','):
            if ':' notin strRule:
                rules.add(Rule(hasCheck: false, result: strRule))
            else:
                var rule = Rule(hasCheck: true)
                discard strRule.scanf("$c$c$i:$w", rule.v, rule.op, rule.val, rule.result)
                rules.add rule
        
        workflows[workflowName] = rules

type Poss = array[4, seq[(int, int)]]

func isEmpty(poss: Poss): bool = poss.anyIt(it.len == 0)

func nPoss(poss: Poss): uint64 = 
    poss.mapIt(it.mapIt((it[1] - it[0]) + 1).foldl(a + b).uint64).foldl(a * b)

proc nAllowed(poss: Poss, nextRules: seq[Rule]): uint64 =
    if poss.isEmpty:
        return 0

    let rule = nextRules[0]

    if rule.hasCheck:
        var i: int        
        case rule.v:
        of 'x': i = 0
        of 'm': i = 1
        of 'a': i = 2
        of 's': i = 3
        else: discard

        let baseRanges = poss[i]
        var possPassRule = poss
        var possFailRule = poss

        possFailRule[i] = @[]
        possPassRule[i] = @[]

        case rule.op:
        of '<':
            for (lo, hi) in baseRanges:
                if lo < rule.val and hi < rule.val:
                    possPassRule[i].add (lo, hi)
                elif lo < rule.val and hi >= rule.val:
                    possPassRule[i].add (lo, rule.val - 1)
                    possFailRule[i].add (rule.val, hi)
                elif lo >= rule.val and hi >= rule.val:
                    possFailRule[i].add (lo, hi)
                else: assert false
        of '>':
            for (lo, hi) in baseRanges:
                if lo > rule.val and hi > rule.val:
                    possPassRule[i].add (lo, hi)
                elif lo <= rule.val and hi > rule.val:
                    possPassRule[i].add (rule.val + 1, hi)
                    possFailRule[i].add (lo, rule.val)
                elif lo <= rule.val and hi <= rule.val:
                    possFailRule[i].add (lo, hi)
                else: assert false
        else: discard

        let nAllowedFailRule = nAllowed(possFailRule, nextRules[1..^1])

        if rule.result == "A":
            return nAllowedFailRule + nPoss(possPassRule)
        elif rule.result == "R":
            return nAllowedFailRule + 0
        else:
            return nAllowedFailRule + nAllowed(possPassRule, workflows[rule.result])
    else:
        if rule.result == "A":
            return nPoss(poss)
        elif rule.result == "R":
            return 0
        else:
            return nAllowed(poss, workflows[rule.result])


echo nAllowed([@[(1, 4000)], @[(1, 4000)], @[(1, 4000)], @[(1, 4000)]], workflows["in"])