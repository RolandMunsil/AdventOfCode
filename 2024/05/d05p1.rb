rulesstr, updatesstr = File.read("2024/05/input.txt").split("\n\n")

rules = rulesstr.lines.map do |line|
    line.strip.split('|').map { |s| s.to_i }
end

updates = updatesstr.lines.map do |line|
  line.strip.split(',').map { |s| s.to_i }
end

correct_updates = updates.filter do |update|
  rules.all? do |rule|
    iLow = update.index rule[0]
    iHigh = update.index rule[1]
    iLow.nil? || iHigh.nil? || iLow < iHigh
  end
end

p correct_updates.map { |u| u[u.length / 2]}.sum()