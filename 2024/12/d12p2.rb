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

grid = Grid.new(File.read("2024/12/input.txt"))

regions = []

grid.each_pos do |pos|
  next if regions.any? {|r| r.include? pos }

  region = Set[pos]
  prev_size = 0
  while region.length > prev_size
    prev_size = region.length
    region.merge region\
      .flat_map { |p| p.adj_pos }\
      .uniq\
      .filter { |p| grid.pos_valid?(p) && grid[p] == grid[pos] }
  end

  regions.append region
end

num_sides = regions.map do |region|
  min_x = region.min_by { |p| p.x }.x
  max_x = region.max_by { |p| p.x }.x
  min_y = region.min_by { |p| p.y }.y
  max_y = region.max_by { |p| p.y }.y

  # Go over each 2x2 region and check if it contains a corner

  corner_count = 0

  ((min_x-1)..max_x).each do |x|
    ((min_y-1)..max_y).each do |y|
      tl = region.include? Pos.new(x,     y)
      tr = region.include? Pos.new(x + 1, y)
      bl = region.include? Pos.new(x,     y + 1)
      br = region.include? Pos.new(x + 1, y + 1)

      # AA  and  A_
      # A_       __
      corner_count += 1 if [1, 3].include? [tl, tr, bl, br].count(true)

      # A_  and  _A
      # _A  and  A_
      corner_count += 2 if ((tl == !tr) && (tl == !bl) && (tl == br))
    end
  end

  corner_count
end

puts regions.zip(num_sides).map { |r, s| r.length * s }.sum