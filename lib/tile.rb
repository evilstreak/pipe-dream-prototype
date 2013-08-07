require './lib/point.rb'
require './lib/rectangle.rb'
require './lib/draggable.rb'

class Tile < Rectangle
  include Draggable

  TILE_COLOR = Gosu::Color::BLUE
  TILE_HIGHLIGHT_COLOR = Gosu::Color::GREEN

  attr_accessor :point, :size

  def initialize(window, point, size, droppable)
    super(window)
    @point = point
    @size = size
    @droppable = droppable
  end

  private

  def color
    dragging? ? TILE_HIGHLIGHT_COLOR : TILE_COLOR
  end

  def top_left
    point.offset(offset_x, offset_y)
  end

  def bottom_right
    top_left.offset(size, size)
  end
end
