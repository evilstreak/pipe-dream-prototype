module Direction
  def self.opposite(side)
    case side
    when :top then :bottom
    when :right then :left
    when :bottom then :top
    when :left then :right
    end
  end

  def self.clockwise_from(side)
    case side
    when :top then :right
    when :right then :bottom
    when :bottom then :left
    when :left then :top
    end
  end

  def self.anticlockwise_from(side)
    case side
    when :top then :left
    when :right then :top
    when :bottom then :right
    when :left then :bottom
    end
  end
end
