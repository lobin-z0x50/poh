(c1, v1) = gets.split.map{|x| x.to_i }
(c2, v2) = gets.split.map{|x| x.to_i }

xx = c1/v1
yy = c2/v2
puts xx>yy ? 1 :2
