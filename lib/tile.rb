require './lib/point.rb'
require './lib/rectangle.rb'
require './lib/draggable.rb'

class Tile < Rectangle
  include Draggable

  TILE_COLOR = Gosu::Color::BLUE
  TILE_HIGHLIGHT_COLOR = Gosu::Color::GREEN

  attr_accessor :point, :size

  def initialize(window, point, size)
    super(window)
    @point = point
    @size = size
  end

  private

  def color
    dragging? ? TILE_HIGHLIGHT_COLOR : TILE_COLOR
  end

  def top_left
    Point.new(point.x + offset_x, point.y + offset_y)
  end

  def bottom_right
    Point.new(top_left.x + size, top_left.y + size)
  end
end
