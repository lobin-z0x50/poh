a = {'c'=>0, 'a'=>0, 't'=>0}
gets.chomp.each_char do |c|
  a[c] += 1
end
min,max = [a['c'], a['a'], a['t']].minmax
puts min
puts max-a['c']
puts max-a['a']
puts max-a['t']
