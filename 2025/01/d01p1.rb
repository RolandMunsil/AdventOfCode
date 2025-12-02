instrs = File.read('2025/01/input.txt').lines.map { |line| [ line[0], line[1..].strip.to_i ] }

dial = 50
zeroct = 0

instrs.each do |dir, amnt|
  dial += amnt if dir == 'R'
  dial -= amnt if dir == 'L'
  dial = ((dial % 100) + 100) % 100
  zeroct += 1 if dial.zero?
end

puts zeroct