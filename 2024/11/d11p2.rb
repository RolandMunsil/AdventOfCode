nums = File.read("2024/11/input.txt").strip.split

$cache = Hash.new { |hash, key| hash[key] = {} }

def n_stones_cached(num, blinks_remaining)
  $cache[num][blinks_remaining] || ($cache[num][blinks_remaining] = n_stones(num, blinks_remaining))
end

def n_stones(num, blinks_remaining)
  if blinks_remaining == 0
    1
  else
    nums_next = if num == '0'
      ['1']
    elsif num.length.even?
      [num[0...(num.length/2)].to_i.to_s, num[(num.length/2)...(num.length)].to_i.to_s]
    else
      [(num.to_i * 2024).to_s]
    end

    nums_next.sum { |num_next| n_stones_cached(num_next, blinks_remaining - 1) }
  end
end

print nums.map { |num| n_stones_cached(num, 75) }.sum