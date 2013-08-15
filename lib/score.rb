class Score
  TIME_MULTIPLIER = 165

  def initialize(window)
    @window = window
    @score = 0.0

    @window.listen(:update, method(:on_update))
  end

  def to_s
    @score.to_i.to_s
  end

  def on_update(time_elapsed)
    @score += time_elapsed * TIME_MULTIPLIER
  end
end
