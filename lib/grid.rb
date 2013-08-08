require './lib/point.rb'
require './lib/rectangle.rb'
require './lib/square.rb'
require './lib/cell.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED
  BORDER_COLOR = Gosu::Color::WHITE
  CELL_PADDING = 1

  def initialize(window, top_left, columns, rows, cell_size)
    @cells = rows.times.flat_map do |row_index|
      build_row(window, top_left.offset(0, row_index * cell_size), columns,
                cell_size)
    end
  end

  def update
    @cells.each { |cell| cell.color = CELL_COLOR }
    if @draggable
      cell = snap_cell(@draggable)
      cell.color = CELL_HIGHLIGHT_COLOR if cell
    end
  end

  def draw
    @cells.each(&:draw)
  end

  # Show where this draggable should snap to when dropped
  def snap(draggable)
    @draggable = draggable
  end

  # @returns the point this draggable should snap to, or nil if it won't snap
  def drop
    cell = snap_cell(@draggable)
    cell.tile = @draggable if cell
    @draggable = nil
    cell.top_left if cell
  end

  private

  def snap_cell(draggable)
    @cells.find { |cell| cell.will_snap?(draggable) }
  end

  def build_row(window, top_left, cell_count, cell_size)
    center = top_left.offset(cell_size / 2, cell_size / 2)
    cell_count.times.map do |cell_index|
      Cell.new(window, center.offset(cell_index * cell_size, 0), cell_size)
    end
  end
end
