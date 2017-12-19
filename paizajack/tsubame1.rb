def bet(cards)
  100
end

def sum(cards)
  ans = [0]
  cards.each do |c|
    for i in 0..(ans.length-1)
      ans[i] += c
      #STDERR.puts "i=#{i}, ans[i]=#{ans[i]}"
    end
    if c == 1
      # エースの場合は11と評価するノードを追加
      ans << ans[0] + 10  # TODO: ans[1] がある場合はそっちからも分岐が必要？
    end
  end
  ans.select{|x| x<=21}.uniq
end

def turn(cards)
  s = sum(cards)
  #STDERR.puts "sum=#{s}"

  if s.length == 0
    # 21 を超えている
    return "STAND"
  end

  if s.length == 1
    if s[0] <= 15
      return "HIT"
    else
      return "STAND"
    end
  else
    mx = s.max
    mn = s.min
    if mx <= 19
      return "HIT"
    else
      return "STAND"
    end
  end
end

cards = gets.gsub(/\s*#.*$/, '').split(" ").map(&:to_i)
if cards[0] == 0 
  puts bet(cards)
  gets
  gets
else
  puts turn(cards)
end

