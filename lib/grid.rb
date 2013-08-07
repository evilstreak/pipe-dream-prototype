require './lib/rectangle.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED
  BORDER_COLOR = Gosu::Color::WHITE

  def initialize(window, x, y, columns, rows, tile_size)
    @background = Rectangle.new(window, x1: x, y1: y,
                                x2: y + columns * tile_size,
                                y2: y + rows * tile_size,
                                color: BORDER_COLOR)

    @cells = columns.times.flat_map do |col_index|
      rows.times.map do |row_index|
        Rectangle.new(window,
                      x1: x + col_index * tile_size + 1,
                      y1: y + row_index * tile_size + 1,
                      x2: x + (col_index + 1) * tile_size - 1,
                      y2: y + (row_index + 1) * tile_size - 1,
                      color: CELL_COLOR)
      end
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
end
