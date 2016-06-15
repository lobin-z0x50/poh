#!/bin/env ruby

#
# カードを表すクラス
#
class Card
  attr_reader :strength

  def initialize(c)
	@c = c
	@strength = (case c
	when 'A'; 1
	when 'J'; 11
	when 'Q'; 12
	when 'K'; 13
	else c.to_i
	end + 10) % 13
  end

  def to_s
    @c
  end
end

#
# ゲームコンテキスト
#
class GameContext
  attr_reader :cards, :ba, :ranking, :last_putter

  # コンストラクタ
  def initialize(cards)
    @cards = cards
	@ranking = Array.new(52)
	@juni = 1
  end

  # 場にカードを出す
  def put(i)
    #STDERR.puts " PUT #{i} RANK=#{@juni}"
    @ba = @cards[i]
    @cards[i] = nil
    @ranking[i] = @juni
    @juni += 1
	@last_putter = i
  end

  # 最後に出した人の手番まで回ったら場を流す
  def judge_nagare(i)
    @ba = nil if i == @last_putter
  end

  # ゲーム終了判定
  def finished?
    @juni > @cards.length
  end
end

game = GameContext.new(gets.split.map { |x| Card.new(x) })
i = 0
begin
  #STDERR.puts "#{i} BA=#{game.ba} CARD=#{game.cards[i]}"

  # 手番の人がカードを持っていて、場にカードが出ている場合はそれより強ければ出す
  if game.cards[i]
    if game.ba==nil || game.ba.strength < game.cards[i].strength
      game.put(i)
    end
  end

  # 手番を進める
  i += 1
  i = 0 if game.cards.length <= i

  # 流れ判定処理
  game.judge_nagare(i)
end until game.finished?

puts game.ranking.join("\n")

