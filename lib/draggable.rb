require './lib/point.rb'

module Draggable
  def start_dragging
    @draggable_origin = @window.mouse_position
    @window.listen(:mouse_up, method(:stop_dragging))
    @window.listen(:mouse_move, method(:on_mouse_move))
  end

  def stop_dragging
    @window.emit(drop_event, self) if dragging?
    @draggable_origin = nil
    @window.stop_listening(:mouse_up, method(:stop_dragging))
    @window.stop_listening(:mouse_move, method(:on_mouse_move))
  end

  private

  def dragging?
    !@draggable_origin.nil?
  end

  def on_mouse_move(position)
    @window.emit(drag_event, self)
  end

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
