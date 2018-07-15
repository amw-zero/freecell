RSpec.describe Freecell::MoveLegality do
  describe '#tableau_move_legal?' do
    subject { described_class.tableau_move_legal?(src_card, dest_card) }

    let(:five_of_spades) { Freecell::Card.new(5, :spades) }
    let(:six_of_diamonds) { Freecell::Card.new(6, :diamonds) }
    let(:six_of_spades) { Freecell::Card.new(6, :spades) }

    context 'when the cards are opposite in color and decreasing in rank' do
      let(:src_card) { five_of_spades }
      let(:dest_card) { six_of_diamonds }

      it { is_expected.to be true }
    end

    context 'when the cards are opposite in color and more than one apart' do
      let(:four_of_spades) { Freecell::Card.new(4, :spades) }
      let(:src_card) { four_of_spades }
      let(:dest_card) { six_of_diamonds }

      it { is_expected.to be false }
    end

    context 'when the cards are opposite in color and not decreasing in rank' do
      let(:src_card) { six_of_diamonds }
      let(:dest_card) { five_of_spades }

      it { is_expected.to be false }
    end

    context 'when the cards are the same in color and decreasing in rank' do
      let(:src_card) { five_of_spades }
      let(:dest_card) { six_of_spades }

      it { is_expected.to be false }
    end

    context 'when the cards are the same in color and not decreasing in rank' do
      let(:src_card) { six_of_spades }
      let(:dest_card) { five_of_spades }

      it { is_expected.to be false }
    end
  end
end
