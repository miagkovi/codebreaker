class Player
  def initialize(name, turns, code)
    @name = name
    @turns = turns
    @code = code
  end

  def to_s
    "Player: #{@name} | Turns: #{@turns} | Code: #{@code}"
  end
end
