require './lib/cell.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED

  def initialize(window, top_left, columns, rows, cell_size)
    @window = window
    @cells = rows.times.flat_map do |row_index|
      build_row(top_left.offset(0, row_index * cell_size), columns, cell_size)
    end
  end

  def draw
    @cells.each(&:draw)
  end

  private

  def build_row(top_left, cell_count, cell_size)
    center = top_left.offset(cell_size / 2, cell_size / 2)
    cell_count.times.map do |cell_index|
      Cell.new(@window, center.offset(cell_index * cell_size, 0), cell_size)
    end
  end
end
