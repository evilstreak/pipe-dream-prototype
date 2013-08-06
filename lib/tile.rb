require './lib/rectangle.rb'
require './lib/draggable.rb'

class Tile < Rectangle
  include Draggable

  attr_accessor :x, :y, :size

  def initialize(window, x, y, size)
    super(window, color: Gosu::Color::WHITE)
    @x = x
    @y = y
    @size = size
  end

  private

  def color
    dragging? ? Gosu::Color::GRAY : Gosu::Color::WHITE
  end

  # Top left corner
  def x1; x + offset_x; end
  def y1; y + offset_y; end

  # Bottom right corner
  def x2; x1 + size; end
  def y2; y1 + size; end
end
