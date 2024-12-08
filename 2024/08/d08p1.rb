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

###############################################

grid = Grid.new(File.read('2024/08/input.txt'))

freqToPosList = Hash.new { |hash, key| hash[key] = [] }

grid.each_pos do |pos|
  ch = grid[pos]
  freqToPosList[ch].append pos if ch != '.'
end

antinodes = Set[]

freqToPosList.each_value do |posList|
  posList.combination(2) do |pair|
    antinodes.add pair[1] + (pair[1] - pair[0])
    antinodes.add pair[0] + (pair[0] - pair[1])
  end
end

antinodes.reject! { |pos| !grid.pos_valid?(pos) }

puts antinodes.length
