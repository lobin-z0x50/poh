#!/usr/bin/env ruby
# https://paiza.jp/poh/ec-campaign/result/83be254d
# poh1.rb の改良版。
# targetをソートしておき、小さいものから順に探す。
# あるtargetの答えが見つかったあと、さらに次のtargetを探すことを考えた場合、
# 次のtargetは今よりも大きい値のはずなので、二分探索の結果を使えば範囲を
# 絞り込む事ができる。

$N, $D = gets.split.map &:to_i

class AnserBox
  def initialize
    @hash={}
  end

  def put(target, ans)
    if !(@hash.has_key? target) || @hash[target] < ans
      @hash[target] = ans
    end
  end

  def get(target)
    @hash[target] || 0
  end
end

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

def _search_for_all(values, targets)
  ansbox = AnserBox.new
  max = targets.last
  #STDERR.puts "max=#{max}"
  values.take((values.length/2.0).ceil).each_with_index do |v1, i|
    last_idx = 0
    #STDERR.puts " v1=#{v1} i=#{i}"
    targets.each do |target|
      limit = target - v1
      #STDERR.puts "  target=#{target} limit=#{limit} last_idx=#{last_idx}"
      next if limit < 0
      arr = MyArray2.new values, i
      # limit 以下の値を二分探索で探す
      idx = bsearch_idx(arr, limit, i, last_idx)
      #STDERR.puts "  idx=#{idx} value=#{idx ? values[idx] : nil}"
      break if idx.nil?
      last_idx = idx
      sum = v1 + values[idx]
      #STDERR.puts "sum=#{sum}"
      ansbox.put target, sum
    end
  end
  ansbox
end

def search_for_all(values, targets)
  ansbox = _search_for_all values, targets.sort
  targets.map { |t| ansbox.get t }
end

prices = (1..$N).map{gets.to_i}.sort
#STDERR.puts prices.inspect

targets = $D.times.map{gets.to_i}
puts search_for_all(prices, targets)

#STDERR.puts "--> call_count = #{$call_count}"

