RSpec.describe Freecell do
  let(:game) { Freecell::Game.new(cascades: cascades) }

  describe 'cascade moves' do
    subject(:cascade_cards) do
      [game.cascades[0].last, game.cascades[1].last]
    end

    let(:five_of_spades) { 5 }
    let(:four_of_diamonds) { 4 }
    let(:cascades) { [cascade_one, cascade_two] }

    context 'when the move is legal' do
      let(:cascade_one) { [four_of_diamonds] }
      let(:cascade_two) { [five_of_spades] }

      before do
        game.handle_key('a')
        game.handle_key('b')
      end

      it 'moves cards between cascades' do
        expect(cascade_cards).to eq([nil, four_of_diamonds])
      end
    end

    skip 'when the move is not legal' do
      let(:cascade_one) { [four_of_diamonds] }
      let(:cascade_two) { [five_of_spades] }

      before do
        game.handle_key('b')
        game.handle_key('a')
      end

      it 'does not move cards between cascades' do
        expect(cascade_cards).to eq([four_of_diamonds, five_of_spades])
      end
    end
  end
end
