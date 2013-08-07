require './lib/point.rb'
require './lib/rectangle.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED
  BORDER_COLOR = Gosu::Color::WHITE
  CELL_PADDING = 1

  def initialize(window, point, columns, rows, cell_size)
    @background = Rectangle.new(window,
                                top_left: point,
                                bottom_right: Point.new(point.x + columns * cell_size,
                                                        point.y + rows * cell_size),
                                color: BORDER_COLOR)

    @cells = rows.times.flat_map do |row_index|
      build_row(window, point.x, point.y + row_index * cell_size, columns,
                cell_size)
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
      top_left = Point.new(x + cell_index * cell_size + CELL_PADDING,
                           y + CELL_PADDING)
      bottom_right = Point.new(x + (cell_index + 1) * cell_size - CELL_PADDING,
                               y + cell_size - CELL_PADDING)

      Rectangle.new(window, top_left: top_left, bottom_right: bottom_right,
                    color: CELL_COLOR)
    end
  end
end
