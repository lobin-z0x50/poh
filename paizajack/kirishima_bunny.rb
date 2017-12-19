#!/usr/bin/ruby
# kirishima_bunny

LIMIT_BET=400

# Stringクラスを拡張
class String
  def split_to_i
    self.gsub(/\s*#.*$/, '').split(" ").map(&:to_i)
  end
end

class RoundContext
  attr_reader :tips, :round, :combo

  # コンストラクタ
  def initialize(tips, round, combo)
    @tips = tips
    @round = round
    @combo = combo
  end
end

class GameContext
  #     自分のカード, 何戦目か, 現在の連勝数,   最大BET,    ディーラーのカード
  attr_reader :cards, :round, :contenuous_wins, :bet_limit, :dealer_cards

  # コンストラクタ
  def initialize(cards, round, contenuous_wins, bet_limit, dealer_cards=nil)
    @cards = cards
    @round = round
    @contenuous_wins = contenuous_wins
    @bet_limit = bet_limit
    @dealer_cards = dealer_cards
  end
end

class CardSet
  attr_reader :cards

  # コンストラクタ
  def initialize(cards)
    @cards = cards
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
    LIMIT_BET *
#      case round_ctx.combo
#        when 0; 0.1
#        when 1; 0.5
#        when 2; 0.8
#        else 1
#      end
1
  end

  # 手を考える
  # :HIT or :STAND
  def think(ctx)
    ds = ctx.dealer_cards.eval

    s = ctx.cards.eval
    #STDERR.puts "eval=#{s}"

    # 21 を超えている場合(負け確定)、
    # 21 の場合、
    # 相手が 21 を超えている場合
    return :STAND if s.length == 0 || s.max==21 || ds.length == 0

    # 同点の場合は必ず引く
    return :HIT if s.max == ds.max && s.max<21

    if s.max > ds.max
      # 勝っている場合
      if ds.length == 1
        return :STAND if s.max >= 16
      else
        # 複数評価がある場合は19以上のときのみSTAND
        return :STAND if s.max >= 19
      end
    end
    :HIT
  end
end

str = gets.split_to_i
if str[0] == 0
  rctx = RoundContext.new(str[1], gets.to_i, gets.to_i)
  puts '%d'%Player.new.bet(rctx)
else
  ctx = GameContext.new(CardSet.new(str), gets.to_i, gets.to_i, gets.to_i, CardSet.new(gets.split_to_i))
  puts Player.new.think(ctx)
end

