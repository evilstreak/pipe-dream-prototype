require './lib/point.rb'

module Draggable
  def start_dragging
    @draggable_origin = Point.new(@window.mouse_x, @window.mouse_y)
    @window.listen(:mouse_up, method(:stop_dragging))
    @window.emit(drag_event, self)
  end

  def stop_dragging
    @window.emit(drop_event, self) if dragging?
    @draggable_origin = nil
    @window.stop_listening(:mouse_up, method(:stop_dragging))
  end

  def dragging?
    !@draggable_origin.nil?
  end

  private

  def offset_x
    dragging? ? @window.mouse_x - @draggable_origin.x : 0
  end

  def offset_y
    dragging? ? @window.mouse_y - @draggable_origin.y : 0
  end

  def drag_event
    :"#{self.class.name.downcase}_drag"
  end

  def drop_event
    :"#{self.class.name.downcase}_drop"
  end
end
