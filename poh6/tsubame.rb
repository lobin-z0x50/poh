# poh6 tsubame
# https://paiza.jp/poh/joshibato/tsubame/result/23432844?o=1f7df2bf

gets.split(' ').each { |x|
  n = x.to_i
  puts n + n/10 + n%10;
}
