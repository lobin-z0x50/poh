N=gets.to_i

def main
	kaijo = 1
	(2..N).each do |n|
		kaijo = kaijo * n
		STDERR.puts "#{n} : #{kaijo}"
		# 桁あふれ対策（一の位が0になったら、今後何を掛けても0なのでここで取り除く）
		while kaijo % 10 == 0
			kaijo /= 10
		end
		# 最終的に必要なのは9桁なので、10桁分だけしか計算しない。
		kaijo %= 1000000000000000
	end
	kaijo
end

kaijo = main
STDERR.puts "kaijo=#{kaijo}"

s = kaijo.to_s
if s.length > 9
	s = s[-9..-1]
end
puts s.to_i
