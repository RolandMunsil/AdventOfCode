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

WIDTH = 71
HEIGHT = 71

def pos_valid?(pos)
  pos.x >= 0 && pos.y >= 0 && pos.x < WIDTH && pos.y < HEIGHT
end

coords = File.read('2024/18/input.txt').strip.lines.map { |l| Pos.new(*l.split(',').map(&:to_i)) }
coords = coords.take(1024).to_set

edge = Set[Pos.new(0, 0)]
visited = Set[]
exit = Pos.new(WIDTH - 1, HEIGHT - 1)

steps = 0

until edge.include? exit
  visited.merge edge
  edge = edge.map(&:adj_pos).flatten.filter { |p| pos_valid?(p) && !visited.include?(p) && !coords.include?(p) }.to_set
  steps += 1
end

puts steps
