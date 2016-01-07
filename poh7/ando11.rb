$mother = []
N=gets.to_i
N.times do
  $mother << gets.split
end

$ptn = []
M=gets.to_i
M.times do
  $ptn << gets.split
end

def judge(y0,x0)
	(0..(M-1)).each do |y1|
		(0..(M-1)).each do |x1|
			STDERR.puts "m[#{y0+y1}][#{x0+x1}] <=> ptn[#{y1}][#{x1}]"
			return false if $mother[y0+y1][x0+x1] != $ptn[y1][x1]
		end
	end
	true
end

def search
	(0..(N-M)).each do |y|
		(0..(N-M)).each do |x|
			return "#{y} #{x}" if judge(y,x)
		end
	end
	nil
end

puts search()
