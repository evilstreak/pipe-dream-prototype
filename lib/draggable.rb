require './lib/point.rb'

module Draggable
  def start_dragging
    @draggable_origin = top_left
    @window.listen(:mouse_drag_end, method(:stop_dragging))
    @window.listen(:mouse_drag_move, method(:on_mouse_move))
  end

  def stop_dragging(point)
    if dragging?
      @window.emit(drop_event, self)
      @window.emit(:"#{drop_event}_hack", self)
    end
    @draggable_origin = nil
    @window.stop_listening(:mouse_drag_end, method(:stop_dragging))
    @window.stop_listening(:mouse_drag_move, method(:on_mouse_move))
  end

  private

  def dragging?
    !@draggable_origin.nil?
  end

  def on_mouse_move(old_position, new_position)
    offset(new_position.x - old_position.x, new_position.y - old_position.y)
    @window.emit(drag_event, self)
  end

  def drag_event
    :"#{draggable_event_class}_drag"
  end

  def drop_event
    :"#{draggable_event_class}_drop"
  end

  def draggable_event_class
    self.class.name.downcase
  end
end
