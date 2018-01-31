#!/usr/bin/env ruby

def debug(str)
  STDERR.puts str
end

# 動的計画法の組み合わせで検索を行う
# @param  area    [Array]         D1〜DH までのホーム画面情報を１次元配列で。 例： ['1000', '1101', ...]
# @param  widgets [Array<Array>]  [S1,T1]〜[SN,TN] までのウイジェットサイズ情報をジャグ配列で。 例： [[1,3], [2,3], ...]
# @return [Array] ウイジェットごとの配置可能数を配列で
def bi_search(area, widgets)
  sorted = widgets.sort{ |a,b| a[1] <=> b[1] }.uniq  # w の昇順でソートし重複排除
  ans = _bi_search(area, sorted)
  widgets.map{ |w| ans[w]||0 }  # ウイジェットの並び順どおりに答えをマップ
end

# 下請け関数
# widgets が w の昇順でソートされている状態で処理を行う
# @return [Hash] { [h,w] => count } のハッシュ
def _bi_search(area, widgets)
  #debug "widgets=#{widgets.inspect}"

  ans = {}                   # 答えを詰めていくための { [h,w] => count } のハッシュ
  current = (0...$W).map{0}  # 動的計画法による現在行までの縦の配置可能数の和

  # 行ごとにループ
  area.each do |row|
    # 現在行までの縦の配置可能数の和を更新する
    #debug "--- row=#{row} ---"
    (0...current.length).each do |i|
      #debug "current=#{current.inspect} ans=#{ans.inspect}"
      #debug "row[i]=#{row[i]}"
      if row[i] == '0'  # 配置可能
        current[i] += 1
      else              # 配置不可
        current[i] = 0
      end
    end

    # current が出来たので、現在までの行に対して左から配置可能なところを探す
    __yoko_search(current, row, widgets).each do |widget|
      ans[widget] = (ans[widget]||0) + 1
    end
  end
  ans
end

# 横の検索を動的計画法によって行う
# @param current [Array]  現在行までの縦の配置可能数の和
# @param row     [String] 現在行の情報
# @param widgets
# @return [Hash] 条件を満たすwidgetの配列 [ [h,w], ... ]
def __yoko_search(current, row, widgets)
  #debug "  __yoko_search(#{current}, #{row}, #{widgets}) start"
  ans = []  # 答えを入れるための配列
  sum = 0
  (0...row.length).each do |i|
    # 横の配置可能数を動的計画法で加算していく
    if row[i] == '0'
      sum += 1
    else
      sum = 0
    end

    # 横の配置可能数に収まるウイジェットに対してループ
    widgets.take_while{|hw| hw[1] <= sum}.each do |hw|
      #debug "  __yoko_search i=#{i} sum=#{sum} widget(#{hw})"

      # 現在位置(i) から左に hw[1] マス分を見て、縦の配置可能数が
      # ウイジェットの縦サイズ以下であれば、配置可能と判断する
      if ((i-hw[1]+1)..i).all? { |j| current[j] >= hw[0] }
        ans << hw
      end
    end
  end
  #debug "  __yoko_search(#{current}, #{row}, #{widgets}) => #{ans}"
  ans
end

$H, $W = gets.split.map &:to_i

# ['1000', '1101', ...]   文字列を１次元配列として持つ
area = (0...$H).map { gets.chomp }

$N = gets.to_i

# [[1,3], [2,3], ...]  h,w の２次元配列
widgets = (0...$N).map { gets.split.map &:to_i }

puts bi_search(area, widgets).join("\n")

