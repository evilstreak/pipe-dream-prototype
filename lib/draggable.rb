module Draggable
  def start_dragging
    @draggable_origin = Point.new(@window.mouse_x, @window.mouse_y)
    @droppable.snap(self)
  end

  def stop_dragging
    if dragging?
      snap_point = @droppable.drop
      self.point = snap_point if snap_point
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
