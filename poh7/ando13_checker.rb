def main
	(1..10000).each do |i|
		print "#{i}: "
		a = `echo #{i} | ruby ando13_0.rb 2>/dev/null`
		print a.chomp
		b = `echo #{i} | ruby ando13_1.rb 2>/dev/null`
		print " "
		print b
		return "not equal !" if a!=b
	end
end
puts main
