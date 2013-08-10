require 'forwardable'
require './lib/square.rb'
require './lib/draggable.rb'

class Tile
  include Draggable
  extend Forwardable

  TILE_COLOR = Gosu::Color::BLUE
  TILE_HIGHLIGHT_COLOR = Gosu::Color::GREEN

  def_delegators :@background, :draw, :move_to, :top_left, :offset, :under_mouse?, :center

  def initialize(window, center, width)
    @window = window
    @background = Square.from_center(@window, center, width, TILE_COLOR)
    @window.listen(:mouse_down, method(:on_mouse_down))
  end

  def snap_to(cell)
    @cell = cell
    move_to(cell.top_left)
    @window.stop_listening(:mouse_down, method(:on_mouse_down))
  end

  def start_dragging
    super
    @background.color = TILE_HIGHLIGHT_COLOR
  end

  def stop_dragging
    super
    @background.color = TILE_COLOR
  end

  private

  def on_mouse_down
    start_dragging if under_mouse?
  end
end
