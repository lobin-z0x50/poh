#!/usr/bin/env ruby
# 採点結果 https://paiza.jp/poh/paizen/result/2dc6146e

$H, $W = gets.split.map &:to_i

def debug(str)
  STDERR.puts str
end

ZeroArray = Array.new($W) { 0 }

# 動的計画法の組み合わせで検索を行う
# @param  area    [Array]         D1〜DH までのホーム画面情報を１次元配列で。 例： ['1000', '1101', ...]
# @return [Array<Array>] [0,0]〜[$H,$W]までの配置可能数
def bi_search(area)
  ans = Array.new($H){ ZeroArray.dup } # 答えを詰めていくための２次元配列
  current = ZeroArray.dup  # 動的計画法による現在行までの縦の配置可能数の和

  # 行ごとにループ
  area.each do |row|
    # 現在行までの縦の配置可能数の和を更新する
    #debug "--- row=#{row} ---"
    (0...current.length).each do |i|
      #debug "current=#{current.inspect} ans=#{ans.inspect}"
      #debug "row[i]=#{row[i]}"
      if row.getbyte(i) == 0x30  # 空き
        current[i] += 1
      else              # すでに配置済み
        current[i] = 0
      end
    end

    # 現在行までの積算(current)が出来たので、currentに対して左から配置可能なところを探す
    __yoko_search(current, row).each do |max_h, max_w|
      h = max_h - 1
      (0...max_w).each do |w|
        #debug "ans[#{h}][#{w}] = #{ans[h][w]}+1"
        ans[h][w] += 1
      end
    end
  end
  ans
end

# 横の検索を動的計画法によって行う
# @param current [Array]  現在行までの縦の配置可能数の和
# @param row     [String] 現在行の情報
# @return [Enumerator] 条件を満たす最大widgetサイズの列挙 [ [h,w], ... ]
def __yoko_search(current, row)
  #debug "  __yoko_search(#{current}, #{row}) start"
  Enumerator.new do |y|
    sum = ZeroArray.dup  # 動的計画法による現在列までの横の配置可能数の和
    (0...row.length).each do |i|
      #debug "  __yoko_search(#{current}, #{row}) i=#{i}"
      # 横の配置可能数を動的計画法で加算していく
      if row.getbyte(i) == 0x30
        (0...current[i]).each { |j| sum[j] += 1 }
        sum[current[i]] = 0
      else
        sum.map!{0}
      end

      #debug "  __yoko_search(#{current}, #{row}) sum=#{sum}"
      min_sum_j = -1  # 範囲内の最小のsum[j]を入れる
      (0..sum.length).each do |j|
        break if (sum[j]||0)==0
        #debug "  __yoko_search(#{current}, #{row}) ans<<[#{j+1}, #{sum[j]}]"
        if min_sum_j == -1
          min_sum_j = sum[j]
        elsif min_sum_j > sum[j]
          min_sum_j = sum[j]
        end
        y.yield j+1, min_sum_j   # 配置可能な最大サイズがわかったので値を返却する
      end
    end
    #debug "  __yoko_search(#{current}, #{row}) => #{ans}"
  end
end


# ['1000', '1101', ...]   文字列を１次元配列として持つ
area = (0...$H).map { gets.chomp }

ans = bi_search(area)
#debug ans.inspect

$N = gets.to_i
(0...$N).each do
  h, w = gets.split.map &:to_i
  ans_h = ans[h-1]
  puts (ans_h && ans_h[w-1])||0
end

