s={}
k={}
p={}
gets.to_i.times { t=gets.chomp
r=t.reverse
if s.has_key?(r)&&s[r]>0
s[r]-=1
m=[r,t].min
if p.has_key?m
p[m]+=1
else
p[m]=1
end
else
if s.has_key?t
s[t]+=1
else
s[t]=1
end end }
s.keys.each{|x| k[x]=s[x] if x.reverse==x}
s=w=''
p.keys.sort.each{|w| p[w].times{s<<w}}
w=k.keys.sort[0] if k.length>0
puts s+w+s.reverse

