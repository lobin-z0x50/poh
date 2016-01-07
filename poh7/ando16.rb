gets
gets
x = gets.split.map { |e| e.to_i }
gets
y = gets.split.map { |e| e.to_i }

x.each { |e| y.delete e }

puts y.empty? ? 'None' : y.uniq.sort.join(' ')
