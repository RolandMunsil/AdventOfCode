reading_wires = true
wire_to_val = {}
gates = []
File.read('2024/24/input.txt').strip.lines.map(&:strip).each do |line|
  if line.empty?
    reading_wires = false
    next
  end
  wire_to_val[line[0..2]] = line[5].to_i if reading_wires
  gates.append(line.split(' ') - ['->']) if !reading_wires
end

loop do
  calculable_gates = gates.filter { |gate| (wire_to_val.key? gate[0]) && (wire_to_val.key? gate[2]) }
  break if calculable_gates.empty?
  calculable_gates.each do |gate|
    wire_to_val[gate[3]] = wire_to_val[gate[0]] | wire_to_val[gate[2]] if gate[1] == 'OR'
    wire_to_val[gate[3]] = wire_to_val[gate[0]] & wire_to_val[gate[2]] if gate[1] == 'AND'
    wire_to_val[gate[3]] = wire_to_val[gate[0]] ^ wire_to_val[gate[2]] if gate[1] == 'XOR'
  end
  gates -= calculable_gates
end

puts(wire_to_val.keys.filter { |k| k[0] == 'z' }.sort.reverse.map { |k| wire_to_val[k].to_s }.join.to_i(2))