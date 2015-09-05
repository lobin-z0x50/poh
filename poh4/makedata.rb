#!/usr/bin/env ruby

$N = ARGV[0] ? ARGV[0].to_i : rand(1..100)
$T = rand(1..$N)

puts "#{$T} #{$N}"

$N.times do
	s = rand(0..10000)
	puts s
end
