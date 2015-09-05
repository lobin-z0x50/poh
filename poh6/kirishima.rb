# poh6 kirishima
# https://paiza.jp/poh/joshibato/kirishima/result/3b762f04

class Sugoroku
  def initialize(m)
    @m = m
  end

  def run(pos, me, check)
    pos += me
	return 'No'  if pos <= 0 || @m.length <= pos  # 範囲外
	return 'Yes' if pos == @m.length-1            # ゴール
	return 'No'  if check.has_key? pos            # 同じ場所に来た
	check[pos] = 1;
	return run(pos, @m[pos], check);
  end
end

gets
M = gets.split(' ').map { |x| x.to_i }

sugoroku = Sugoroku.new(M)

N = gets.to_i
N.times do
  puts sugoroku.run(0, gets.to_i, {})
end
