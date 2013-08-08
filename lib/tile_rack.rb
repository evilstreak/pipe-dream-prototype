require './lib/rectangle.rb'

class TileRack
  RACK_COLOR = Gosu::Color::GRAY

  def initialize(window, top_left, bottom_right, tile_count, droppable)
    @background = Rectangle.from_points(window, top_left, bottom_right, RACK_COLOR)

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
    offset = (bottom_right.y - top_left.y) / tile_count
    point = top_left.offset((bottom_right.x - top_left.x) / 2, offset / 2)

    tile_count.times.map do |index|
      Tile.new(window, point.offset(0, offset * index), 96, droppable)
    end
  end
end
