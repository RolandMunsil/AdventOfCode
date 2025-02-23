puts (File.read('2024/22/input.txt').strip.lines.map(&:strip).map(&:to_i).map do |secret_num|
  2000.times do
    secret_num = ((secret_num * 64) ^ secret_num) % 16777216
    secret_num = ((secret_num / 32) ^ secret_num) % 16777216
    secret_num = ((secret_num * 2048) ^ secret_num) % 16777216
  end
  secret_num
end).sum