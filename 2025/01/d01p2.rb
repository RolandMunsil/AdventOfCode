instrs = File.read('2025/01/input.txt').lines.map { |line| [ line[0], line[1..].strip.to_i ] }

dial = 50
zeroct = 0

instrs.each do |dir, amnt|
  if dir == 'R'
    amnt.times do
      dial += 1
      dial -= 100 if dial >= 100
      zeroct += 1 if dial.zero?
    end
  else
    amnt.times do
      dial -= 1
      dial += 100 if dial < 0
      zeroct += 1 if dial.zero?
    end
  end
end

puts zeroct