require './lib/rectangle.rb'
require './lib/tile/straight.rb'
require './lib/tile/loose_corner.rb'
require './lib/tile/tight_corner.rb'
require './lib/tile/wave_left.rb'
require './lib/tile/wave_right.rb'

class TileRack
  RACK_COLOR = Gosu::Color.argb(0xff7f8c8d)
  TILE_WIDTH = 96

  def initialize(window, top_left, bottom_right, tile_count)
    @window = window
    @background = Rectangle.from_points(@window, top_left, bottom_right,
                                        RACK_COLOR)

    @tiles = build_tiles(tile_count)

    @window.listen(:tile_drop_hack, method(:on_tile_drop))
    @window.listen(:tile_snap, method(:on_tile_snap))
  end

  def draw
    @background.draw
    @tiles.each(&:draw)
  end

  private

  # TODO: This conflicts with Cell#on_tile_drop if it uses to tile_drop event.
  #   It only works if the Cell register its event listener first.
  def on_tile_drop(dropped_tile)
    layout_tiles
  end

  def on_tile_snap(snapped_tile)
    # Replace the snapped tile with a new one in the same position
    @tiles.map!.with_index do |tile, index|
      tile == snapped_tile ? build_tile : tile
    end

    layout_tiles
  end

  def under_mouse?
    @background.under_mouse?
  end

  def build_tiles(tile_count)
    @tiles = tile_count.times.map { build_tile }
    layout_tiles
  end

  def build_tile
    tile_class = case rand(5)
    when 0 then Tile::Straight
    when 1 then Tile::LooseCorner
    when 2 then Tile::TightCorner
    when 3 then Tile::WaveLeft
    when 4 then Tile::WaveRight
    end

    tile_class.new(@window, Point.new(0, 0), TILE_WIDTH)
  end

  def layout_tiles
    offset = @background.height / @tiles.count
    point = @background.top_left.offset((@background.width - TILE_WIDTH) / 2,
                                        (offset - TILE_WIDTH) / 2)

    @tiles.each.with_index do |tile, index|
      tile.move_to(point.offset(0, index * offset))
    end
  end
end
