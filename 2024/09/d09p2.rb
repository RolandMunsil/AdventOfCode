nums = File.read('2024/09/input.txt').strip.chars.map { |ch| ch.to_i }

class AocFile
  attr_accessor :id, :length

  def initialize(id, length)
    @id = id
    @length = length
  end

  def to_s
    [@id, @length].to_s
  end

  def inspect
    to_s
  end
end

disk = []
next_is_file = true
next_file_id = 0

nums.each do |num|
  if next_is_file
    disk.append AocFile.new(next_file_id, num)
    next_file_id += 1
    next_is_file = false
  else
    disk.append num if num > 0
    next_is_file = true
  end
end

highest_id = disk[-1].id

(highest_id + 1).times do |i|
  id_move = highest_id - i
  next_file_index = disk.index { |elem| elem.is_a?(AocFile) && elem.id == id_move }
  next_file_length = disk[next_file_index].length
  place_index = disk.index { |elem| elem.is_a?(Integer) && elem >= next_file_length }

  if !place_index.nil? && place_index < next_file_index
    space_remain = disk[place_index] - next_file_length
    disk[place_index] = disk[next_file_index]
    disk[next_file_index] = next_file_length

    if space_remain > 0
      disk.insert(place_index + 1, space_remain)
    end
  end

  i2 = 0
  while (i2 + 1) < disk.length
    while disk[i2].is_a?(Integer) && disk[i2 + 1].is_a?(Integer)
      disk[i2] += disk[i2 + 1]
      disk.delete_at(i2 + 1)
    end
    i2 += 1
  end
end


sum = 0
curPos = 0

disk.each do |elem|
  if elem.is_a? Integer
    curPos += elem
  else
    elem.length.times do |i|
      sum += elem.id * curPos
      curPos += 1
    end
  end
end

print sum