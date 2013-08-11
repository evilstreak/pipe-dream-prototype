require './lib/tile.rb'

class Tile::Straight < Tile
  public_class_method :new

  private

  def draw_water
    right_side = left + width * @flow_progress / FLOW_SPEED
    @window.draw_quad(left, top, WATER_COLOR,
                      right_side, top, WATER_COLOR,
                      left, bottom, WATER_COLOR,
                      right_side, bottom, WATER_COLOR)
  end

  def flow_exits
    [:left, :right]
  end

  def top_layer_image
    'pipe-overlay.png'
  end
end
