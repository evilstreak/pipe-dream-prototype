require 'forwardable'
require './lib/square.rb'
require './lib/draggable.rb'

class Tile
  include Draggable
  extend Forwardable

  FLOW_SPEED = 2.0
  WATER_COLOR = Gosu::Color::BLUE

  private_class_method :new

  def_delegators :@background, :move_to, :top_left, :offset, :under_mouse?,
                               :center, :left, :top, :right, :bottom, :width

  def initialize(window, center, width)
    @window = window
    @background = Square.from_center(@window, center, width)
    @base_layer = Gosu::Image.new(@window, 'media/pipe-background.png')
    @top_layer = Gosu::Image.new(@window, "media/#{top_layer_image}")
    @window.listen(:mouse_down, method(:on_mouse_down))
    @flow_progress = 0.0
  end

  def draw
    @base_layer.draw(left, top, 0)
    draw_water
    @top_layer.draw(left, top, 0)
  end

  def snap_to(cell)
    @cell = cell
    move_to(cell.top_left)
    @window.stop_listening(:mouse_down, method(:on_mouse_down))
  end

  # Start pumping water into this tile. The tile will emit an event
  # @param entry_side one of :left, :top, :right, :bottom
  def start_flow(entry_side)
    if flow_exits.include?(entry_side)
      @flow_start = Time.now
      @flow_entry_side = entry_side
      @window.listen(:update, method(:pump_water))
    else
      @window.emit(:flow_blocked)
    end
  end

  private

  def on_mouse_down
    start_dragging if under_mouse?
  end

  def pump_water
    @flow_progress = [Time.now - @flow_start, FLOW_SPEED].min
    end_flow if @flow_progress == FLOW_SPEED
  end

  def end_flow
    exits = flow_exits.reject { |exit| exit == @flow_entry_side }
    @cell.route_flow(exits)
    @window.stop_listening(:update, method(:pump_water))
  end

  def draggable_event_class
    'tile'
  end
end
