require './lib/cell.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED

  def initialize(window, top_left, columns, rows, cell_size)
    @window = window
    @cells = columns.times.flat_map do |col_index|
      build_column(top_left.offset(col_index * cell_size, 0), rows, cell_size)
    end
  end

  def draw
    @cells.each(&:draw)
  end

  private

  def build_column(top_left, cell_count, cell_size)
    center = top_left.offset(cell_size / 2, cell_size / 2)
    cell_count.times.map do |cell_index|
      Cell.new(@window, center.offset(0, cell_index * cell_size), cell_size)
    end
  end
end
