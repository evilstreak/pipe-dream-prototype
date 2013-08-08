require 'forwardable'
require './lib/square.rb'

class Cell
  extend Forwardable

  BORDER_WIDTH = 1
  BORDER_COLOR = Gosu::Color::WHITE
  BACKGROUND_COLOR = Gosu::Color::GRAY
  HIGHLIGHT_COLOR = Gosu::Color::RED

  def_delegators :@background, :color=
  def_delegators :@border, :top_left, :contains_point?

  def initialize(window, center, width)
    @border = Square.from_center(window, center, width, BORDER_COLOR)
    @background = Square.from_center(window, center, width - BORDER_WIDTH,
                                     BACKGROUND_COLOR)
  end

  def draw
    @border.draw
    @background.draw
  end

  def will_snap?(draggable)
    contains_point?(draggable.center)
  end
end
