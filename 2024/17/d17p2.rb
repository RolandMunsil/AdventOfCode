program = []

File.read('2024/17/input.txt').lines.each do |line|
  program = line.split[1].split(',').map(&:to_i) if line.start_with? 'Program: '
end

as_so_far = [0]

program.reverse.each do |out|
  as_so_far = as_so_far.map do |a_so_far|
    a_so_far <<= 3

    found = []

    (0..7).each do |test_bits|
      test_a = a_so_far | test_bits

      x = (test_a % 8) ^ 0b101
      y = test_a >> x
      z = ((x ^ y) ^ 0b110) % 8

      found.append(test_bits) if out == z
    end

    found.map { |f| a_so_far | f }
  end.flatten
end

puts as_so_far

# output = []

# until $a == 0
#   x = ($a % 8) ^ 0b101
#   y = $a >> x
#   z = ((x ^ y) ^ 0b110) % 8
#   output.append(z)
#   $a >>= 3
# end

# puts output.join ','