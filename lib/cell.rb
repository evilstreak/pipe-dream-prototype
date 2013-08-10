require 'forwardable'
require './lib/square.rb'

class Cell
  extend Forwardable

  BORDER_WIDTH = 1
  BORDER_COLOR = Gosu::Color::WHITE
  BACKGROUND_COLOR = Gosu::Color::GRAY
  HIGHLIGHT_COLOR = Gosu::Color::RED

  attr_accessor :tile

  def_delegators :@background, :color=
  def_delegators :@border, :top_left, :contains_point?

  def initialize(window, center, width)
    @window = window
    @border = Square.from_center(@window, center, width, BORDER_COLOR)
    @background = Square.from_center(@window, center, width - BORDER_WIDTH,
                                     BACKGROUND_COLOR)

    @window.listen(:tile_drag, method(:on_tile_drag))
    @window.listen(:tile_drop, method(:on_tile_drop))
  end

  def draw
    @border.draw
    @background.draw
    @tile.draw if filled?
  end

  def will_snap?(draggable)
    !filled? && contains_point?(draggable.center)
  end

  def filled?
    !@tile.nil?
  end

  def on_tile_drag(dragged_tile)
    self.color = will_snap?(dragged_tile) ? HIGHLIGHT_COLOR : BACKGROUND_COLOR
  end

  def on_tile_drop(dropped_tile)
    if will_snap?(dropped_tile)
      @tile = dropped_tile
      @tile.snap_to(self)
      @window.emit(:tile_snap, @tile)
    end
    self.color = BACKGROUND_COLOR
  end
end
