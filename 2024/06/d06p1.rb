class Grid
  def initialize(str)
    @aryary = str.lines.map { |line| line.strip.chars }
  end

  def [](x, y)
    @aryary[y][x]
  end

  def char_at(pos)
    @aryary[pos.y][pos.x]
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

  def +(other_pos)
    return Pos.new(x + other_pos.x, y + other_pos.y)
  end

  def hash # annoyingly this is required for uniq to work - though docs dont say so!
    [x, y].hash
  end

  def eql?(other_pos)
    x == other_pos.x && y == other_pos.y
  end
end

###############################################

grid = Grid.new(File.read("2024/06/input.txt"))

cur_dir = Pos.new(0, -1)
cur_pos = nil

grid.each_pos do |pos|
  if grid.char_at(pos) == '^'
    cur_pos = pos
    break
  end
end

pos_list = [cur_pos]

while true
  while grid.char_at(cur_pos + cur_dir) != '#'
    cur_pos += cur_dir
    pos_list.append cur_pos
  
    if !grid.pos_valid?(cur_pos + cur_dir)
      p pos_list.uniq.length
      return
    end
  end

  cur_dir = Pos.new(-cur_dir.y, cur_dir.x)
end