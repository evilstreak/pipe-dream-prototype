require 'gosu'
require './lib/point.rb'
require './lib/grid.rb'
require './lib/tile_rack.rb'
require './lib/eventable.rb'

class MainWindow < Gosu::Window
  include Eventable

  def initialize
    super(960, 640, false)
    self.caption = 'Pipe Dreams'

    prepare_game
  end

  # Called 60 times per second to update game state.
  def update
    emit_mouse_move_event

    delta = Time.now - @last_update
    @last_update += delta

    # Emit an update event with the amount of time since the last one
    if @game_running
      emit(:update, delta * @speed_multiplier)
      @speed_multiplier += delta / 60.0
    end
  end

  # Usually called after update, sometimes more or less frequently due to
  # frame rate. Draw the whole screen here, no state changes.
  def draw
    @grid.draw
    @rack.draw
  end

  # Enables display of the system cursor
  def needs_cursor?
    true
  end

  # Called every time the game receives input from keyboard or mouse.
  def button_down(key)
    case key
    when Gosu::MsLeft
      emit(:mouse_down)
    end
  end

  def button_up(key)
    case key
    when Gosu::MsLeft
      emit(:mouse_up)
    end
  end

  def mouse_position
    Point.new(mouse_x, mouse_y)
  end

  def game_over
    stop_listening(:flow_blocked, method(:game_over))
    @game_running = false
    puts 'Game over, flow blocked, you lose.'
    listen(:mouse_down, method(:restart_game))
  end

  def start_flow(dropped_tile)
    stop_listening(:tile_snap, method(:start_flow))
    @game_running = true
    @grid.start_flow
  end

  # Prepare a new game ready to be started
  def prepare_game
    @grid = Grid.new(self, Point.new(80, 80), 5, 96)
    @rack = TileRack.new(self, Point.new(800,0), Point.new(960,640), 4)
    @last_update = Time.now
    @speed_multiplier = 1.0

    listen(:flow_blocked, method(:game_over))
    listen(:tile_snap, method(:start_flow))
  end

  # Tear down all the old stuff and prepare a new game
  def restart_game
    clear_all_listeners
    prepare_game
  end

  def clear_all_listeners
    @eventable_listeners = nil
  end

  private

  def emit_mouse_move_event
    new_position = mouse_position
    if new_position != @mouse_previous_position
      emit(:mouse_move, @mouse_previous_position, new_position)
      @mouse_previous_position = new_position
    end
  end
end

MainWindow.new.show
