#/usr/bin/ruby

N = ARGV[0]&.to_i || 0
D = ARGV[1]&.to_i || 0

if N==0 || D == 0
  STDERR.puts "Usage: mkdata <N> <D>"
  exit 1
end

puts "#{N} #{D}"
(N+D).times do
  puts rand(999980) + 10
end
