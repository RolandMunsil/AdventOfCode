class Pos
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Pos.new(@x + other.x, @y + other.y)
  end

  def -(other)
    self + -other
  end

  def -@
    Pos.new(-@x, -@y)
  end

  def adj_pos
    [
      self + Pos.new(1, 0),
      self + Pos.new(-1, 0),
      self + Pos.new(0, 1),
      self + Pos.new(0, -1)
    ]
  end

  def hash
    [@x, @y].hash
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def eql?(other)
    self == other
  end

  def manhtn_dist(other)
    (@x - other.x).abs + (@y - other.y).abs
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def inspect
    to_s
  end
end

########

DIR_TO_CHAR = {
  Pos.new(1, 0) => '>',
  Pos.new(-1, 0) => '<',
  Pos.new(0, 1) => 'v',
  Pos.new(0, -1) => '^',
}

KEYPAD_POS_TO_CHAR = {
  Pos.new(0, 0) => '7',
  Pos.new(1, 0) => '8',
  Pos.new(2, 0) => '9',
  Pos.new(0, 1) => '4',
  Pos.new(1, 1) => '5',
  Pos.new(2, 1) => '6',
  Pos.new(0, 2) => '1',
  Pos.new(1, 2) => '2',
  Pos.new(2, 2) => '3',
  Pos.new(1, 3) => '0',
  Pos.new(2, 3) => 'A',
}

ARROWS_POS_TO_CHAR = {
  Pos.new(1, 0) => '^',
  Pos.new(2, 0) => 'A',
  Pos.new(0, 1) => '<',
  Pos.new(1, 1) => 'v',
  Pos.new(2, 1) => '>',
}

$memo_cache = {}

def shortest_paths_c2c(start_pos, end_pos, pos_to_char)
  return ['A'] if start_pos == end_pos

  # memo_cache_key = [pos_to_char == KEYPAD_POS_TO_CHAR ? 0 : 1, start_pos, end_pos]
  # return $memo_cache[memo_cache_key] if $memo_cache.key? memo_cache_key

  valid_next_pos_list = start_pos.adj_pos
                                 .filter { |p| pos_to_char.key?(p) }
                                 .filter { |p| p.manhtn_dist(end_pos) < start_pos.manhtn_dist(end_pos) }

  result = valid_next_pos_list.map do |next_pos|
    paths_from_next_char = shortest_paths_c2c(next_pos, end_pos, pos_to_char)
    dir_ch = DIR_TO_CHAR[next_pos - start_pos]
    paths_from_next_char.map { |p| dir_ch + p }
  end.flatten

  # $memo_cache[memo_cache_key] = result
  return result
end

def shortest_paths(code, pos_to_char)
  char_to_pos = pos_to_char.invert
  paths = ['']
  "A#{code}".chars.each_cons(2) do |ch_start, ch_end|
    possible_c2c_paths = shortest_paths_c2c(char_to_pos[ch_start], char_to_pos[ch_end], pos_to_char)
    paths = paths.map { |path| possible_c2c_paths.map { |c2c| path + c2c } }.flatten
  end
  return paths
end

sum = 0

File.read('2024/21/input.txt').lines.map(&:strip).each do |code|
  keypad_paths = shortest_paths(code, KEYPAD_POS_TO_CHAR)

  arrows_paths = keypad_paths
  2.times do
    arrows_paths = arrows_paths.map { |kp| shortest_paths(kp, ARROWS_POS_TO_CHAR) }.flatten
    min_path_length = arrows_paths.map(&:length).min
    arrows_paths = arrows_paths.filter { |p| p.length == min_path_length }
  end
  sum += arrows_paths[0].length * code[..2].to_i
end
puts sum