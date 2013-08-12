require './lib/cell.rb'
require './lib/tile/block.rb'

class Grid
  CELL_COLOR = Gosu::Color::GRAY
  CELL_HIGHLIGHT_COLOR = Gosu::Color::RED

  def initialize(window, top_left, column_count, row_count, cell_size)
    @window = window
    @row_count = row_count
    @cell_size = cell_size

    # Build the first column
    @cells = []
    @cells << build_start_column(top_left)

    # Add the rest of the columns
    (column_count - 1).times { add_column }
  end

  def draw
    @cells.flatten.each(&:draw)
  end

  def start_flow
    @start_tile.start_flow(:left)
  end

  private

  def build_start_column(top_left)
    column = build_column(top_left)

    # Build a set of tiles to go into the cells
    start_index = rand(@row_count)
    column.each.with_index do |cell, index|
      if index == start_index
        tile = build_start_tile(cell.center)
      else
        tile = build_block_tile(cell.center)
      end

      cell.tile = tile
      tile.cell = cell
    end
  end

  def add_column
    last_column = @cells.last

    # Build a column the right of the previous one
    top_left = last_column.first.top_right
    new_column = build_column(top_left)

    # Add references to left/right neighbours
    last_column.zip(new_column).each do |left, right|
      left.right_neighbour = right
      right.left_neighbour = left
    end

    @cells << new_column
  end

  # Add another column to the right hand side of the grid
  def build_column(top_left)
    # Build the cells
    center = top_left.offset(@cell_size / 2, @cell_size / 2)
    column = @row_count.times.map do |cell_index|
      Cell.new(@window, center.offset(0, cell_index * @cell_size), @cell_size)
    end

    # Add references to top/bottom neighbours
    column.each_cons(2) do |top, bottom|
      top.bottom_neighbour = bottom
      bottom.top_neighbour = top
    end

    column
  end

  def build_block_tile(center)
    Tile::Block.new(@window, center, 96)
  end

  def build_start_tile(center)
    @start_tile ||= Tile::Straight.new(@window, center, 96, 0)
  end
end
