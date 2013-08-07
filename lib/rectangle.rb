require './lib/point.rb'

class Rectangle
  attr_accessor :top_left, :bottom_right, :color

  def initialize(window, attributes = {})
    @window = window
    attributes.each do |attr, value|
      send("#{attr}=", value)
    end
  end

  def draw
    @window.draw_quad(top_left.x, top_left.y, color,
                      bottom_right.x, top_left.y, color,
                      top_left.x, bottom_right.y, color,
                      bottom_right.x, bottom_right.y, color)
  end

  def under_mouse?
    contains_point?(Point.new(@window.mouse_x, @window.mouse_y))
  end

  def contains_point?(point)
    point.x >= top_left.x && point.x <= bottom_right.x &&
      point.y >= top_left.y && point.y <= bottom_right.y
  end

  def center
    Point.new((top_left.x + bottom_right.x) / 2,
              (top_left.y + bottom_right.y) / 2)
  end
end
