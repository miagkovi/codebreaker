class Game
  attr_reader :attempts, :hint

  def initialize
    @code = ''
    @attempts = 0
    @hint = true
  end

  def start
    @code = Code.new
  end

  def save(player_name)
    player = Player.new(player_name, @attempts, @code.to_s)
    scoreboard = Scoreboard.new
    scoreboard.save_scores(player)
  end

  def use_hint
    @hint = false
    @code.to_s[rand(0..3)]
  end

  def analyze(guess_code)
    @attempts += 1
    @code.compare_with(guess_code)
  end
end
