RSpec.describe Freecell::MultiCardCascadeMove do
  describe '#legal?' do
    subject do
      described_class.new(
        cascades, free_cells, src_idx, dest_idx, num_cards
      ).legal?
    end

    let(:free_cells) { [] }
    let(:five_of_hearts) { Freecell::Card.new(5, :hearts) }
    let(:six_of_spades) { Freecell::Card.new(6, :spades) }
    let(:seven_of_diamonds) { Freecell::Card.new(7, :diamonds) }

    context 'when all of the cards are in tableau legal order' do
      let(:free_cells) { [five_of_hearts, five_of_hearts, five_of_hearts] }
      let(:cascades) { [[six_of_spades, five_of_hearts], [seven_of_diamonds]] }
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }
      let(:num_cards) { 2 }

      it { is_expected.to be true }
    end

    context 'when the top card is not tableau legal' do
      let(:cascades) do
        [
          [five_of_hearts, six_of_spades],
          [seven_of_diamonds]
        ]
      end
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }
      let(:num_cards) { 2 }

      it { is_expected.to be false }
    end

    context 'when a card in the set of cards is not tableau legal' do
      let(:four_of_diamonds) { Freecell::Card.new(4, :diamonds) }
      let(:cascades) do
        [
          [six_of_spades, four_of_diamonds, five_of_hearts],
          [seven_of_diamonds]
        ]
      end
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }
      let(:num_cards) { 2 }

      it { is_expected.to be false }
    end

    context 'when moving more cards than there is capacity for' do
      let(:four_of_diamonds) { Freecell::Card.new(4, :diamonds) }
      let(:two_of_hearts) { Freecell::Card.new(2, :hearts) }
      let(:four_of_clubs) { Freecell::Card.new(4, :clubs) }
      let(:three_of_hearts) { Freecell::Card.new(3, :hearts) }
      let(:two_of_spades) { Freecell::Card.new(2, :spades) }

      let(:free_cells) { [four_of_diamonds, two_of_hearts, four_of_clubs] }
      let(:cascades) do
        [
          [
            six_of_spades, five_of_hearts, four_of_clubs,
            three_of_hearts, two_of_spades
          ],
          [seven_of_diamonds],
          []
        ]
      end

      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }
      let(:num_cards) { 5 }

      it { is_expected.to be false }
    end

    context 'when there are no empty free cells but there are empty cascades' do
      let(:free_cells) do
        [six_of_spades, six_of_spades, six_of_spades, six_of_spades]
      end
      let(:cascades) do
        [
          [six_of_spades, five_of_hearts],
          [seven_of_diamonds],
          []
        ]
      end

      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }
      let(:num_cards) { 2 }

      it { is_expected.to be true }
    end
  end
end
