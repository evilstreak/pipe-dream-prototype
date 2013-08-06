require 'gosu'
require './lib/tile.rb'

class MainWindow < Gosu::Window
  def initialize
    super(960, 640, false)
    self.caption = 'Pipe Dreams'

    @square = Tile.new(self, 10, 10, 96)
  end

  # Called 60 times per second to update game state.
  def update
  end

  # Usually called after update, sometimes more or less frequently due to
  # frame rate. Draw the whole screen here, no state changes.
  def draw
    @square.draw
  end

  # Enables display of the system cursor
  def needs_cursor?
    true
  end

  # Called every time the game receives input from keyboard or mouse.
  def button_down(key)
    case key
    when Gosu::MsLeft
      if @square.under_mouse?
        @square.start_dragging
      end
    end
  end

  def button_up(key)
    case key
    when Gosu::MsLeft
      if @square.dragging?
        @square.stop_dragging
      end
    end
  end
end

MainWindow.new.show
