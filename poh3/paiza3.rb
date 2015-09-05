#!/usr/bin/env ruby

$M = gets.to_i
$N = gets.to_i

#STDERR.puts "M=#{$M} N=#{$N}"

# 最初のノードは 工数:0、コスト:0 からスタート
nodes0 = {0=>0}   # kosu => cost の Hash

# 1社ずつステージング処理
$N.times do
	kosu, cost = gets.split.map { |str| str.to_i }

	nodes1 = nodes0.clone   # 一つ前の状態をコピーし、続きの状態から処理する
	nodes0.each do |kosu0, cost0|

		next if kosu0 > $M  # すでに工数充足している場合はスキップ

		kosu1 = kosu0 + kosu   # この会社を使った場合の工数
		cost1 = cost0 + cost   # この会社を使った場合のコスト

		# ノードがすでに存在する場合は、コストが安い場合のみ上書きする
		if !nodes1.has_key?(kosu1) || nodes1[kosu1] > cost1
			nodes1[kosu1] = cost1
		end
	end

	#STDERR.puts nodes1
	nodes0 = nodes1   # 次のステージへ繰越
end

# 全ステージ終了、工数充足していてかつ最安のノードを取り出す
answer = 0
nodes0.each do |kosu, cost|
	next if kosu < $M
	if answer == 0 || answer > cost
		answer = cost
	end
end

puts answer 
