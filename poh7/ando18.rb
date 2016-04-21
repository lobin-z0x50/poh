S = gets
p = 0
i = 0
begin
  p = S.index "cat", p
	break unless p
	p += 3
	i += 1
end while p
puts i
