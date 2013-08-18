require './lib/cell.rb'
require './lib/tile/block.rb'

class Grid
  SCROLL_SPEED = 10.0

  def initialize(window, top_left, row_count, cell_size)
    @window = window
    @row_count = row_count
    @cell_size = cell_size

    # Build the first column
    @cells = []
    @cells << build_start_column(top_left)

    # Add columns until the screen is full
    add_column while @cells.last.first.onscreen?

    # Set the obstacle chances
    @obstacle_chance = 0.3
    @extra_obstacle_chance = 0

    @window.listen(:update, method(:scroll_grid))
    @window.listen(:flow_blocked, method(:on_flow_blocked))
  end

  def draw
    @cells.flatten.each(&:draw)
  end

  def start_flow
    @start_tile.start_flow(:wnw)
  end

  def scroll_grid(time_elapsed)
    # Move existing cells
    @cells.flatten.each do |cell|
      cell.offset(-time_elapsed * @cell_size / SCROLL_SPEED, 0)
    end

    # If the leftmost column is off the screen remove it
    if @cells.first.first.offscreen?
      @cells.shift.each do |cell|
        cell.cleanup
      end
    end

    # If the rightmost column is on the screen add a new one
    add_column if @cells.last.first.onscreen?
  end

  def on_flow_blocked
    @window.stop_listening(:update, method(:scroll_grid))
  end

  private

  def build_start_column(top_left)
    column = build_column(top_left)

    # Build a set of tiles to go into the cells
    start_index = rand(@row_count)
    column.each.with_index do |cell, index|
      if index == start_index
        tile = build_start_tile(cell)
      else
        tile = build_tile(Tile::Block, cell)
      end
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

    # Add obstacles
    new_column.sample(random_tile_count).each do |cell|
      build_obstacle(cell)
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

  def build_start_tile(cell)
    @start_tile ||= build_tile(Tile::Straight, cell, 0)
  end

  def build_obstacle(cell)
    build_tile(Tile::Block, cell)
  end

  def build_tile(tile_class, cell, orientation = nil)
    tile = tile_class.new(@window, cell.center, 96, orientation)
    tile.snap_to(cell)
    cell.tile = tile
  end

  def random_tile_count
    return 0 unless @obstacle_chance && @obstacle_chance > 0

    if rand < @obstacle_chance
      if rand < @extra_obstacle_chance
        @extra_obstacle_chance = 0
        2
      else
        @extra_obstacle_chance += 0.2
        1
      end
    else
      0
    end
  end
end
