require './lib/tile.rb'

class Tile::HookLeft < Tile
  public_class_method :new

  private

  def draw_water
    if @flow_progress > 0
      progress = @flow_progress / pipe_length

      if progress <= 0.5
        if @flow_entry_point == :wnw
          @window.draw_triangle(left, top, WATER_COLOR,
                                left + width * progress * 2, bottom, WATER_COLOR,
                                left, bottom, WATER_COLOR)
        else
          @window.draw_triangle(right, top, WATER_COLOR,
                                right, top + width * progress * 2, WATER_COLOR,
                                left, top, WATER_COLOR)
        end
      else
        if @flow_entry_point == :wnw
          @window.draw_quad(left, top, WATER_COLOR,
                            left, bottom, WATER_COLOR,
                            right, bottom, WATER_COLOR,
                            right, bottom - width * (progress - 0.5) * 2, WATER_COLOR)
        else
          @window.draw_quad(right, bottom, WATER_COLOR,
                            right, top, WATER_COLOR,
                            left, top, WATER_COLOR,
                            right - width * (progress - 0.5) * 2, bottom, WATER_COLOR)
        end
      end
    end
  end

  def flow_exits
    [:wnw, :nne]
  end

  def top_layer_image
    'hook-left.png'
  end

  def pipe_length
    90.59
  end
end
