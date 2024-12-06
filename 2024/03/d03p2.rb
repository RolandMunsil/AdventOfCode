p File.read("2024/03/input.txt")\
  .split("do()")\
  .map { |str| str.split("don't()")[0] }\
  .map { |dostr| dostr\
    .scan(/mul\((\d+),(\d+)\)/)\
    .map { |s1, s2| s1.to_i * s2.to_i }
    .sum() 
  }\
  .sum()