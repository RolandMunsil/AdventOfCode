class Grid
  def initialize(str)
    @aryary = str.lines.map { |line| line.strip.chars }
  end

  def [](*args)
    case args
    in [Pos => pos]
      @aryary[pos.y][pos.x]
    in [Integer => x, Integer => y]
      @aryary[y][x]
    end
  end

  def []=(*args)
    case args
    in [Pos => pos, val]
      @aryary[pos.y][pos.x] = val
    in [Integer => x, Integer => y, val]
      @aryary[y][x] = val
    end
  end

  def pos_valid?(pos)
    pos.x >= 0 && pos.y >= 0 && pos.x < width && pos.y < height
  end

  def height
    @aryary.length
  end

  def width
    @aryary[0].length
  end

  def each_pos
    (0...width).each do |x|
      (0...height).each do |y|
        yield Pos.new(x, y)
      end
    end
  end

  def pos_of(ch)
    each_pos do |p|
      return p if self[p] == ch
    end
  end

  def to_s
    @aryary.map { |ary| "#{ary.join}\n" }.join
  end
end

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
    Pos.new(@x - other.x, @y - other.y)
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

  def to_s
    "(#{@x}, #{@y})"
  end

  def inspect
    to_s
  end
end

########

gridstr, movestr = File.read('2024/15/input.txt').split "\n\n"

gridstr = gridstr.chars.flat_map do |ch|
  case ch
  in '#'
    '##'
  in 'O'
    '[]'
  in '.'
    '..'
  in '@'
    '@.'
  else
    ch
  end
end.join

grid = Grid.new(gridstr)
robot_pos = grid.pos_of '@'
grid[robot_pos] = '.'

movestr.chars.each do |ch|
  next if ch == "\n"

  # grid[robot_pos] = '@'
  # puts
  # puts grid
  # puts ch
  # grid[robot_pos] = '.'

  dir = case ch
        in '<'
          Pos.new(-1, 0)
        in '>'
          Pos.new(1, 0)
        in '^'
          Pos.new(0, -1)
        in 'v'
          Pos.new(0, 1)
        end

  box_tiles = []
  space_check_tiles = [robot_pos + dir]
  hit_wall = false

  until space_check_tiles.empty? || hit_wall
    this_box_tiles = []
    space_check_tiles.each do |st|
      hit_wall = true if grid[st] == '#'
      this_box_tiles += [st, st + Pos.new(-1, 0)] if grid[st] == ']'
      this_box_tiles += [st, st + Pos.new(1, 0)] if grid[st] == '['
    end
    box_tiles += this_box_tiles
    space_check_tiles = this_box_tiles.map { |bt| bt + dir }.filter { |st| !this_box_tiles.include? st }
  end

  next if hit_wall

  box_tiles_and_vals = box_tiles.map { |bt| [bt, grid[bt]] }

  box_tiles_and_vals.each { |bt, val| grid[bt] = '.' }
  box_tiles_and_vals.each { |bt, val| grid[bt + dir] = val }

  robot_pos += dir
end

sum = 0

grid.each_pos do |p|
  sum += 100 * p.y + p.x if grid[p] == '['
end

puts sum
