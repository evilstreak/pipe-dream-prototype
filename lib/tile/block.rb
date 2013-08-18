require './lib/tile.rb'

class Tile::Block < Tile
  public_class_method :new

  private

  def draw_water
    # No water!
  end

  def flow_exits
    # No exits!
    []
  end

  def top_layer_image
    'block.png'
  end
end
