#!/usr/bin/env ruby

$N, $D = gets.split.map &:to_i

def bsearch_idx(arr, target, from=0, to=nil)
  to ||= arr.length-1
  #STDERR.puts "bsearch_idx arr=#{arr.inspect} target=#{target} from=#{from} to=#{to}"
  return nil if to<from
  if to==from
    return arr[from] > target ? nil : from
  end
  p = (from+to)/2
  if arr[p] == target
    return p
  end
  if arr[p] < target
    return bsearch_idx(arr, target, p+1, to)
  end
  bsearch_idx(arr, target, from, p-1)
end

def search(values, target)
  ans=0
  values.take_while{|v| v<target}.each_with_index do |v1, i|
    limit = target - v1
    vals = values.dup
    vals.delete_at(i)
    # limit 以下の値を二分探索で探す
    idx = bsearch_idx(vals, limit)
    next if idx.nil?
    sum = v1 + values[idx]
    #STDERR.puts "sum=#{sum}"
    ans = sum if sum>ans
  end
  ans
end

prices = (1..$N).map{gets.to_i}.sort
#STDERR.puts prices.inspect

(1..$D).each do
  puts search(prices, gets.to_i)
end
