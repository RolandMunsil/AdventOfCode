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

grid = Grid.new(File.read('2024/16/input.txt'))

cur_paths = [[0, grid.pos_of('S'), Pos.new(1, 0), Set[]]]
pos_to_best_path = Hash.new

until cur_paths.empty?
  cur_best_path = cur_paths.pop
  cur_cost, start_pos, cur_dir, visited_tiles = cur_best_path

  if pos_to_best_path.has_key? start_pos
    best = pos_to_best_path[start_pos]
    next if best[0] < cur_cost && best[3].length < visited_tiles.length
  end
  pos_to_best_path[start_pos] = cur_best_path

  if grid[start_pos] == 'E'
    puts cur_best_path[0]
    break
  end

  valid_options = start_pos.adj_pos.filter { |p| grid[p] != '#' && !visited_tiles.include?(p) }
  next if valid_options.empty?

  valid_options.each do |next_pos|
    next_dir = next_pos - start_pos
    next_path = if cur_dir == next_dir
                  [cur_cost + 1, next_pos, next_dir, visited_tiles | [start_pos]]
                elsif cur_dir == -next_dir
                  [cur_cost + 2001, next_pos, next_dir, visited_tiles | [start_pos]]
                else
                  [cur_cost + 1001, next_pos, next_dir, visited_tiles | [start_pos]]
                end

    insert_at = cur_paths.bsearch_index { |path| path[0] <= next_path[0] } || cur_paths.length
    cur_paths.insert(insert_at, next_path)
  end
end
