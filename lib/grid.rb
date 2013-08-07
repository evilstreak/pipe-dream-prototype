require './lib/rectangle.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED
  BORDER_COLOR = Gosu::Color::WHITE
  CELL_PADDING = 1

  def initialize(window, x, y, columns, rows, cell_size)
    @background = Rectangle.new(window, x1: x, y1: y,
                                x2: y + columns * cell_size,
                                y2: y + rows * cell_size,
                                color: BORDER_COLOR)

    @cells = rows.times.flat_map do |row_index|
      build_row(window, x, y + row_index * cell_size, columns, cell_size)
    end
  end

  def update
    if @snappable
      @cells.each do |cell|
        # TODO: It seems slightly abusive to update every cell on every update
        cell.color = cell.under_mouse? ? CELL_HIGHLIGHT_COLOR : CELL_COLOR
      end
    end
  end

  def draw
    @background.draw
    @cells.each(&:draw)
  end

  def start_snapping(tile)
    @snappable = tile
  end

  def stop_snapping
    @snappable = nil
    @cells.each { |cell| cell.color = CELL_COLOR }
  end

  private

  def build_row(window, x, y, cell_count, cell_size)
    cell_count.times.map do |cell_index|
      Rectangle.new(window,
                    x1: x + cell_index * cell_size + CELL_PADDING,
                    y1: y + CELL_PADDING,
                    x2: x + (cell_index + 1) * cell_size - CELL_PADDING,
                    y2: y + cell_size - CELL_PADDING,
                    color: CELL_COLOR)
    end
  end
end
