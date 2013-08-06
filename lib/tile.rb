require './lib/draggable.rb'

class Tile
  include Draggable

  attr_reader :window
  attr_accessor :x, :y, :size, :color

  def initialize(window, x, y, size)
    @window = window
    @x = x
    @y = y
    @size = size
  end

  def draw
    window.draw_quad(x1, y1, color, x2, y2, color, x3, y3, color, x4, y4, color)
  end

  def under_mouse?
    window.mouse_x >= x1 && window.mouse_x <= x4 &&
      window.mouse_y >= y1 && window.mouse_y <= y4
  end

  private

  def color
    dragging? ? Gosu::Color::GRAY : Gosu::Color::WHITE
  end

  # Top left corner
  def x1; x + offset_x; end
  def y1; y + offset_y; end

  # Top right corner
  def x2; x1 + size; end
  def y2; y1; end

  # Bottom left corner
  def x3; x1; end
  def y3; y1 + size; end

  # Bottom right corner
  def x4; x2; end
  def y4; y3; end
end
