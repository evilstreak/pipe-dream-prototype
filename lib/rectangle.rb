require './lib/point.rb'

class Rectangle
  DEFAULT_COLOR = Gosu::Color::WHITE

  # The internal representation is two points (top-left and bottom-right)
  attr_accessor :left, :top, :right, :bottom, :color

  def self.from_center(window, center, width, height, color = DEFAULT_COLOR)
    new(window, center.x - width / 2, center.y - height / 2,
        center.x + width / 2, center.y + height / 2, color)
  end

  def self.from_points(window, top_left, bottom_right, color = DEFAULT_COLOR)
    new(window, top_left.x, top_left.y, bottom_right.x, bottom_right.y, color)
  end

  def initialize(window, left, top, right, bottom, color = DEFAULT_COLOR)
    @window = window
    @left = left
    @top = top
    @right = right
    @bottom = bottom
    @color = color
  end

  # We provide a bunch of other ways to interact with a rectangle
  def width
    right - left
  end

  def width=(new_width)
    @right = left + new_width
  end

  def height
    bottom - top
  end

  def height=(new_height)
    @bottom = top + new_height
  end

  def top_left
    Point.new(left, top)
  end

  def top_left=(point)
    @left = point.x
    @top = point.y
  end

  def top_right
    Point.new(left, top)
  end

  def top_right=(point)
    @right = point.x
    @top = point.y
  end

  def bottom_left
    Point.new(left, bottom)
  end

  def bottom_left=(point)
    @left = point.x
    @bottom = point.y
  end

  def bottom_right
    Point.new(right, bottom)
  end

  def bottom_right=(point)
    @right = point.x
    @bottom = point.y
  end

  def center
    Point.new((left + right) / 2, (top + bottom) / 2)
  end

  # Move the rectangle by the vector given
  def offset(x, y)
    @left += x
    @top += y
    @right += x
    @bottom += y
  end

  # Move the rectangle to a given point (top-left)
  def move_to(point)
    offset(point.x - @left, point.y - @top)
  end

  def draw
    @window.draw_quad(left, top, color,
                      right, top, color,
                      left, bottom, color,
                      right, bottom, color)
  end

  def under_mouse?
    contains_point?(Point.new(@window.mouse_x, @window.mouse_y))
  end

  def contains_point?(point)
    point.x >= left && point.x <= right &&
      point.y >= top && point.y <= bottom
  end
end
