require './lib/tile.rb'

class Tile::Straight < Tile
  public_class_method :new

  private

  def draw_water
    if @flow_progress > 0
      if @flow_entry_side == :left
        entry_side = left
        exit_side = left + width * @flow_progress / FLOW_SPEED
      else
        entry_side = right
        exit_side = right - width * @flow_progress / FLOW_SPEED
      end

      @window.draw_quad(entry_side, top, WATER_COLOR,
                        exit_side, top, WATER_COLOR,
                        entry_side, bottom, WATER_COLOR,
                        exit_side, bottom, WATER_COLOR)
    end
  end

  def flow_exits
    [:left, :right]
  end

  def top_layer_image
    'pipe-overlay.png'
  end
end
