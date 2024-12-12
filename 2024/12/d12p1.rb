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

region_from_pos = Hash.new()

grid.each_pos do |pos|
  next if region_from_pos.has_key? pos
  region_num = region_from_pos.length
  
  region = Set[pos]
  prev_size = 0
  while region.length > prev_size
    prev_size = region.length
    region.merge region\
      .flat_map { |p| p.adj_pos }\
      .uniq\
      .filter { |p| grid.pos_valid?(p) && grid[p] == grid[pos] }
  end

  region.each { |pos| region_from_pos[pos] = region_num }
end

count_from_region = Hash.new { |hash, key| hash[key] = 0 }
perim_from_region = Hash.new { |hash, key| hash[key] = 0 }

grid.each_pos do |pos|
  region = region_from_pos[pos]
  count_from_region[region] += 1
  perim_from_region[region] += pos.adj_pos.count { |ap| !grid.pos_valid?(ap) || region_from_pos[ap] != region }
end

puts count_from_region.keys.sum { |region| count_from_region[region] * perim_from_region[region] }
