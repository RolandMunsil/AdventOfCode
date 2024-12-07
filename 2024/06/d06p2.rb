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

  def +(other_pos)
    return Pos.new(@x + other_pos.x, @y + other_pos.y)
  end

  def hash # annoyingly this is required for uniq to work - though docs dont say so!
    [@x, @y].hash
  end

  def ==(other_pos)
    @x == other_pos.x && @y == other_pos.y
  end
  
  def eql?(other_pos)
    self == other_pos
  end

  def to_s
    "(#{@x}, #{@y})"       
  end

  def inspect
    to_s
  end
end

###############################################

grid = Grid.new(File.read("2024/06/input.txt"))

start_dir = Pos.new(0, -1)
start_pos = nil

grid.each_pos do |pos|
  if grid[pos] == '^'
    start_pos = pos
    break
  end
end

loop_count = 0

grid.each_pos do |pos_new_obstruction|
  next if pos_new_obstruction == start_pos
  next if grid[pos_new_obstruction] == '#' 

  cur_dir = start_dir
  cur_pos = start_pos

  pos_dir_list = [[cur_pos, cur_dir]]
  looped = false

  loop do
    next_pos = cur_pos + cur_dir
    break if !grid.pos_valid?(next_pos)

    if next_pos == pos_new_obstruction || grid[cur_pos + cur_dir] == '#'
      cur_dir = Pos.new(-cur_dir.y, cur_dir.x)

      if pos_dir_list.include? [cur_pos, cur_dir]
        looped = true
        break
      end
  
      pos_dir_list.append [cur_pos, cur_dir]

      next
    end
  
    cur_pos += cur_dir
  end

  loop_count += 1 if looped
end

p loop_count