#!/usr/bin/ruby
# tsubame_red_bunny.rb
# @auther: LOBIN
# @since:  2017-12-11

BET_LIMIT=10000
BET_LIMIT2=1000000

# Stringクラスを拡張
class String
  def split_to_i
    self.gsub(/\s*#.*$/, '').split(" ").map(&:to_i)
  end
end

class RoundContext
  attr_reader :tips, :round, :combo, :prev_coin

  # コンストラクタ
  def initialize(tips, round, combo=nil, prev_coin=nil)
    @tips = tips
    @round = round
    @combo = combo || 0
    @prev_coin = prev_coin || 0
  end
end

class GameContext
  #     自分のカード, 何戦目か, 現在の連勝数,   最大BET,    ディーラーのカード, 山のカード
  attr_reader :cards, :round, :contenuous_wins, :bet_limit, :dealer_cards, :yama_cards

  # コンストラクタ
  def initialize(cards, round, contenuous_wins, bet_limit, dealer_cards=nil, yama_cards=nil)
    @cards = cards
    @round = round
    @contenuous_wins = contenuous_wins
    @bet_limit = bet_limit
    @dealer_cards = dealer_cards
    @yama_cards = yama_cards || CardSet.new
  end

  # HITした際にバーストするかどうかを推測
  # [ 0: 親HIT
  #   1: 親STAND 自分HIT
  #   2: 親HIT   自分HIT ]
  def infer_bursts
    @br ||= [
      GameContext._is_burst(dealer_cards, yama_cards.cards[0]),
      GameContext._is_burst(cards, yama_cards.cards[0]),
      GameContext._is_burst(cards, yama_cards.cards[1])
    ]
  end

private
  def self._is_burst(cards, c)
    return false if c.nil? || cards.min <= 11
    cc = cards.append c
    cc.max.nil? || cc.max > 21
  end
end

class CardSet
  attr_reader :cards

  # コンストラクタ
  def initialize(cards=nil)
    @cards = cards || []
  end

  def length
    @cards.length
  end

  # カードを追加して別インスタンスを生成
  def append(cards)
    CardSet.new @cards.dup << cards
  end

  # 文字列からインスタンスを作る
  def self.parse(str)
    CardSet.new(str.gsub(/\s*#.*$/, '').split(" ").map(&:to_i))
  end

  # 手札の評価値を計算する
  # 21以下の評価値を配列で返す
  # 3 5 9  -> [17]
  # 6 7 9  -> []
  # 1      -> [1, 11]
  # 1 10   -> [11, 21]
  # 1 10 1 -> [12]
  def eval
    return @eval if @eval

    # 動的計画法の亜種
    ans = [0]
    @cards.each do |c|
      for i in 0..(ans.length-1)
        ans[i] += c
        #STDERR.puts "i=#{i}, ans[i]=#{ans[i]}"
      end
      if c == 1
        # エースの場合は11と評価するノードを追加
        ans << ans[0] + 10  # TODO: ans[1] がある場合はそっちからも分岐が必要？
      end
    end
    @eval = ans.select{|x| x<=21}.uniq
  end

  # 手札の評価値の最大値 (eval.max のショートカット)
  def max
    @max ||= eval.max
  end

  # 手札の評価値の最小値 (eval.min のショートカット)
  def min
    @min ||= eval.min
  end
end

class Player

  # BET枚数を決める
  def bet(round_ctx)
    [ BET_LIMIT,
      [ round_ctx.prev_coin*[16-round_ctx.combo, 8].max/16, BET_LIMIT2 ].min
    ].max
  end

  # 手を考える
  # :HIT or :STAND
  def think(ctx)
    ds = ctx.dealer_cards.eval

    s = ctx.cards.eval
    #STDERR.puts "eval=#{s}"

    # どちらかが21以上の場合はSTAND
    return :STAND if s.length == 0 || s.max==21 || ds.length == 0 || ds.max==21

    # 10以下の場合は必ず引く
    return :HIT if s.max <= 10

    # 親バースト, 親STAND時の自分バースト, 親HIT時の自分バースト
    dealer_will_burst, i_will_burst1, i_will_burst2 =  ctx.infer_bursts

    if ctx.dealer_cards.length < ctx.cards.length # 親は既にSTANDしている
      # 勝っている場合
      return :STAND if s.max > ds.max
      # 負けている場合
      return i_will_burst1 ? :STAND : :HIT
    end

    if ds.max <= 16 # 親はHITするだろうと推測
      #STDERR.puts "#{dealer_will_burst} || #{i_will_burst2}"
      return :STAND if dealer_will_burst || i_will_burst2
      return :HIT
    end

    # 勝っている、またはバーストする場合はSTAND
    return :STAND if s.max > ds.max || i_will_burst1
    :HIT
  end
end

str = gets.split_to_i
if str[0] == 0
  rctx = RoundContext.new(str[1], gets.to_i, gets.to_i, gets.to_i)
  puts '%d'%Player.new.bet(rctx)
else
  ctx = GameContext.new(CardSet.new(str), gets.to_i, gets.to_i, gets.to_i, CardSet.new(gets.split_to_i), CardSet.new(gets&.split_to_i))
  puts Player.new.think(ctx)
end

