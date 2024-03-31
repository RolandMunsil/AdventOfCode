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

var sum = 0

for line in lines "input.txt":
    if line.isEmptyOrWhitespace:
        parsingRules = false
        continue

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
    else:
        var x, m, a, s: int
        discard line.scanf("{x=$i,m=$i,a=$i,s=$i}", x, m, a, s)

        var doneProcessing = false
        var curRules = workflows["in"]

        while not doneProcessing:
            for rule in curRules:
                if rule.hasCheck:
                    var v: int
                    case rule.v:
                    of 'x': v = x
                    of 'm': v = m
                    of 'a': v = a
                    of 's': v = s
                    else: discard

                    var passesRule: bool
                    case rule.op:
                    of '<': passesRule = v < rule.val
                    of '>': passesRule = v > rule.val
                    else: discard

                    if not passesRule:
                        continue

                if rule.result == "A":
                    sum.inc x + m + a + s
                    doneProcessing = true
                elif rule.result == "R":
                    doneProcessing = true
                else:
                    curRules = workflows[rule.result]
                    break

                if doneProcessing:
                    break

echo sum