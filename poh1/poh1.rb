#!/usr/bin/env ruby

$N, $D = gets.split.map &:to_i

def bsearch_idx(arr, target, except_idx, from=0, to=nil)
  to ||= arr.length-1
  from += 1 if except_idx == from
  to -= 1   if except_idx == to
  STDERR.puts "bsearch_idx arr=#{arr.inspect} target=#{target} from=#{from} to=#{to} except=#{except_idx}"
  return nil if to<from
  if to==from
    return arr[from] > target ? nil : from
  end
  p = (from+to)/2
  p += 1 if except_idx == p
  if arr[p] == target
    return p
  end
  if arr[p] < target
    return bsearch_idx(arr, target, except_idx, p+1, to)
  end
  bsearch_idx(arr, target, except_idx, from, p-1)
end

def search(values, target)
  ans=0
  values.take_while{|v| v<target}.each_with_index do |v1, i|
    limit = target - v1
    # limit 以下の値を二分探索で探す
    idx = bsearch_idx(values, limit, i)
    next if idx.nil?
    sum = v1 + values[idx]
    STDERR.puts "sum=#{sum}"
    ans = sum if sum>ans
  end
  ans
end

prices = (1..$N).map{gets.to_i}.sort
#STDERR.puts prices.inspect

(1..$D).each do
  puts search(prices, gets.to_i)
end

