reports = File.read("2024/02/input.txt").lines.map { |line| line.strip.split.map { |item| item.to_i }}

p reports.count { |rep|
  allinc = true
  alldec = true
  alladj = true

  rep.each_cons(2) { |a, b|
    allinc &&= a < b 
    alldec &&= a > b
    alladj &&= ((a - b).abs <= 3)
  }

  (allinc || alldec) && alladj
}