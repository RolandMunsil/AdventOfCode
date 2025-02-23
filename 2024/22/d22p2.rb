unique_difflists = Set.new
diffmaps = File.read('2024/22/input.txt').strip.lines.map(&:strip).map(&:to_i).map do |secret_num|
  prev_price = secret_num % 10
  last_4_diffs = []
  diffs_to_first_price = {}
  2000.times do
    secret_num = ((secret_num << 6) ^ secret_num) & 0xffffff
    secret_num = ((secret_num >> 5) ^ secret_num) & 0xffffff
    secret_num = ((secret_num << 11) ^ secret_num) & 0xffffff

    new_price = secret_num % 10
    price_diff = new_price - prev_price
    prev_price = new_price

    last_4_diffs.delete_at 0 if last_4_diffs.length == 4
    last_4_diffs.append price_diff
    next if last_4_diffs.length != 4
    next if diffs_to_first_price.key? last_4_diffs
    difflist = Array.new(last_4_diffs)
    diffs_to_first_price[difflist] = new_price
    unique_difflists.add difflist
  end
  diffs_to_first_price
end

puts (unique_difflists.map do |difflist|
  diffmaps.sum { |dm| dm.fetch(difflist, 0) }
end).max