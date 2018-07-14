RSpec.describe Freecell do
  describe 'game setup' do
    let(:game) { Freecell::Game.new }
    let(:cascades) { game.cascades }

    before do
      game.deal_cards
    end

    it 'deals the correct number of cascades' do
      expect(cascades.length).to eq(8)
    end

    it 'deals the correct number of cards in each cascade' do
      expect(cascades.map(&:length)).to eq([7, 7, 7, 7, 6, 6, 6, 6])
    end
  end

  describe 'cascade moves' do
    subject(:cascade_cards) do
      [game.cascades[0], game.cascades[1]]
    end

    let(:game) { Freecell::Game.new(cascades: cascades) }

    let(:five_of_spades) { Freecell::Card.new(5, :spades) }
    let(:four_of_diamonds) { Freecell::Card.new(4, :diamonds) }
    let(:cascades) { [cascade_one, cascade_two] }

    context 'when the move is legal' do
      let(:cascade_one) { [four_of_diamonds] }
      let(:cascade_two) { [five_of_spades] }

      before do
        game.handle_key('a')
        game.handle_key('b')
      end

      it 'moves cards between cascades' do
        expect(cascade_cards).to eq([[], [five_of_spades, four_of_diamonds]])
      end
    end

    context 'when the move is not legal' do
      let(:cascade_one) { [four_of_diamonds] }
      let(:cascade_two) { [five_of_spades] }

      before do
        game.handle_key('b')
        game.handle_key('a')
      end

      it 'does not move cards between cascades' do
        expect(cascade_cards).to eq([[four_of_diamonds], [five_of_spades]])
      end
    end

    context 'when an illegal move is made after a legal one' do
      let(:three_of_diamonds) { Freecell::Card.new(3, :diamonds) }
      let(:cascade_one) { [three_of_diamonds, four_of_diamonds] }
      let(:cascade_two) { [five_of_spades] }

      before do
        game.handle_key('a')
        game.handle_key('b')

        game.handle_key('a')
        game.handle_key('b')
      end

      it 'moves legal cards between cascades, but not illegal cards' do
        expect(cascade_cards).to eq(
          [[three_of_diamonds], [five_of_spades, four_of_diamonds]]
        )
      end
    end

    context 'when multiple legal moves are made after another' do
      let(:five_of_clubs) { Freecell::Card.new(5, :clubs) }
      let(:cascade_one) { [five_of_clubs, four_of_diamonds] }
      let(:cascade_two) { [five_of_spades] }

      before do
        game.handle_key('a')
        game.handle_key('b')

        game.handle_key('b')
        game.handle_key('a')
      end

      it 'moves the cards between cascades' do
        expect(cascade_cards).to eq(
          [[five_of_clubs, four_of_diamonds], [five_of_spades]]
        )
      end
    end
  end

  describe 'Cascade to free cell moves' do
    subject { game.free_cells }

    let(:game) do
      Freecell::Game.new(cascades: cascades)
    end

    let(:cascades) { [[five_of_diamonds]] }
    let(:five_of_diamonds) { Freecell::Card.new(5, :diamonds) }

    before do
      game.handle_key('a')
      game.handle_key(' ')
    end

    it { is_expected.to eq([five_of_diamonds, nil, nil, nil]) }
  end

  describe 'Cascade to foundation moves' do
    subject { game.foundations }

    let(:game) { Freecell::Game.new(cascades: cascades) }

    let(:ace_of_spades) { Freecell::Card.new(1, :spades) }
    let(:cascades) { [[ace_of_spades]] }

    before do
      game.handle_key('a')
      game.handle_key(Freecell::ASCIIBytes::CARRIAGE_RETURN)
    end

    it { is_expected.to eq [[ace_of_spades], [], [], []] }
  end

  describe 'Free cell to cascade moves' do
    subject { [game.cascades[0].last, free_cells] }

    let(:game) do
      Freecell::Game.new(cascades: cascades, free_cells: free_cells)
    end

    let(:three_of_hearts) { Freecell::Card.new(3, :hearts) }
    let(:four_of_clubs) { Freecell::Card.new(4, :clubs) }

    let(:free_cells) { [three_of_hearts] }
    let(:cascades) { [[four_of_clubs]] }

    before do
      game.handle_key('w')
      game.handle_key('a')
    end

    it { is_expected.to eq [three_of_hearts, [nil]] }
  end

  describe 'invalid moves' do
    subject { [cascades, free_cells, foundations] }

    let(:game) do
      Freecell::Game.new(
        cascades: cascades,
        free_cells: free_cells,
        foundations: foundations
      )
    end

    let(:cascades) { [[]] }
    let(:free_cells) { [] }
    let(:foundations) { [] }

    before do
      game.handle_key('l')
      game.handle_key(17)
    end

    it { is_expected.to eq [cascades, free_cells, foundations] }
  end
end
