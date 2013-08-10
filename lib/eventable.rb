module Eventable
  def listen(event, method)
    eventable_listeners[event] << method
  end

  def stop_listening(event, method)
    eventable_listeners[event].delete(method)
  end

  def emit(event, *args)
    eventable_listeners[event].each do |method|
      method.call(*args)
    end
  end

  private

  def eventable_listeners
    @eventable_listeners ||= Hash.new { |hash, key| hash[key] = [] }
  end
end
