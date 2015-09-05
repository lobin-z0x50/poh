#!/usr/bin/env ruby
# paiza4-3.rb
# https://paiza.jp/poh/enkoi-ending/253dcb13

$T, $N = gets.split(' ').map { |x| x.to_i }

max = -1
sum = 0
buff = []

$N.times do
  val = gets.to_i
 
  buff << val
  sum += val

  #STDERR.puts "buff=#{buff} sum=#{sum}"
  if buff.length < $T
    next
  end

  if sum > max
    max = sum
  end
  sum -= buff.delete_at(0)
end

puts max
