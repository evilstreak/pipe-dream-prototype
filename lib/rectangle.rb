class Rectangle
  attr_accessor :x1, :y1, :x2, :y2, :color

  def initialize(window, attributes = {})
    @window = window
    attributes.each do |attr, value|
      send("#{attr}=", value)
    end
  end

  def draw
    @window.draw_quad(x1, y1, color, x2, y1, color,
                      x1, y2, color, x2, y2, color)
  end

  def under_mouse?
    contains_point?(@window.mouse_x, @window.mouse_y)
  end

  def contains_point?(x, y)
    x >= x1 && x <= x2 && y >= y1 && y <= y2
  end
end
