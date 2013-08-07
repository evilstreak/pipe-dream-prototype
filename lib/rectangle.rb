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
    @window.mouse_x >= x1 && @window.mouse_x <= x2 &&
      @window.mouse_y >= y1 && @window.mouse_y <= y2
  end
end
