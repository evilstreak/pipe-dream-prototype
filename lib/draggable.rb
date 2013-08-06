module Draggable
  def start_dragging
    @draggable_origin_x = @window.mouse_x
    @draggable_origin_y = @window.mouse_y
  end

  def stop_dragging
    if dragging?
      self.x += offset_x
      self.y += offset_y
    end

    @draggable_origin_x = nil
    @draggable_origin_y = nil
  end

  def dragging?
    @draggable_origin_x && @draggable_origin_y
  end

  private

  def offset_x
    dragging? ? @window.mouse_x - @draggable_origin_x : 0
  end

  def offset_y
    dragging? ? @window.mouse_y - @draggable_origin_y : 0
  end
end
