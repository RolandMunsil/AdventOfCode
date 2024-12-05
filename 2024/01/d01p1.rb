pairs = File.read("2024/01/input.txt").lines.map { |line| line.strip.split.map { |item| item.to_i } }

left = pairs.map { |pair| pair[0] }.sort
right = pairs.map { |pair| pair[1] }.sort

p left.zip(right).map { |l, r| (l - r).abs }.sum