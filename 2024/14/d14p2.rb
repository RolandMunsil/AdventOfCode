width = 101
height = 103

def pmod(n, m)
  ((n % m) + m) % m
end

robots = File.read('2024/14/input.txt').lines.map { |line| line.scan(/-?\d+/).map(&:to_i) }

t = 28

loop do
  robot_poslist = (robots.map do |robot|
    p_x, p_y, v_x, v_y = robot
    final_x = (((p_x + (v_x * t)) % width) + width) % width
    final_y = (((p_y + (v_y * t)) % height) + height) % height
    [final_x, final_y]
  end).tally

  output = ""
  height.times do |y|
    width.times do |x|
      ct = robot_poslist[[x, y]]
      output += ct && ct.positive? ? ct.to_s : ' '
    end
    output += "\n"
  end
  system("clear") || system("cls")
  puts output
  puts
  puts t

  gets
  t += 101

  # 28 - needs x reshuffle
  # 86 - needs y reshuffle
  # 129 - needs x reshuffle
  # 189 - needs y reshuffle
  # 230 - needs x reshuffle
  # 292 - needs y reshuffle
end
