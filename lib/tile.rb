require './lib/rectangle.rb'
require './lib/draggable.rb'

class Tile < Rectangle
  include Draggable

  TILE_COLOR = Gosu::Color::BLUE
  TILE_HIGHLIGHT_COLOR = Gosu::Color::GREEN

  def initialize(window, center, width, droppable)
    super(window, center.x - width / 2, center.y - width / 2,
          center.x + width / 2, center.y + width / 2)
    @droppable = droppable
  end

  def left
    @left + offset_x
  end

  def right
    @right + offset_x
  end

  def top
    @top + offset_y
  end

  def bottom
    @bottom + offset_y
  end

  def color
    dragging? ? TILE_HIGHLIGHT_COLOR : TILE_COLOR
  end

  def on_mouse_down
    start_dragging if under_mouse?
  end
end
