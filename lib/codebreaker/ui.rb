module Codebreaker
  class UI
    def initialize
      @game = Game.new
    end

    def play
      game_rules
      start_game
      take_attempt
    end

    private

    def take_attempt
      checked_guess = checked(guess)
      return win if checked_guess == '++++'
      puts checked_guess
      game_status
      take_attempt if MAX_ATTEMPTS > @game.attempts
      loose
    end

    def checked(input)
      if input == 'hint'
        use_hint if hint_available?
        take_attempt
      elsif input.like(/[1-6]{4}/)
        compare_code_with(input)
      else
        puts 'Unknown input. Enter code of 4 numbers between 1 and 6.'
      end
    end

    def start_game
      @game.start
    end

    def compare_code_with(guess_code)
      @game.analyze(guess_code)
    end

    def hint_available?
      @game.hint
    end

    def game_status
      puts "You have #{MAX_ATTEMPTS - @game.attempts} more attempt(s)"
      puts 'You can use a hint' if hint_available?
    end

    def game_rules
      puts 'C O D E B R E A K E R'
      puts 'Try to break a secret code of 4 numbers between 1 and 6.'
      puts "You have #{MAX_ATTEMPTS} attempts and a hint"
      puts '(enter `hint` to use a hint).'
    end

    def game_over
      puts 'Game over.'
      puts show_results
      exit
    end

    def guess
      puts 'Please enter your guess:'
      gets.chomp
    end

    def play_again
      puts 'Do you want to start a new game?'
      start_new_game if agree?
      game_over
    end

    def start_new_game
      @game = Game.new
      play
    end

    def player_name
      puts 'Please enter your name:'
      name = gets.chomp
      name.empty? ? player_name : name
    end

    def save_result
      puts 'Do you want to save your result?'
      @game.save(player_name) if agree?
    end

    def show_results
      scoreboard = Scoreboard.new
      scoreboard.get_scores
    end

    def use_hint
      puts 'Do you want to use a hint?'
      puts @game.use_hint if agree?
    end

    def win
      puts 'Congrats! You win!'
      save_result
      play_again
    end

    def loose
      puts 'You loose.'
      play_again
    end

    def agree?
      puts 'y / n'
      input = gets.chomp
      if input == 'y'
        true
      elsif input == 'n'
        false
      else
        puts 'Please enter `y` or `n`!'
        agree?
      end
    end
  end
end
