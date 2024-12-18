total_min_token_ct = 0

File.read('2024/13/input.txt').split("\n\n").each do |machine|
  a_x, a_y, b_x, b_y, prize_x, prize_y = machine.scan(/\d+/).map(&:to_i)

  (0..100).each do |a_push_ct|
    xremain = prize_x - (a_push_ct * a_x)
    break if xremain.negative?
    next if (xremain % b_x) != 0
    b_push_ct = xremain / b_x
    next if (a_push_ct * a_y) + (b_push_ct * b_y) != prize_y
    token_ct = a_push_ct * 3 + b_push_ct
    total_min_token_ct += token_ct
    break
  end
end

puts total_min_token_ct
