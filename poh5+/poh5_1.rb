#!/usr/bin/ruby

SP = '*'

class Table2x2
  attr_accessor :values, :offset, :width, :vstep

  def initialize(vals, offset)
    @values = vals.flatten
    @offset = offset
    @vstep = @width = 2
  end

  def [](x, y)
    return nil if x<0 || x>=@width || y<0 || y>=@width  # 範囲外ならnil
    @values[y*@width + x]
  end

  def []=(x, y, val)
    return nil if x<0 || x>=@width || y<0 || y>=@width  # 範囲外ならnil
    @values[y*@width + x] = val
  end

  # 要素入れ替え
  def swap(x0, y0, x1, y1)
    tmp = self[x0, y0]
    self[x0, y0] = self[x1, y1]
    self[x1, y1] = tmp
  end

  # 移動
  def move(x, y)
    xy = [x-1,y-1, x,y-1, x+1,y-1, x-1,y, x+1,y, x-1,y+1, x,y+1, x+1,y+1]
    i=0
    while i<xy.size
      x1, y1 = xy[i], xy[i+1]
      if self[x1,y1] == 0
        swap(x,y, x1,y1)
        return
      end
      i+=2
    end
  end

  # 完成しているかどうかを判定する
  def completion?()
    for y in 0...@width
      for x in 0...(@width - (y==@width-1 ? 1 : 0))
        #printf(STDERR, "Table:: w=%d, ofst=%d vs=%d [%d,%d]=%d\n", @width, @offset, @vstep, x, y, self[x,y])
        #printf(STDERR, "Table:: ans=%d\n", @offset + x + y * @vstep + 1)
        return false if self[x, y] != @offset + x + y * @vstep + 1
      end
    end
    #printf(STDERR, "last=%d, ans=%d\n", self[@width-1, @width-1], @offset + (@width-1) * @vstep + @width)
    (self[@width-1, @width-1] == @offset + (@width-1) * @vstep + @width) || (self[@width-1, @width-1] == 0)
  end

  def semi_completion?()
  end

  # デバッグ用
  def to_s()
    s = []
    for i in 0...@width
      s << @values[i*@width, @width].join(' ')
    end
    s.join("\n")
  end
end

class Table4x4 < Table2x2

  def initialize(vals)
    super(vals, 0)
    @vstep = @width = 4
  end

  def quadrant(n)
    case n
    when 0
      idx = [0,1,4,5]; ofst = 0
    when 1
      idx = [2,3,6,7]; ofst = 2
    when 2
      idx = [8,9,12,13]; ofst = 8
    when 3
      idx = [10,11,14,15]; ofst = 10
    end
    a = []
    idx.each { |i| a<<@values[i] }
    t = Table2x2.new(a, ofst);
    t.vstep = @vstep
    t
  end

end

# main
table = []
4.times { table << gets.tr('*', '0').split.map(&:to_i) }
t = Table4x4.new(table)

printf(STDERR, "table=#{t}\n")
printf(STDERR, "1,2=#{t[1,2]}\n")
printf(STDERR, "comp? #{t.completion?}\n")

not_comp = []
(0..3).each do |i|
  tq = t.quadrant(i)
  not_comp << tq if !tq.completion?
end

while not_comp.size>0
  tq = not_comp.sample(1)[0]
  rx = rand(tq.width) 
  ry = rand(tq.width) 
  puts "move(#{rx}, #{ry}) val=#{tq[rx,ry]}"
  tq.move(rx, ry)
  if tq.completion?
    printf(STDERR, "comp! last=%d\n", not_comp.size)
    not_comp.delete(tq) 
  end
end

printf(STDERR, "table=#{t}\n")
