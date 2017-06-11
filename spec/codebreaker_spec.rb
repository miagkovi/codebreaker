require "spec_helper"

module Codebreaker
  RSpec.describe Game do

    before(:each) do
      @game = Game.new
    end

    describe '#setup' do
      it 'creates @code instance variable' do
        expect(@game.instance_variable_get(:@code)).not_to be_empty
      end
      it 'creates @hint instance variable with value = true' do
        expect(@game.instance_variable_get(:@hint)).to eq(true)
      end
      it 'creates @attempts instance variable with value 10' do
        expect(@game.instance_variable_get(:@attempts)).to eq(10)
      end
      it 'creates empty @result instance variable' do
        expect(@game.instance_variable_get(:@result)).to eq('')
      end
    end

    describe '#create_code' do
      it 'creates 4 digits code with digits from 1 to 6' do
        expect(@game.send(:create_code)).to match(/[1-6]{4}/)
      end
    end

    describe '#use_hint' do
      it 'show one from @code' do
        expect(@game.send(:use_hint).length).to eq(1)
      end

      it 'show one digit from @code' do
        expect(@game.send(:use_hint)).to match(/[1-6]+/)
      end

      it 'change @hint to false' do
        @game.send(:use_hint)
        expect(@game.instance_variable_get(:@hint)).to eq(false)
      end
    end

    describe '#compare' do
      it 'compare codes and return +`s and -`s ' do
        expect(@game.send(:compare, '1234', '5666')).to eq('No maches....')
        expect(@game.send(:compare, '1234', '6654')).to eq('+')
        expect(@game.send(:compare, '1234', '6653')).to eq('-')
        expect(@game.send(:compare, '1234', '1234')).to eq('++++')
        expect(@game.send(:compare, '1234', '4321')).to eq('----')
        expect(@game.send(:compare, '1111', '4121')).to eq('++')
        expect(@game.send(:compare, '1214', '2324')).to eq('+--')
      end
    end

  end
end