secs = 100
width = 101
height = 103

quad_tl_ct = 0
quad_tr_ct = 0
quad_bl_ct = 0
quad_br_ct = 0

File.read('2024/14/input.txt').lines.each do |line|
  p_x, p_y, v_x, v_y = line.scan(/-?\d+/).map(&:to_i)

  final_x = (((p_x + (v_x * secs)) % width) + width) % width
  final_y = (((p_y + (v_y * secs)) % height) + height) % height

  if final_x > ((width - 1) / 2)
    if final_y > ((height - 1) / 2)
      quad_br_ct += 1
    elsif final_y < ((height - 1) / 2)
      quad_tr_ct += 1
    end
  elsif final_x < ((width - 1) / 2)
    if final_y > ((height - 1) / 2)
      quad_bl_ct += 1
    elsif final_y < ((height - 1) / 2)
      quad_tl_ct += 1
    end
  end
end

puts quad_tl_ct * quad_tr_ct * quad_bl_ct * quad_br_ct
