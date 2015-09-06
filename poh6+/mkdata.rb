
if ARGV.length <2
	puts "Usage: #{$0} <word_length> <num_of_data>"
	exit 1
end

wl = ARGV[0].to_i
arr = []
ARGV[1].to_i.times do
  if arr.length > 0 && rand(6) == 0
    arr << arr[rand(arr.length)].reverse
	else
		arr << (0...wl).map{ ('a'..'z').to_a[rand(26)] }.join
	end
end

puts ARGV[1]
puts arr.join("\n")

