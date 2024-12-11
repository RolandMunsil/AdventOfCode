nums = File.read("2024/11/input.txt").strip.split

25.times do
  nums = nums.flat_map do |num|
    if num == '0'
      '1'
    elsif num.length.even?
      [num[0...(num.length/2)].to_i.to_s, num[(num.length/2)...(num.length)].to_i.to_s]
    else
      (num.to_i * 2024).to_s
    end
  end
end

print nums.length