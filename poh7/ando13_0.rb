N=gets.to_i

kaijo = 1
(2..N).each do |n|
      kaijo = kaijo * n
			STDERR.puts "#{n} : #{kaijo}"
end

tmp = kaijo.to_s.gsub(/0+$/, '')
STDERR.puts "kaijo=#{kaijo} zerotrimed=#{tmp}"

if tmp.length > 9
        tmp = tmp[-9..-1]
end
puts tmp.to_i
