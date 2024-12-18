total_min_token_ct = 0

File.read('2024/13/input.txt').split("\n\n").each do |machine|
  a_x, a_y, b_x, b_y, prize_x, prize_y = machine.scan(/\d+/).map(&:to_i)
  prize_x += 10000000000000
  prize_y += 10000000000000

  # doing this made me understand why you can use
  # matrices to solve systems of equations. neat

  raise 'a and b along same axis' if Rational(a_x, a_y) == Rational(b_x, b_y)

  # skew so that A dir = x axis
  prize_y -= (a_y * Rational(prize_x, a_x))
  b_y -= (a_y * Rational(b_x, a_x))
  a_y = 0

  # skew so that B dir = y axis
  prize_x -= (b_x * Rational(prize_y, b_y))
  a_x -= (b_x * Rational(a_y, b_y))
  b_x = 0

  # now answer is just coords of prize
  x_press = prize_x / a_x
  y_press = prize_y / b_y

  total_min_token_ct += (x_press.to_i * 3) + y_press.to_i if x_press.denominator == 1 && y_press.denominator == 1
end

puts total_min_token_ct
