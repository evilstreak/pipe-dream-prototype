require './lib/point.rb'
require './lib/rectangle.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED
  BORDER_COLOR = Gosu::Color::WHITE
  CELL_PADDING = 1

  def initialize(window, point, columns, rows, cell_size)
    @background = build_background(window, point, columns, rows, cell_size)

    @cells = rows.times.flat_map do |row_index|
      build_row(window, point.x, point.y + row_index * cell_size, columns,
                cell_size)
    end
  end

  def update
    @cells.each { |cell| cell.color = CELL_COLOR }
    if @draggable
      snap_cell = cell_containing(@draggable.center)
      snap_cell.color = CELL_HIGHLIGHT_COLOR if snap_cell
    end
  end

  def draw
    @background.draw
    @cells.each(&:draw)
  end

  # Show where this draggable should snap to when dropped
  def snap(draggable)
    @draggable = draggable
  end

  # @returns the point this draggable should snap to, or nil if it won't snap
  def drop
    cell = cell_containing(@draggable.center)
    @draggable = nil
    if cell
      Point.new(cell.top_left.x - CELL_PADDING, cell.top_left.y - CELL_PADDING)
    end
  end

  private

  def cell_containing(point)
    @cells.find do |cell|
      cell.contains_point?(point)
    end
  end

  def build_background(window, top_left, columns, rows, cell_size)
    bottom_right = Point.new(top_left.x + columns * cell_size,
                             top_left.y + rows * cell_size)

    Rectangle.new(window, top_left: top_left,
                          bottom_right: bottom_right,
                          color: BORDER_COLOR)
  end

  def build_row(window, x, y, cell_count, cell_size)
    cell_count.times.map do |cell_index|
      top_left = Point.new(x + cell_index * cell_size + CELL_PADDING,
                           y + CELL_PADDING)
      bottom_right = Point.new(x + (cell_index + 1) * cell_size - CELL_PADDING,
                               y + cell_size - CELL_PADDING)

      Rectangle.new(window, top_left: top_left, bottom_right: bottom_right,
                    color: CELL_COLOR)
    end
  end
end
