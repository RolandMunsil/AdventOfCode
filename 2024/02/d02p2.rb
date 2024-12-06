reports = File.read("2024/02/input.txt").lines.map { |line| line.strip.split.map { |item| item.to_i }}

def is_safe(report)
  for i in (0..report.length)
    repCpy = report.clone
    repCpy.delete_at(i)
    allinc = true
    alldec = true
    alladj = true

    repCpy.each_cons(2) { |a, b|
      allinc &&= a < b 
      alldec &&= a > b
      alladj &&= ((a - b).abs <= 3)
    }

    if (allinc || alldec) && alladj
      return true
    end
  end
  return false 
end

p reports.count { |rep| is_safe(rep) }