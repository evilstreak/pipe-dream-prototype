require './lib/tile.rb'

class Tile::Corner < Tile
  public_class_method :new

  private

  def draw_water
    progress = @flow_progress / FLOW_SPEED
    if progress <= 0.5
      @window.draw_triangle(left, top, WATER_COLOR,
                            left + width * progress * 2, top, WATER_COLOR,
                            left, bottom, WATER_COLOR)
    else
      @window.draw_quad(left, top, WATER_COLOR,
                        right, top, WATER_COLOR,
                        left, bottom, WATER_COLOR,
                        right, top + width * (progress - 0.5) * 2, WATER_COLOR)
    end
  end

  def flow_exits
    [:left, :bottom]
  end

  def top_layer_image
    'pipe-corner.png'
  end
end
