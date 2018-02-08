#!/usr/bin/env ruby
# https://paiza.jp/poh/ec-campaign/result/81b91cc9

$N, $D = gets.split.map &:to_i

class MyArray2
  attr_accessor :except_idx

  def initialize(base_arr, except_idx)
    @base_arr = base_arr
    @except_idx = except_idx || base_arr.length
  end

  def at(idx)
    idx += 1 if @except_idx <= idx
    @base_arr[idx]
  end

  def length
    @base_arr.length-1
  end

  def to_a
    @base_arr
  end

  def to_s
    a = []
    (0...@base_arr.length).map do |i|
      if i!=except_idx
        a << @base_arr[i]
      end
    end
    a
  end
end

def bsearch_idx(arr, target, except_idx, from=0, to=nil)
  ret = _bsearch_idx(arr, target, except_idx, from=0, to=nil)
  ret += 1 if ret && except_idx <= ret
  ret
end

$call_count=0
def _bsearch_idx(arr, target, except_idx, from=0, to=nil)
  $call_count+=1
  to ||= arr.length-1
  #STDERR.puts "bsearch_idx target=#{target} from=#{from} to=#{to} except=#{except_idx} arr=#{arr.to_s} (#{arr.class})"
  return nil if to<from  # bug
  if to<=from
    val = arr.at(from)
    ret = val && val > target ? nil : from
    #STDERR.puts "  *** ret=#{ret} val=#{val}"
    return ret
  end
  p = ((from+to)/2.0).ceil
  v = arr.at(p)
  #STDERR.puts " p=#{p} arr[p]=#{v}"
  return nil unless v
  if v == target
    #STDERR.puts "  **! ret=#{p} val=#{arr.at(p)}"
    return p
  end
  if v < target
    return _bsearch_idx(arr, target, except_idx, p, to)
  end
  _bsearch_idx(arr, target, except_idx, from, p-1)
end

def search(values, target)
  ans=0
  values.take_while{|v| v<target}.each_with_index do |v1, i|
    limit = target - v1
    # limit 以下の値を二分探索で探す
    arr = MyArray2.new values, i
    idx = bsearch_idx(arr, limit, i)
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

STDERR.puts "--> call_count = #{$call_count}"

