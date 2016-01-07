a=0
5.times do
	a+=gets.length
end
STDERR.puts a
puts (4*3+3*2 <= a) ? 'yes' : 'no'
