require './lib/rectangle.rb'
require './lib/draggable.rb'

class Tile < Rectangle
  include Draggable

  TILE_COLOR = Gosu::Color::BLUE
  TILE_HIGHLIGHT_COLOR = Gosu::Color::GREEN

  def initialize(window, center, width)
    super(window, center.x - width / 2, center.y - width / 2,
          center.x + width / 2, center.y + width / 2, TILE_COLOR)

    @window.listen(:mouse_down, method(:on_mouse_down))
  end

  def snap_to(cell)
    @cell = cell
    move_to(cell.top_left)
    @window.stop_listening(:mouse_down, method(:on_mouse_down))
  end

  def start_dragging
    super
    self.color = TILE_HIGHLIGHT_COLOR
  end

  def stop_dragging
    super
    self.color = TILE_COLOR
  end

  private

  def on_mouse_down
    start_dragging if under_mouse?
  end
end
