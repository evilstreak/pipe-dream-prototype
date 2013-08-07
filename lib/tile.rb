require './lib/rectangle.rb'
require './lib/draggable.rb'

class Tile < Rectangle
  include Draggable

  TILE_COLOR = Gosu::Color::BLUE
  TILE_HIGHLIGHT_COLOR = Gosu::Color::GREEN

  attr_accessor :x, :y, :size

  def initialize(window, x, y, size)
    super(window)
    @x = x
    @y = y
    @size = size
  end

  private

  def color
    dragging? ? TILE_HIGHLIGHT_COLOR : TILE_COLOR
  end

  # Top left corner
  def x1; x + offset_x; end
  def y1; y + offset_y; end

  # Bottom right corner
  def x2; x1 + size; end
  def y2; y1 + size; end
end
