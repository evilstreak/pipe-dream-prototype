require 'gosu'
require './lib/point.rb'
require './lib/grid.rb'
require './lib/tile_rack.rb'
require './lib/eventable.rb'
require './lib/score.rb'
require './lib/score_counter.rb'

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
      @speed_multiplier += delta / 90.0
    end
  end

  # Usually called after update, sometimes more or less frequently due to
  # frame rate. Draw the whole screen here, no state changes.
  def draw
    @grid.draw
    @rack.draw
    @counter.draw
    @gameover.draw(0, 188, 1) unless @gameover.nil?
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
    @gameover = Gosu::Image.from_text(self, game_over_text,
                                     'media/Lato-Reg.ttf', 72, 24, 960, :center)
    listen(:mouse_down, method(:restart_game))
  end

  def game_over_text
    "Game over\n You scored #{@score}\nClick to restart"
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
    @score = Score.new(self)
    @counter = ScoreCounter.new(self, @score, Point.new(760, 40))
    @last_update = Time.now
    @speed_multiplier = 1.0

    listen(:flow_blocked, method(:game_over))
    listen(:tile_snap, method(:start_flow))
    listen(:mouse_down, method(:on_mouse_down))
    listen(:mouse_up, method(:on_mouse_up))
    listen(:mouse_move, method(:on_mouse_move))
  end

  # Tear down all the old stuff and prepare a new game
  def restart_game
    @gameover = nil
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

  def on_mouse_down
    @mouse_down_position = mouse_position
  end

  def on_mouse_up
    if @mouse_dragging
      emit(:mouse_drag_end, mouse_position)
    else
      emit(:mouse_click, @mouse_down_position)
    end

    @mouse_down_position = nil
    @mouse_dragging = false
  end

  def on_mouse_move(old_position, new_position)
    if @mouse_dragging
      emit(:mouse_drag_move, old_position, new_position)
    elsif @mouse_down_position
      dx = new_position.x - @mouse_down_position.x
      dy = new_position.y - @mouse_down_position.y

      if dx.abs > 3 || dy.abs > 3
        emit(:mouse_drag_start, @mouse_down_position)
        @mouse_down_position = nil
        @mouse_dragging = true
      end
    end
  end
end

MainWindow.new.show
