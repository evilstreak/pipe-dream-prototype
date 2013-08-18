require './lib/tile.rb'

class Tile::Corner < Tile
  public_class_method :new

  private

  def draw_water
    if @flow_progress > 0
      progress = @flow_progress / FLOW_SPEED

      if progress <= 0.5
        if @flow_entry_side == :left
          @window.draw_triangle(left, top, WATER_COLOR,
                                left + width * progress * 2, top, WATER_COLOR,
                                left, bottom, WATER_COLOR)
        else
          @window.draw_triangle(right, bottom, WATER_COLOR,
                                right, bottom - width * progress * 2, WATER_COLOR,
                                left, bottom, WATER_COLOR)
        end
      else
        if @flow_entry_side == :left
          @window.draw_quad(left, top, WATER_COLOR,
                            right, top, WATER_COLOR,
                            left, bottom, WATER_COLOR,
                            right, top + width * (progress - 0.5) * 2, WATER_COLOR)
        else
          @window.draw_quad(right, bottom, WATER_COLOR,
                            right, top, WATER_COLOR,
                            left, bottom, WATER_COLOR,
                            right - width * (progress - 0.5) * 2, top, WATER_COLOR)
        end
      end
    end
  end

  def flow_exits
    [:left, :bottom]
  end

  def top_layer_image
    'loose-corner.png'
  end
end
