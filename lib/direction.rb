module Direction
  def self.cardinals
    [:top, :right, :left, :bottom]
  end

  # There are two possible exits on each side of a tile
  def self.exits
    [:nne, :ene, :ese, :sse, :ssw, :wsw, :wnw, :nnw]
  end

  def self.exit_side(exit_point)
    case exit_point
    when :nne then :top
    when :ene then :right
    when :ese then :right
    when :sse then :bottom
    when :ssw then :bottom
    when :wsw then :left
    when :wnw then :left
    when :nnw then :top
    end
  end

  def self.opposite_side(side)
    case side
    when :top then :bottom
    when :right then :left
    when :bottom then :top
    when :left then :right
    end
  end

  def self.opposite_exit(exit_point)
    case exit_point
    when :nne then :sse
    when :ene then :wnw
    when :ese then :wsw
    when :sse then :nne
    when :ssw then :nnw
    when :wsw then :ese
    when :wnw then :ene
    when :nnw then :ssw
    end
  end

  def self.clockwise_from(exit_point)
    case exit_point
    when :nne then :ese
    when :ene then :sse
    when :ese then :ssw
    when :sse then :wsw
    when :ssw then :wnw
    when :wsw then :nnw
    when :wnw then :nne
    when :nnw then :ene
    end
  end

  def self.anticlockwise_from(exit_point)
    case exit_point
    when :nne then :wnw
    when :ene then :nnw
    when :ese then :nne
    when :sse then :ene
    when :ssw then :ese
    when :wsw then :sse
    when :wnw then :ssw
    when :nnw then :wsw
    end
  end
end
