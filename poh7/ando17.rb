n=gets.to_i
m=gets.to_i

b=true
str=''
while str.length < m
  str += (b ? 'R' : 'W')*n
  b = !b
end

puts str[0,m]
