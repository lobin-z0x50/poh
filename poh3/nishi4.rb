# coding: utf-8

# 会社
class Company
    def initialize(a, b)
        @num = a
        @price = b
    end
    def getPrice()
        return @price
    end
    def getNum()
        return @num
    end
end

companys = Array.new
@patterns = {0=>0}

# 必要な人員数
@member = gets.to_i
# 下請け会社数
n = gets.to_i

# インプット数まわして取り出す
for num in 1..n do
    tmp = gets.split(" ")
    companys << Company.new(tmp[0].to_i, tmp[1].to_i)
end

def setPatterns(coms)
    for i in 0..coms.length-1 do
        price = coms[i].getPrice()
        num = coms[i].getNum()
        # 値が混ざるのでコピー
        tmp = Marshal.load(Marshal.dump(@patterns))
        tmp.each {|key,value|
            #人員確保完了。これ以上検索しない
            if key >= @member then
                next
            end

            if tmp[key + num].nil? || @patterns[key + num] > tmp[key] + price then
                @patterns[key + num] = tmp[key] + price
            end
        }  
    end
end

# 一番安い組み合わせを取得する
def search()
    @patterns.select! {|key, val| key >= @member } 
    @patterns.values.min
end

setPatterns(companys)
puts search()

