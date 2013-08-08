require './lib/rectangle.rb'

class TileRack
  RACK_COLOR = Gosu::Color::GRAY

  def initialize(window, top_left, bottom_right, tile_count, droppable)
    @background = Rectangle.new(window, top_left: top_left,
                                        bottom_right: bottom_right,
                                        color: RACK_COLOR)

    @tiles = build_tiles(window, top_left, bottom_right, tile_count, droppable)
  end

  def draw
    @background.draw
    @tiles.each(&:draw)
  end

  def under_mouse?
    @background.under_mouse?
  end

  def mouse_down
    tile = @tiles.find(&:under_mouse?)
    tile.start_dragging if tile
  end

  def mouse_up
    @tiles.each(&:stop_dragging)
  end

  private

  def build_tiles(window, top_left, bottom_right, tile_count, droppable)
    x_offset = (bottom_right.x - top_left.x - 96) / 2
    tile_offset = (bottom_right.y - top_left.y) / tile_count
    y_offset = (tile_offset - 96) / 2
    tile_count.times.map do |index|
      Tile.new(window,
               top_left.offset(x_offset, y_offset + tile_offset * index),
               96,
               droppable)
    end
  end
end
