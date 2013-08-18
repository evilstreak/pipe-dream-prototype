require 'forwardable'
require './lib/square.rb'
require './lib/direction.rb'

class Cell
  extend Forwardable

  BORDER_WIDTH = 1
  BORDER_COLOR = Gosu::Color.argb(0xffecf0f1)
  BACKGROUND_COLOR = Gosu::Color.argb(0xffbdc3c7)
  HIGHLIGHT_COLOR = Gosu::Color.argb(0xffe74c3c)

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
  def route_flow(exit_points)
    exit_points.each do |exit_point|
      side = Direction.exit_side(exit_point)
      neighbour = send("#{side}_neighbour")

      if neighbour
        entry_point = Direction.opposite_exit(exit_point)
        neighbour.start_flow(entry_point)
      else
        @window.emit(:flow_blocked)
      end
    end
  end

  def start_flow(entry_point)
    if filled?
      @tile.start_flow(entry_point)
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

  # Cleanup this cell for removal from the grid
  def cleanup
    # Check we don't have flowing water
    @window.emit(:flow_blocked) if water_flowing?

    # Remove neighbour references
    Direction.cardinals.each do |side|
      neighbour = send("#{side}_neighbour")
      our_side = "#{Direction.opposite_side(side)}_neighbour="
      neighbour.send(our_side, nil) if neighbour
    end
  end

  private

  def will_snap?(draggable)
    !filled? && contains_point?(draggable.center) && draggable.center.x <= 800
  end

  def filled?
    !@tile.nil?
  end

  def water_flowing?
    filled? && @tile.water_flowing?
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
