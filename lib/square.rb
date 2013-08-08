require './lib/rectangle.rb'

module Square
  def self.from_center(window, center, width, color = Rectangle::DEFAULT_COLOR)
    Rectangle.from_center(window, center, width, width, color)
  end

  def self.from_top_left(window, top_left, width, color = Rectangle::DEFAULT_COLOR)
    Rectangle.from_points(window, top_left, top_left.offset(width, width), color)
  end
end
