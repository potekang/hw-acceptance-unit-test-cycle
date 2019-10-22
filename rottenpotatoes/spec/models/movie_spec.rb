require 'spec_helper'

describe Movie do
  describe 'get same  directors' do
    it 'should catch all same directors' do
      expect(Movie).to receive(:where).with(:director => 'me')
      Movie.same_director('me')
    end
  end
end