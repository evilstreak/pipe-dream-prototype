require './lib/cell.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED

  def initialize(window, top_left, column_count, row_count, cell_size)
    @window = window
    @row_count = row_count
    @cell_size = cell_size

    # Build the first column
    @cells = []
    @cells << build_column(top_left, @row_count, @cell_size)

    # Add the rest of the columns
    (column_count - 1).times { add_column }
  end

  def draw
    @cells.flatten.each(&:draw)
  end

  private

  def add_column
    last_column = @cells.last

    # Build a column the right of the previous one
    top_left = last_column.first.top_right
    new_column = build_column(top_left, @row_count, @cell_size)

    # Add references to left/right neighbours
    last_column.zip(new_column).each do |left, right|
      left.right_neighbour = right
      right.left_neighbour = left
    end

    @cells << new_column
  end

  # Add another column to the right hand side of the grid
  def build_column(top_left, cell_count, cell_size)
    # Build the cells
    center = top_left.offset(cell_size / 2, cell_size / 2)
    column = cell_count.times.map do |cell_index|
      Cell.new(@window, center.offset(0, cell_index * cell_size), cell_size)
    end

    # Add references to top/bottom neighbours
    column.each_cons(2) do |top, bottom|
      top.bottom_neighbour = bottom
      bottom.top_neighbour = top
    end

    column
  end
end
