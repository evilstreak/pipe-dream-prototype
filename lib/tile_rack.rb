require './lib/rectangle.rb'
require './lib/tile.rb'

class TileRack
  RACK_COLOR = Gosu::Color::GRAY

  def initialize(window, top_left, bottom_right, tile_count, droppable)
    @background = Rectangle.from_points(window, top_left, bottom_right, RACK_COLOR)

    @tiles = build_tiles(window, top_left, bottom_right, tile_count, droppable)

    window.listen(:mouse_down, method(:on_mouse_down))
    window.listen(:tile_snap, method(:on_tile_snap))
  end

  def draw
    @background.draw
    @tiles.each(&:draw)
  end

  def on_mouse_down
    @tiles.each(&:on_mouse_down) if under_mouse?
  end

  def on_tile_snap(tile)
    @tiles.delete(tile)
  end

  private

  def under_mouse?
    @background.under_mouse?
  end

  def build_tiles(window, top_left, bottom_right, tile_count, droppable)
    offset = (bottom_right.y - top_left.y) / tile_count
    point = top_left.offset((bottom_right.x - top_left.x) / 2, offset / 2)

    tile_count.times.map do |index|
      Tile.new(window, point.offset(0, offset * index), 96, droppable)
    end
  end
end
