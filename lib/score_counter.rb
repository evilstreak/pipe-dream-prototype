class ScoreCounter
  FONT_NAME = 'media/Lato-Reg.ttf'

  def initialize(window, score, top_right)
    @window = window
    @score = score
    @top_right = top_right
    @counter = Gosu::Font.new(@window, FONT_NAME, 24)
  end

  def draw
    @counter.draw_rel(@score, @top_right.x, @top_right.y, 0, 1.0, 0.5)
  end
end
