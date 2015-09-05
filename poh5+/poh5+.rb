#!/usr/bin/ruby
require 'logger'

$log = Logger.new(STDERR)

$N = 4

# 矩形を表す
class Area
  attr_reader :left, :top, :right, :bottom

  def initialize(x0, y0, x1, y1, x2=nil, y2=nil)
    @left = [x0, x1, x2].compact.min
    @top = [y0, y1, y2].compact.min
    @right = [x0, x1, x2].compact.max
    @bottom = [y0, y1, y2].compact.max
  end
 
  def to_s()
    "Area:[#{left},#{top}/#{right},#{bottom}]"
  end

  # 左上？
  def topleft?(x,y)
    x == @left && y == @top
  end
  # 右上？
  def topright?(x,y)
    x == @right && y == @top
  end
  # 左下？
  def bottomleft?(x,y)
    x == @left && y == @bottom
  end
  # 右下？
  def bottomright?(x,y)
    x == @right && y == @bottom
  end
  # 左辺？（コーナを含まない）
  def leftside?(x,y)
    x == @left && @top < y && y < @bottom
  end
  # 右辺？（コーナを含まない）
  def rightside?(x,y)
    x == @right && @top < y && y < @bottom
  end
  # 上辺？（コーナを含まない）
  def topside?(x,y)
    y == @top && @left < x && x < @right
  end
  # 下辺？（コーナを含まない）
  def bottomside?(x,y)
    y == @bottom && @left < x && x < @right
  end
  # 幅
  def width
    right - left
  end
  # 高さ
  def height
    bottom - top
  end
end

class Pazzle
  attr_accessor :values, :space_x, :space_y
  attr_reader :width

  def initialize(vals, width=$N)
    @values = vals.flatten
    @width = width
    sp = @values.index(0)
    @space_x = sp % @width
    @space_y = sp / @width
  end

  def space?(x, y)
    self[x,y]==0
  end

  def [](x, y)
    return nil if x<0 || x>=@width || y<0 || y>=@width  # 範囲外ならnil
    @values[y*@width + x]
  end

  def []=(x, y, val)
    return nil if x<0 || x>=@width || y<0 || y>=@width  # 範囲外ならnil
    @values[y*@width + x] = val
  end

  def find(value)
    p = @values.index value
    [p%@width, p/@width]
  end

  # 要素入れ替え
  def _swap(x0, y0, x1, y1)
    tmp = self[x0, y0]
    self[x0, y0] = self[x1, y1]
    self[x1, y1] = tmp

    # スペース位置の設定
    if tmp==0
      @space_x, @space_y = x1, y1
      puts self[x0,y0]
    elsif self[x0,y0] == 0
      @space_x, @space_y = x0, y0
      puts tmp
    end
  end

  # 移動
  def move(x, y)
    if Math.abs(@space_x - x) <= 1 && Math.abs(@space_y - y) <= 1
      _swap(x,y, @space_x,@space_y)
    end
  end

  # 完成しているかどうかを判定する
  def completion?()
    for y in 0...@width
      for x in 0...(@width - (y==@width-1 ? 1 : 0))
        return false if self[x, y] != @offset + x + y * @vstep + 1
      end
    end
    (self[@width-1, @width-1] == @offset + (@width-1) * @vstep + @width) || (self[@width-1, @width-1] == 0)
  end

  # 回転可能かどうかチェックする
  # @param x0, y0, x1, y1: 矩形を表す２点
  # @param dir: 時計回りならtrue
  def can_rotate?(area)
    $log.debug { "can_rotate? #{area} w=#{area.width} h=#{area.height} spx,spy=[#{@space_x},#{@space_y}]" }
    return false if area.width < 1 || area.height < 1 # 2x2以上のエリアである事
    (@space_x==area.left || area.right==@space_x) && (@space_y==area.top || area.bottom==@space_y)  # スペースが回転ルート上にあること
  end

  
  # 回転
  # @param area 矩形
  # @param dir 時計回りならtrue
  # @return スペースがなければfalse, 回転成功ならtrue
  def rotate(area, dir=true)
    $log.debug { "rotate() -start- %s dir=%s"%[area,dir] }
    # スペース位置からスタート
    sx, sy = space_x, space_y
    x, y = sx, sy

    loop do
      if dir
        # 時計回り
        if area.topleft?(x,y) || area.topside?(x,y)
          dx, dy = 1, 0
        elsif area.topright?(x,y) || area.rightside?(x,y)
          dx, dy = 0, 1
        elsif area.bottomright?(x,y) || area.bottomside?(x,y)
          dx, dy = -1, 0
        elsif area.bottomleft?(x,y) || area.leftside?(x,y)
          dx, dy = 0, -1
        else
          raise "rotate error. invalid coord. xy=[%d, %d] %s"%[x, y, area]
        end
      else
        # 半時計回り
        if area.topright?(x,y) || area.topside?(x,y)
          dx, dy = -1, 0
        elsif area.topleft?(x,y) || area.leftside?(x,y)
          dx, dy = 0, 1
        elsif area.bottomleft?(x,y) || area.bottomside?(x,y)
          dx, dy = 1, 0
        elsif area.bottomright?(x,y) || area.rightside?(x,y)
          dx, dy = 0, -1
        else
          raise "rotate error. invalid coord. xy=[%d, %d] %s"%[x, y, area]
        end
      end

      x2, y2 = x+dx, y+dy

      $log.debug { "rotete() process %s dir=%s xy=[%d, %d], dx=%d, dy=%d, sxy=[%d,%d] xy2=[%d, %d]"%[area, dir, x, y, dx, dy, sx, sy, x2, y2] }

      # ブロックが渡されていなければ、スタート位置に戻った時点で終了
      break if x2==sx && y2==sy unless block_given?

      _swap(x,y, x2, y2)
      x, y = x2, y2

      # ブロックが渡されていれば継続判定を行う。
      if block_given?
        yr = yield
        break unless yr
      end
    end

    true
  end

  # デバッグ用
  def to_s()
    s = []
    for i in 0...@width
      s << @values[i*@width, @width].map{|v| sprintf('%2d', v) }.join(' ')
    end
    s.join("\n")
  end
end

class Brain
  
  def initialize(pazzle)
    @pazzle = pazzle
    @fixed = []
  end

  # 移動
  # @param val  移動対象とするコマの値
  # @param x    移動先X
  # @param y    移動先Y
  def move_to(val, x, y)
    vx, vy = @pazzle.find val   # 移動対象コマの現在位置
    $log.debug { "move_to() '#{val}':[#{vx},#{vy}] -> [#{x},#{y}]" }
    return nil if vx==x && vy==y

    tx, ty = vx, vy
    if x == vx
      tx += tx==0 ? 1 : -1
    end
    if y == vy
      ty += (ty<@pazzle.width-1) ? 1 : -1
    end
    a = Area.new(x,y, tx,ty)
    $log.debug { "move_to() tx,ty=[#{tx},#{ty}]" }

    while !@pazzle.can_rotate?(a)
      tx, ty = vx, vy
      # 回転できなければスペースの位置を調整する
      if tx == @pazzle.space_x
        tx = tx==0 ? tx+1 : tx-1
      end
      if ty == @pazzle.space_y
        ty = ty<@pazzle.width-1 ? ty+1 : ty-1
      end
      $log.debug { "adjust space pos. tx,ty=[#{tx},#{ty}]" }
      @pazzle.rotate(Area.new(tx, ty, @pazzle.space_x, @pazzle.space_y)) #{ !@pazzle.can_rotate?(a) }

      $log.debug { "table=\n#{@pazzle}" }
    end

    @pazzle.rotate(a) { @pazzle[x,y] != val }
  end

  def play()
    $log.debug { "table=\n#{@pazzle}" }
    move_to(1, 0,0)
    $log.debug { "table=\n#{@pazzle}" }
    move_to(4, 3,1)
    @pazzle.rotate(Area.new(2,0, 3,1)) { @pazzle[3,0] != 4 }
    $log.debug { "table=\n#{@pazzle}" }
    move_to(2, 2,1)
    $log.debug { "table=\n#{@pazzle}" }
    move_to(3, 1,1)
    $log.debug { "table=\n#{@pazzle}" }
    @pazzle.rotate(Area.new(1,0, 2,1)) { @pazzle[1,0] != 2 }
  end
end


# main
table = []
$N.times { table << gets.tr('*', '0').split.map(&:to_i) }

t = Pazzle.new(table)
br = Brain.new(t)

begin
  br.play
rescue => e
  $log.fatal { "Error: #{e.message}\n\t#{e.backtrace.join("\n\t")}"  }
end

