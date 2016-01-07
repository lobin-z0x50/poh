N=gets.to_i

def main
	kaijo = 1
	n=0
	loop do
		5.times do
			n=n+1
			return kaijo if (n>N)
			#STDERR.puts "#{n} : #{kaijo}"
			kaijo = kaijo * n
		end

		# 末尾ゼロはここで落としておく
		while kaijo % 10 == 0
			kaijo /= 10
		end
		# 最終的に必要なのは9桁なので、10桁分だけしか計算しない。
		kaijo %= 10000000000000000
	end
	kaijo
end

kaijo = main
while kaijo % 10 == 0
	kaijo /= 10
end
STDERR.puts "kaijo=#{kaijo}"

s = kaijo.to_s
if s.length > 9
	s = s[-9..-1]
end
puts s.to_i
