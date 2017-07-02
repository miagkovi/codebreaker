require 'yaml'

class Scoreboard
  def save_scores(player)
    scores = get_scores
    scores << player
    File.open('scoreboard.yaml', 'w') { |f| f.write scores.to_yaml }
  end

  def get_scores
    return [] unless File.exist?('scoreboard.yaml')
    YAML.load_file('scoreboard.yaml')
  end
end
