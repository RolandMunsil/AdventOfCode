reg = []
program = []

File.read('2024/17/input.txt').lines.each do |line|
  if line.start_with? 'Register '
    reg.append line.split[2].to_i
  elsif line.start_with? 'Program: '
    program = line.split[1].split(',').map(&:to_i)
  end
end

$a = reg[0]
$b = reg[1]
$c = reg[2]

def calc_combo(n)
  return n if n <= 3
  return $a if n == 4
  return $b if n == 5
  return $c if n == 6
  raise 'combo 7'
end

ip = 0

output = []

until ip >= program.length
  lit_op = program[ip + 1]
  combo_op = calc_combo(lit_op)
  case program[ip]
  when 0 # adv
    $a = $a / (2 ** combo_op)
  when 1 # bxl
    $b = $b ^ lit_op
  when 2
    $b = combo_op % 8
  when 3 # jnz
    if $a != 0
      ip = lit_op
      next
    end
  when 4 # bxc
    $b = $b ^ $c
  when 5 # out
    output.append(combo_op % 8)
  when 6 # bdv
    $b = $a / (2 ** combo_op)
  when 7 # cdv
    $c = $a / (2 ** combo_op)
  end

  ip += 2
end

puts output.join ','