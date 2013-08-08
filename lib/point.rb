Point = Struct.new(:x, :y) do
  # @returns a new Point offset the given amount from this one
  def offset(x_offset, y_offset)
    Point.new(x + x_offset, y + y_offset)
  end
end
