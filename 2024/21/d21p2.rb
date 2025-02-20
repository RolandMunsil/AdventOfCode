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

def shortest_paths_ch_to_ch(start_ch, end_ch, pos_to_char)
  return ['A'] if start_ch == end_ch

  char_to_pos = pos_to_char.invert
  start_pos = char_to_pos[start_ch]
  end_pos = char_to_pos[end_ch]

  valid_next_pos_list = start_pos.adj_pos
                                 .filter { |p| pos_to_char.key?(p) }
                                 .filter { |p| p.manhtn_dist(end_pos) < start_pos.manhtn_dist(end_pos) }

  valid_next_pos_list.map do |next_pos|
    dir_ch = DIR_TO_CHAR[next_pos - start_pos]
    paths_from_next_pos = shortest_paths_ch_to_ch(pos_to_char[next_pos], pos_to_char[end_pos], pos_to_char)
    paths_from_next_pos.map { |p| dir_ch + p }
  end.flatten
end

def shortest_paths(code, pos_to_char)
  paths = ['']
  "A#{code}".chars.each_cons(2) do |ch_start, ch_end|
    step_paths = shortest_paths_ch_to_ch(ch_start, ch_end, pos_to_char)
    paths = paths.product(step_paths).map { |path, step_path| path + step_path }
  end
  paths
end

$cache = {}

def fastest(from_ch, to_ch, n_machines_between)
  return 1 if n_machines_between.zero?
  cache_key = [from_ch, to_ch, n_machines_between]

  unless $cache.key? cache_key
    $cache[cache_key] = shortest_paths_ch_to_ch(from_ch, to_ch, ARROWS_POS_TO_CHAR).map do |path|
      fastest_sum = 0
      "A#{path}".chars.each_cons(2) do |ch_start, ch_end|
        fastest_sum += fastest(ch_start, ch_end, n_machines_between - 1)
      end
      fastest_sum
    end.min
  end
  return $cache[cache_key]
end

sum = 0

File.read('2024/21/input.txt').lines.map(&:strip).each do |code|
  puts code

  start_paths = shortest_paths(code, KEYPAD_POS_TO_CHAR)

  fastest_path_len = start_paths.map do |path|
    fastest_sum = 0
    "A#{path}".chars.each_cons(2) do |ch_start, ch_end|
      fastest_sum += fastest(ch_start, ch_end, 25)
    end
    fastest_sum
  end.min

  sum += fastest_path_len * code[..2].to_i
end
puts sum