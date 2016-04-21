def f(m)
  x = 25*60 - m / 3
	hh = x/60
	mm = x - hh*60
	"%02d:%02d"%[hh%24,mm]
end

gets.to_i.times do
	puts(f gets.to_i)
end

