class Tile
  attr_reader :window
  attr_accessor :x, :y, :size, :color

  def initialize(window, x, y, size, color)
    @window = window
    @x = x
    @y = y
    @size = size
    @color = color
  end

  def draw
    window.draw_quad(x1, y1, color, x2, y2, color, x3, y3, color, x4, y4, color)
  end

  def under_mouse?
    window.mouse_x >= x1 && window.mouse_x <= x3 &&
      window.mouse_y >= y1 && window.mouse_y <= y3
  end

  private

  # Top left corner
  def x1; x; end
  def y1; y; end

  # Top right corner
  def x2; x + size; end
  def y2; y; end

  # Bottom right corner
  def x3; x + size; end
  def y3; y + size; end

  # Bottom left corner
  def x4; x; end
  def y4; y + size; end
end
