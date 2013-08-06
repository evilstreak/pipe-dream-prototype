require 'gosu'

class MainWindow < Gosu::Window
  def initialize
    super(960, 640, false)
    self.caption = 'Pipe Dreams'
  end

  # Called 60 times per second to update game state.
  def update
  end

  # Usually called after update, sometimes more or less frequently due to
  # frame rate. Draw the whole screen here, no state changes.
  def draw
  end

  # Enables display of the system cursor
  def needs_cursor?
    true
  end
end

window = MainWindow.new
window.show
