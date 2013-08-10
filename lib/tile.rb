require 'forwardable'
require './lib/square.rb'
require './lib/draggable.rb'

class Tile
  include Draggable
  extend Forwardable

  def_delegators :@background, :draw, :move_to, :top_left, :offset,
                               :under_mouse?, :center, :left, :top

  def initialize(window, center, width)
    @window = window
    @background = Square.from_center(@window, center, width)
    @base_layer = Gosu::Image.new(@window, 'media/pipe-background.png')
    @top_layer = Gosu::Image.new(@window, 'media/pipe-overlay.png')
    @window.listen(:mouse_down, method(:on_mouse_down))
  end

  def draw
    @base_layer.draw(left, top, 0)
    @top_layer.draw(left, top, 0)
  end

  def snap_to(cell)
    @cell = cell
    move_to(cell.top_left)
    @window.stop_listening(:mouse_down, method(:on_mouse_down))
  end

  private

  def on_mouse_down
    start_dragging if under_mouse?
  end
end
