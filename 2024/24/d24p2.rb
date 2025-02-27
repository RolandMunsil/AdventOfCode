reading_wires = true
wire_to_val = {}
$gates = []
File.read('2024/24/input.txt').strip.lines.map(&:strip).each do |line|
  if line.empty?
    reading_wires = false
    next
  end
  if reading_wires
    wire_to_val[line[0..2]] = line[5].to_i 
  else
    gate = line.split(' ') - ['->']
    gate = [gate[2], gate[1], gate[0], gate[3]] if gate[0] > gate[2]
    $gates.append(gate)
  end
end

pairs_to_swap = [['qjb', 'gvw'], ['jgc', 'z15'], ['drg', 'z22'], ['jbp', 'z35']]

$gates.each do |gate|
  pairs_to_swap.each do |a, b|
    if gate[3] == a
      gate[3] = b
    elsif gate[3] == b
      gate[3] = a
    end
  end
end

# Just ran this code repeatedly and figured out crossed wires manually

def find_and_validate_matching_gate(operand1, op, operand2)
  wires = [operand1, operand2].sort
  match = [wires[0], op, wires[1]]
  gate = $gates.find { |g| g[0..2] == match }
  raise "Bad connection (DNE: #{operand1} #{op} #{operand2})" unless gate
  gate
end

def validate_gate_output_wire(gate, expected_output_wire)
  raise "Bad connection (Swap #{gate[3]} and #{expected_output_wire})" unless gate[3] == expected_output_wire
end

max_result_digit_num = wire_to_val.length / 2

prev_carry_result_gate = nil
(0..(max_result_digit_num - 1)).each do |n|
  n_str = '%02d' % n
  xor_ops_gate = find_and_validate_matching_gate("x#{n_str}", 'XOR', "y#{n_str}")
  and_ops_gate = find_and_validate_matching_gate("x#{n_str}", 'AND', "y#{n_str}")
  expected_digit_wire = "z#{n_str}"
  if prev_carry_result_gate.nil?
    # validate digit calculation: x ^ y
    validate_gate_output_wire(xor_ops_gate, expected_digit_wire)
    prev_carry_result_gate = and_ops_gate
  else
    # validate digit calculation: (x ^ y) ^ c
    xor_ops_and_carry_gate = find_and_validate_matching_gate(xor_ops_gate[3], 'XOR', prev_carry_result_gate[3])
    validate_gate_output_wire(xor_ops_and_carry_gate, expected_digit_wire)

    # validate carry calculation: ((x ^ y) & c) | (x & y)
    one_op_and_carry_gate = find_and_validate_matching_gate(xor_ops_gate[3], 'AND', prev_carry_result_gate[3])
    carry_gate = find_and_validate_matching_gate(one_op_and_carry_gate[3], 'OR', and_ops_gate[3])
    prev_carry_result_gate = carry_gate
  end
end

validate_gate_output_wire(prev_carry_result_gate, 'z%02d' % max_result_digit_num)

puts pairs_to_swap.flatten.sort.join(',')