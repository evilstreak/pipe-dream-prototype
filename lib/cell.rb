require 'forwardable'
require './lib/square.rb'
require './lib/direction.rb'

class Cell
  extend Forwardable

  BORDER_WIDTH = 1
  BORDER_COLOR = Gosu::Color::WHITE
  BACKGROUND_COLOR = Gosu::Color::GRAY
  HIGHLIGHT_COLOR = Gosu::Color::RED

  attr_accessor :tile, :left_neighbour, :top_neighbour, :right_neighbour,
                :bottom_neighbour

  def_delegators :@background, :color=
  def_delegators :@border, :top_left, :top_right, :contains_point?, :center

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

  # Route the flow onto the next cell
  def route_flow(exit_sides)
    exit_sides.each do |side|
      neighbour = send("#{side}_neighbour")

      if neighbour
        entry_side = Direction.opposite(side)
        neighbour.start_flow(entry_side)
      else
        @window.emit(:flow_blocked)
      end
    end
  end

  def start_flow(entry_side)
    if filled?
      @tile.start_flow(entry_side)
    else
      @window.emit(:flow_blocked)
    end
  end

  def offset(x, y)
    @border.offset(x, y)
    @background.offset(x, y)
    @tile.offset(x, y) if @tile
  end

  # The cell is offscreen if all parts of it are offscreen
  def offscreen?
    @border.right <= 0 || @border.left >= @window.width
  end

  # The cell is onscreen if all parts of it are onscreen
  def onscreen?
    @border.left >= 0 && @border.right <= @window.width
  end

  private

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
