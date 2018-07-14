RSpec.describe Freecell::CascadeToCascadeMove do
  describe '#legal?' do
    subject { described_class.new(cascades, src_idx, dest_idx).legal? }

    let(:five_of_spades) { Freecell::Card.new(5, :spades) }
    let(:six_of_diamonds) { Freecell::Card.new(6, :diamonds) }
    let(:six_of_spades) { Freecell::Card.new(6, :spades) }

    context 'when the cards are opposite in color and decreasing in rank' do
      let(:cascades) do
        [
          [five_of_spades],
          [six_of_diamonds]
        ]
      end
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }

      it { is_expected.to be true }
    end

    context 'when the cards are opposite in color and more than one apart' do
      let(:four_of_spades) { Freecell::Card.new(4, :spades) }
      let(:cascades) do
        [
          [four_of_spades],
          [six_of_diamonds]
        ]
      end
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }

      it { is_expected.to be false }
    end

    context 'when the cards are opposite in color and not decreasing in rank' do
      let(:cascades) do
        [
          [five_of_spades],
          [six_of_diamonds]
        ]
      end
      let(:src_idx) { 1 }
      let(:dest_idx) { 0 }

      it { is_expected.to be false }
    end

    context 'when the cards are the same in color and decreasing in rank' do
      let(:cascades) do
        [
          [five_of_spades],
          [six_of_spades]
        ]
      end
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }

      it { is_expected.to be false }
    end

    context 'when the cards are the same in color and not decreasing in rank' do
      let(:cascades) do
        [
          [five_of_spades],
          [six_of_spades]
        ]
      end
      let(:src_idx) { 1 }
      let(:dest_idx) { 0 }

      it { is_expected.to be false }
    end
  end
end
