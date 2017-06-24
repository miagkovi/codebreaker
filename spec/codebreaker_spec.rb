require 'spec_helper'

module Codebreaker
  RSpec.describe Code do
    it 'creates a secret code' do
      @code = Code.new
      expect(@code.to_s).to match(/[1-6]{4}/)
    end

    describe '#compare_with' do
      it 'returns `+`s and `-`s according to game rules' do
        @code = Code.new
        expect(@code.compare_with(@code.to_s)).to eq('++++')
        @code.instance_variable_set('@code', '1234')
        expect(@code.compare_with('1234')).to eq('++++')
        expect(@code.compare_with('4321')).to eq('----')
        expect(@code.compare_with('1111')).to eq('+')
        expect(@code.compare_with('2222')).to eq('+')
        expect(@code.compare_with('2121')).to eq('--')
        expect(@code.compare_with('2545')).to eq('--')
        expect(@code.compare_with('5234')).to eq('+++')
        expect(@code.compare_with('6666')).to eq('')
        expect(@code.compare_with('5134')).to eq('++-')
      end
    end
  end

  RSpec.describe Game do
    describe '#start' do
      it 'saves secret code in @code' do
        @game = Game.new
        @game.start
        expect(@game.instance_variable_get(:@code).to_s).to match(/[1-6]{4}/)
      end
    end

    describe '#use_hint' do
      it 'returns one digit from code' do
        @game = Game.new
        @game.start
        expect(@game.use_hint).to match(/[1-6]{1}/)
      end

      it 'changes @hint to false' do
        @game = Game.new
        @game.start
        @game.use_hint
        expect(@game.instance_variable_get(:@hint)).to eq(false)
      end
    end
  end

  RSpec.describe Player do
    describe '#to_s' do
      it 'returns formatted player data' do
        @player = Player.new('Ruby', 5, '1234')
        expect(@player.to_s).to eq('Player: Ruby | Turns: 5 | Code: 1234')
      end
    end
  end

  RSpec.describe Scoreboard do
    describe '#save_scores' do
      it 'creates `scoreboard.yaml`' do
        @player = Player.new('Cooper', 7, '5555')
        @scoreboard = Scoreboard.new
        @scoreboard.save_scores(@player)
        expect(File.exist?('scoreboard.yaml')).to eq(true)
      end
    end

    describe '#get_scores' do
      it 'gets data from `scoreboard.yaml`' do
        @scoreboard = Scoreboard.new
        expect(@scoreboard.get_scores.class).to eq(Array)
      end
    end
  end
end
