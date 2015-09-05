#!/usr/bin/env ruby

$N = ARGV[0] ? ARGV[0].to_i : rand(1..50)
$M = $N * rand(58..65)

puts $M
puts $N

$N.times do
	q = rand(10..300)
	r = rand(30..85) * q
	puts "#{q} #{r}"
end
