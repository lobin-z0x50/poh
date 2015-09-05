#!/usr/bin/env ruby

$M = gets.to_i
$N = gets.to_i

qr = []

$N.times do
	qr << gets.split.map { |str| str.to_i }
end

qr.sort! {|a,b| b[0]<=>a[0]}

$anser = -1

STDERR.puts "M=#{$M} N=#{$N}"

def pick1(result, qr, s, p)
	#STDERR.puts "result=#{result} qr=#{qr} s=#{s} p=#{p}"
	if s >= $M 
		if $anser < 0 || p < $anser
			STDERR.puts "result=#{result} qr=#{qr} s=#{s} p=#{p}"
			$anser = p 
		end
		return
	end

	qr1 = qr.clone
	for x in qr
		result1 = result.clone
		result1 << x
		qr1.delete x
		pick1(result1, qr1, s+x[0], p+x[1])
	end
end

result = []
pick1(result, qr, 0, 0)

puts $anser
	
