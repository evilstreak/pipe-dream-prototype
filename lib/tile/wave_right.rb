require './lib/tile.rb'

class Tile::WaveRight < Tile
  public_class_method :new

  private

  def draw_water
    if @flow_progress > 0
      if @flow_entry_point == :wnw
        entry_side = left
        exit_side = left + width * @flow_progress / pipe_length
      else
        entry_side = right
        exit_side = right - width * @flow_progress / pipe_length
      end

      @window.draw_quad(entry_side, top, WATER_COLOR,
                        exit_side, top, WATER_COLOR,
                        entry_side, bottom, WATER_COLOR,
                        exit_side, bottom, WATER_COLOR)
    end
  end

  def flow_exits
    [:wnw, :ese]
  end

  def top_layer_image
    'wave-right.png'
  end

  def pipe_length
    114.46
  end
end
