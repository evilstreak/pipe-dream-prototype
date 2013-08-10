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

    @grid = Grid.new(self, Point.new(80, 80), 5, 5, 96)
    @rack = TileRack.new(self, Point.new(640,80), Point.new(880,560), 4)

    listen(:flow_blocked, method(:game_over))
  end

  # Called 60 times per second to update game state.
  def update
    emit_mouse_move_event
    emit(:update)
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
    puts 'Game over, flow blocked, you lose.'
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
