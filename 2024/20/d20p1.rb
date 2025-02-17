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

  def to_s
    "(#{@x}, #{@y})"
  end

  def inspect
    to_s
  end
end

########

grid = Grid.new(File.read('2024/20/input.txt'))

cur_pos = grid.pos_of 'S'
pos_to_picos = { cur_pos => 0 }

until grid[cur_pos] == 'E'
  valid_adj = cur_pos.adj_pos.filter { |p| grid.pos_valid?(p) && grid[p] != '#' && !pos_to_picos.key?(p) }
  raise 'yikes' if valid_adj.length != 1
  cur_pos = valid_adj[0]
  pos_to_picos[cur_pos] = pos_to_picos.length
end

n = 0

grid.each_pos do |pos|
  next if grid[pos] != '#'
  adj_spaces = pos.adj_pos.filter { |p| pos_to_picos.key?(p) }
  [[Pos.new(1, 0), Pos.new(-1, 0)], [Pos.new(0, 1), Pos.new(0, -1)]].each do |offs1, offs2|
    if adj_spaces.include?(pos + offs1) && adj_spaces.include?(pos + offs2)
      saved_time = (pos_to_picos[pos + offs1] - pos_to_picos[pos + offs2]).abs - 2
      n += 1 if saved_time >= 100
    end
  end
end

puts n