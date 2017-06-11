module Codebreaker
  class Game
    def initialize
      setup
    end

    def start
      while @attempts > 0
        take_attempt
        if attempt_result == '++++'
          puts 'You WIN!!!'
          save_result
          new_game
          game_over
          break
        else
          puts attempt_result
        end
      end
      puts 'You loose.'
      new_game
      game_over
    end

    private

    def attempt_result
      @result
    end

    def compare(secret, guess)
      secret_copy = ''
      guess_copy = ''
      @result = ''
      (0..3).each do |i|
        if secret[i] == guess[i]
          @result << '+'
        else
          secret_copy << secret[i]
          guess_copy << guess[i]
        end
      end
      secret_copy.each_char do |a|
        guess_copy.each_char do |b|
          @result << '-' if a == b
        end
      end
      @result = @result == '' ? 'No maches....' : @result
    end

    def analyze(input)
      if input == 'hint'
        puts use_hint
        take_attempt
      elsif input.match(/[1-6]{4}/).to_s.eql?(input)
        @attempts -= 1
        compare(@code, input)
      else
        puts 'Invalid input. Please read game instructions...'
        take_attempt
      end
    end

    def take_attempt
      input = ''
      puts "You have #{@attempts} more attempts."
      puts @hint ? 'You have a hint' : 'No hint!'
      loop do
        puts 'Your guess:'
        input = gets.chomp
        if input.empty?
          puts 'No input.'
        else
          break
        end
      end
      analyze(input)
    end

    def create_code
      (Array.new(4) { rand(1..6) }).join.to_s
    end

    def use_hint
      if @hint
        @hint = false
        @code[rand(0..3)]
      else
        puts 'No more hints!'
      end
    end

    def save_result
      puts 'Do you want to save result?'
      save if accept
    end

    def save
      puts 'Your name (5 chars max):'
      player_name = gets.chomp.to_s.slice(0..4).upcase
      File.open('results.txt', 'w+') do |file|
        file.puts("#{player_name} / #{10 - @attempts} / #{@code}")
      end
      puts 'Your result is saved'
    end

    def game_over
      puts 'Game Over!'
      exit
    end

    def new_game
      puts 'Play again?'
      accept ? restart : game_over
    end

    def accept
      puts 'y / n'
      input = gets.chomp
      if input == 'y'
        true
      elsif input == 'n'
        false
      else
        puts 'Please enter `y` or `n`!'
        accept
      end
    end

    def restart
      system 'clear'
      setup
      start
    end

    def setup
      @code = create_code
      @attempts = 10
      @hint = true
      @result = ''
    end
  end
end

game = Codebreaker::Game.new

game.start