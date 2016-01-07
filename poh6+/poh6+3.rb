# poh6+
#https://paiza.jp/poh/joshibato/matsue-ruby/result/c0f52244

class WordDB
  def initialize
    @words = {}     # 単発単語 {word=>個数}
    @kai_words = {} # 単体で回文になっている単語(adjustメソッドで作成) {word=>個数}
    @pairs = {}     # 逆よみで同じスペルのもの {word=>個数}
  end

  ## 単語をDBに登録
  def add(str)
    r_str = str.reverse
    if @words.has_key?(r_str) && @words[r_str] > 0
      # 逆綴りの語が単発単語にすでに存在する場合
      @words[r_str] -= 1  # 単発単語から消す
      m = [r_str, str].min  # 逆綴りのものと辞書順で早い方を取得
      # ペア単語として追加
      if @pairs.has_key? m
        @pairs[m] += 1
      else
        @pairs[m] = 1;
      end
    else
      # 逆綴りの語が単発単語に存在しなければ、単発単語として登録する
      if @words.has_key?(str)
        @words[str] += 1
      else
        @words[str] = 1
      end
    end
  end

  ## 単語DBを整理
  def adjust()
    @words.keys.each do |x|
      if x.reverse == x
        # 単体での回文
        @kai_words[x] = @words[x]
      end
    end
  end

  ## 答え
  def answer()
    str1 = ''
    w = ''

    # ペアのものを辞書順に結合していく
    @pairs.keys.sort.each do |w|
      @pairs[w].times { str1 << w }
    end

    # 単体で回文になっているものは辞書順で早いものを一つだけ採用
    if @kai_words.length > 0
      w = @kai_words.keys.sort[0]
    end

    # 答え
    str1 + w + str1.reverse
  end

  def to_s()
    "words = #{@words}\n kai_words = #{@kai_words}\n  pairs = #{@pairs}"
  end
end


### --- main --- ###

db = WordDB.new()

while STDIN.getc()!="\n" do
end

str = ''
loop do
  c=STDIN.getc()
  #puts c
  if c=="\n"
    db.add str
    str = ''
  elsif c==nil
    break
  else
    str += c
  end
end

db.adjust
puts db.answer

