module Draggable
  def start_dragging
    @draggable_origin = Point.new(@window.mouse_x, @window.mouse_y)
  end

  def stop_dragging
    if dragging?
      self.point = Point.new(point.x + offset_x, point.y + offset_y)
      @draggable_origin = nil
    end
  end

  def dragging?
    @draggable_origin
  end

  private

  def offset_x
    dragging? ? @window.mouse_x - @draggable_origin.x : 0
  end

  def offset_y
    dragging? ? @window.mouse_y - @draggable_origin.y : 0
  end
end
