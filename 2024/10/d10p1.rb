class Grid
  def initialize(str)
    @aryary = str.lines.map { |line| line.strip.chars.map { |ch| ch.to_i } }
  end

  def [](*args)
    case args
    in [Pos => pos]
      @aryary[pos.y][pos.x]
    in [Integer => x, Integer => y]
      @aryary[y][x]
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
    for x in (0...width)
      for y in (0...height)
        yield Pos.new(x, y)
      end
    end
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

grid = Grid.new(File.read("2024/10/input.txt"))

sum = 0

grid.each_pos do |pos|
  if grid[pos] == 0
    # begin the search!
    cur_edge = [pos]

    9.times do |i|
      cur_edge = (cur_edge.flat_map do |edge_pos|
        [
          edge_pos + Pos.new(1, 0),
          edge_pos + Pos.new(-1, 0),
          edge_pos + Pos.new(0, 1),
          edge_pos + Pos.new(0, -1)
        ]      
      end).uniq.filter { |pos| grid.pos_valid?(pos) && grid[pos] == (i + 1) }
    end

    sum += cur_edge.length
  end
end

print sum