#!/usr/bin/env ruby
# ビット演算を使うアルゴリズム
# ビットシフトが思ったより遅いようで、とても遅い。

require 'set'

$N, $D = gets.split.map &:to_i


def search(price_bits, dups, targets)
  ans = _search(price_bits, dups, targets.sort)
  targets.map { |t| ans[t] }
end

def _search(price_bits, dups, targets)
  ans = {}
  max_targets = targets.last
  #STDERR.puts "_search() price_bits=#{price_bits}, dups=#{dups}, targets=#{targets}"

  (1...max_targets).each do |n|
    STDERR.puts "_search() #{n}"
    n_bit = 1 << n
    if (price_bits | n_bit) != 0
      judge((dups.include?(n) ? price_bits : price_bits ^ n_bit) << n, targets, ans)
    end
  end
  ans
end

def judge(sum_bits, targets, ans)
  targets.each do |target|
    _judge(sum_bits, target, ans)
    #STDERR.puts "_judge(sum_bits, target, ans)"
  end
end

def _judge(sum_bits, target, ans)
  t_bit = 1 << target
  t = target
  while t_bit > 0 do
    if (sum_bits & t_bit) != 0
      current_ans = ans[target]||0
      ans[target] = t if current_ans < t
    end
    t_bit >>= 1
    t-=1
  end
end

prices = $N.times.map { gets.to_i }

dups = Set.new
price_bits = 0
prices.each do |x|
  p = 1 << x
  if (price_bits & p) != 0
    # 重複OK
    dups.add x
  end
  price_bits |= p
end

#STDERR.puts prices.inspect

targets = $D.times.map { gets.to_i }

puts search(price_bits, dups, targets)

