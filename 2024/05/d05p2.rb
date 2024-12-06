rulesstr, updatesstr = File.read("2024/05/input.txt").split("\n\n")

rules = rulesstr.lines.map do |line|
    line.strip.split('|').map { |s| s.to_i }
end

updates = updatesstr.lines.map do |line|
  line.strip.split(',').map { |s| s.to_i }
end

def rule_is_followed(update, rule)
  iLow = update.index rule[0]
  iHigh = update.index rule[1]
  iLow.nil? || iHigh.nil? || iLow < iHigh 
end

def is_correct(update, rules)
  rules.all? { |rule| rule_is_followed(update, rule) }
end

incorrect_updates = updates.filter { |update| !is_correct(update, rules) }

incorrect_updates.each do |update|
  while !is_correct(update, rules)
    rules.each do |rule|
      if !rule_is_followed(update, rule)
        iLow = update.index rule[0]
        iHigh = update.index rule[1]
        low = update[iLow]
        high = update[iHigh]
        update[iLow] = high
        update[iHigh] = low
        break
      end
    end 
  end
end

p incorrect_updates.map { |u| u[u.length / 2]}.sum()