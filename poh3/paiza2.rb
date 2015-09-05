#!/usr/bin/env ruby

$M = gets.to_i
$N = gets.to_i

qr = []

$N.times do
	q,r = gets.split.map { |str| str.to_i }
	a = 1.0 * r / q   # 人月単価
	qr << [q,r,a]
end

$answer = 0

qr_a = qr.sort {|a,b| b[2]<=>a[2]}   # 単価の安い順に並べる
$target_kosu = 0
for xx in qr_a
	$target_kosu += xx[0]
	$answer += xx[1]
	break if $M <= $target_kosu
end

$AVG = 1.0 * $answer / $M     # 枝刈りの基準となる平均単価

STDERR.puts "M=#{$M} N=#{$N} target_kosu=#{$target_kosu} answer=#{$answer} AVG=#{$AVG}"
STDERR.puts "qr_a=#{qr_a}"
def pick1(result, qr, s, p)

	if s >= $M 
		if p < $answer
			STDERR.puts "result=#{result} qr=#{qr} s=#{s} p=#{p}"
			$answer = p 
		end
		return
	end

	qr1 = qr.clone
	for x in qr
		result1 = result.clone
		result1 << x
		qr1.delete x
		s1, p1 = s+x[0], p+x[1]
		next if $AVG * s1 < p1     # 枝刈り!!!
		pick1(result1, qr1, s1, p1)
	end
end

result = []
pick1(result, qr_a, 0, 0)

puts $answer

