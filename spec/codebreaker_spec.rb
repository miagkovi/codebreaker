require 'spec_helper'

module Codebreaker
  RSpec.describe Code do
    let(:code) { Code.new }

    it 'creates a secret code' do
      expect(code.to_s).to match(/[1-6]{4}/)
    end

    describe '#compare_with' do
      it 'returns `+`s and `-`s according to game rules' do
        code.instance_variable_set('@code', '1234')
        expect(code.compare_with('1234')).to eq('++++')
        expect(code.compare_with('4321')).to eq('----')
        expect(code.compare_with('1111')).to eq('+')
        expect(code.compare_with('2222')).to eq('+')
        expect(code.compare_with('2121')).to eq('--')
        expect(code.compare_with('2545')).to eq('--')
        expect(code.compare_with('5234')).to eq('+++')
        expect(code.compare_with('6666')).to eq('')
        expect(code.compare_with('5134')).to eq('++-')
      end
    end
  end

  RSpec.describe Game do
    before(:each) do
      @game = Game.new
      @game.start
    end

    describe '#start' do
      it 'saves secret code in @code' do
        expect(@game.instance_variable_get(:@code).to_s).to match(/[1-6]{4}/)
      end
    end

    describe '#use_hint' do
      it 'returns one digit from code' do
        expect(@game.use_hint).to match(/[1-6]{1}/)
      end

      it 'changes @hint to false' do
        @game.use_hint
        expect(@game.instance_variable_get(:@hint)).to be false
      end
    end

    describe '#analyze' do
      it 'increases @attempts by 1' do
        @attempts_before = @game.attempts
        @game.analyze('1234')
        @attempts_after = @game.attempts
        expect(@attempts_after).to eq(@attempts_before + 1)
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
    let(:scoreboard) { Scoreboard.new }

    describe '#save_scores' do
      it 'creates `scoreboard.yaml`' do
        @player = Player.new('Cooper', 7, '5555')
        scoreboard.save_scores(@player)
        expect(File.exist?('scoreboard.yaml')).to be true
      end
    end

    describe '#get_scores' do
      it 'gets data from `scoreboard.yaml`' do
        scoreboard = Scoreboard.new
        expect(scoreboard.get_scores.class).to eq(Array)
      end
    end
  end

  RSpec.describe UI do
    let(:ui) { UI.new }

    describe '#hint_available?' do
      it 'returns true if player still has a hint' do
        expect(ui.send(:hint_available?)).to be true
      end

      it 'returns false if player already used hint' do
        allow(ui).to receive_message_chain('gets.chomp') { 'y' }
        ui.send(:use_hint)
        expect(ui.send(:hint_available?)).to be false
      end
    end

    describe '#agree?' do
      it 'returns true on `y`' do
        allow(ui).to receive_message_chain('gets.chomp') { 'y' }
        expect(ui.send(:agree?)).to be true
      end

      it 'return false on `n`' do
        allow(ui).to receive_message_chain('gets.chomp') { 'n' }
        expect(ui.send(:agree?)).to be false
      end
    end
  end

  RSpec.describe String do
    before(:each) { @string = 'hohoho' }

    describe '#like' do
      context 'compares itself with regexp' do
        it 'should return true if passed' do
          expect(@string.like(/hohoho/)).to be true
        end
        it 'should false if not passed' do
          expect(@string.like(/hahaha/)).to be false
        end
      end
    end
  end
end
