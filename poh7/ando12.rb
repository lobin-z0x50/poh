(X, Y, Z, N) = gets.split.map{|x| x.to_i}

tate = []
yoko = []

N.times do
	(dir, pos) = gets.split.map{|x| x.to_i}
	if dir==1
		tate << pos
	else
		yoko << pos
	end
end

def get_min(list)
	STDERR.puts "get_min() list=#{list}"
	last = 0
	min = -1
	list.each do |p|
		m = p-last
		if min==-1 || min>m
			min=m
		end
		last=p
		STDERR.puts "p=#{p} last=#{last} min=#{min}"
	end
	min
end

tate << Y
ymin = get_min tate.sort
yoko << X
xmin = get_min yoko.sort

puts ymin*xmin*Z
