# coding: utf-8

# 最大発注費用(万円)
MAX = 5000000


######################################################
#クラス群
######################################################

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

# 組み合わせ
class Pattern
    def initialize(coms)
        @companys = coms
    end

    def getTotalNum()
        total = 0
        for com in @companys do
            total += com.getNum()
        end
        return total
    end

    def getTotalCost()
        total = 0
        for com in @companys do
            total += com.getPrice()
        end
        return total
    end
end


######################################################
#関数群
######################################################

# 全ての組み合わせを取得する
def makePatterns(coms)
    num = coms.length
    patterns = Array.new

    while num > 0 do
	# 全下請け会社の中からcombinationで全て取得
        combinations = coms.combination(num)
        combinations.collect {|item| 
            patterns << Pattern.new(item) 
        }
        
        num = num - 1
    end
    
    return patterns
end

# 一番安い組み合わせを取得する
def searchCheap(need, pats)
    cheap = MAX

    for pat in pats do
        if pat.getTotalNum() < need then
            next
        end

        totalCost = pat.getTotalCost()
        if cheap > totalCost then
            cheap = totalCost
        end
    end
    
    # 解なし
    if cheap == MAX then 
        return "None"
    end
    
    return cheap
end

######################################################
#メイン
######################################################


# すべての会社
companys = Array.new

# すべての会社の組み合わせ
patterns = Array.new

# 必要な人員数
m = gets.to_i

# 下請け会社数
n = gets.to_i

# インプット数まわして取り出す
for num in 1..n do
    tmp = gets.split(" ")
    companys << Company.new(tmp[0].to_i, tmp[1].to_i)
end

# 全ての組み合わせを取り出す
patterns = makePatterns(companys)

# 最も安い組み合わせを取り出して、結果を出力
puts searchCheap(m, patterns)

