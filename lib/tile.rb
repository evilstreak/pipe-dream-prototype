require 'forwardable'
require './lib/square.rb'
require './lib/draggable.rb'

class Tile
  include Draggable
  extend Forwardable

  FLOW_SPEED = 5.0
  WATER_COLOR = Gosu::Color.argb(0xff1abc9c)

  attr_accessor :cell

  private_class_method :new

  def_delegators :@background, :move_to, :top_left, :offset, :contains_point?,
                               :center, :left, :top, :right, :bottom, :width

  def initialize(window, center, width, orientation = nil)
    @window = window
    @background = Square.from_center(@window, center, width)
    @base_layer = Gosu::Image.new(@window, 'media/pipes/background.png')
    @top_layer = Gosu::Image.new(@window, "media/pipes/#{top_layer_image}")
    @window.listen(:mouse_drag_start, method(:on_mouse_drag_start))
    @window.listen(:mouse_click, method(:on_mouse_click))
    @flow_progress = 0.0
    @orientation = orientation || rand(4)
  end

  def draw
    @window.rotate(@orientation * 90, center.x, center.y) do
      @base_layer.draw(left, top, 0)
      draw_water
      @top_layer.draw(left, top, 0)
    end
  end

  def snap_to(cell)
    @cell = cell
    move_to(cell.top_left)
    @window.stop_listening(:mouse_drag_start, method(:on_mouse_drag_start))
    @window.stop_listening(:mouse_click, method(:on_mouse_click))
  end

  # Start pumping water into this tile. The tile will emit an event
  # @param entry_side one of :left, :top, :right, :bottom
  def start_flow(entry_side)
    side = deoriented_side(entry_side)

    if flow_exits.include?(side)
      @flow_entry_side = side
      @window.listen(:update, method(:pump_water))
    else
      @window.emit(:flow_blocked)
    end
  end

  def water_flowing?
    @flow_progress > 0 && @flow_progress < FLOW_SPEED
  end

  private

  def on_mouse_drag_start(point)
    start_dragging if contains_point?(point)
  end

  def pump_water(time_elapsed)
    @flow_progress += time_elapsed

    if @flow_progress >= FLOW_SPEED
      @flow_progress = FLOW_SPEED
      end_flow
    end
  end

  def end_flow
    exits = flow_exits.reject { |side| side == @flow_entry_side }
                      .map { |side| oriented_side(side) }

    @cell.route_flow(exits)
    @window.stop_listening(:update, method(:pump_water))
  end

  def draggable_event_class
    'tile'
  end

  # Convert from internal -> external side after adjusting for rotation
  def oriented_side(side)
    case @orientation
    when 0 then side
    when 1 then Direction.clockwise_from(side)
    when 2 then Direction.opposite(side)
    when 3 then Direction.anticlockwise_from(side)
    end
  end

  # Convert from external -> internal side after adjusting for rotation
  def deoriented_side(side)
    case @orientation
    when 0 then side
    when 1 then Direction.anticlockwise_from(side)
    when 2 then Direction.opposite(side)
    when 3 then Direction.clockwise_from(side)
    end
  end

  def on_mouse_click(point)
    rotate if contains_point?(point)
  end

  def rotate
    @orientation = (@orientation + 1) % 4
  end
end
