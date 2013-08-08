require './lib/point.rb'

module Draggable
  def start_dragging
    if draggable?
      @draggable_origin = Point.new(@window.mouse_x, @window.mouse_y)
      @droppable.snap(self)
    end
  end

  def stop_dragging
    if dragging?
      snap_point = @droppable.drop
      if snap_point
        offset(snap_point.x - @left, snap_point.y - @top)
        @droppable = nil
      end
      @draggable_origin = nil
    end
  end

  def dragging?
    !@draggable_origin.nil?
  end

  def draggable?
    !@droppable.nil?
  end

  private

  def offset_x
    dragging? ? @window.mouse_x - @draggable_origin.x : 0
  end

  def offset_y
    dragging? ? @window.mouse_y - @draggable_origin.y : 0
  end
end
