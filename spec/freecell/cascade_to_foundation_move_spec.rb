RSpec.describe Freecell::CascadeToFoundationMove do
  describe '#legal?' do
    subject { described_class.new(cascades, foundations, src_idx).legal? }

    context 'when the foundation is empty and an ace is being moved' do
      let(:ace_of_spades) { Freecell::Card.new(1, :spades) }
      let(:foundations) { [[]] }
      let(:cascades) { [[ace_of_spades]] }
      let(:src_idx) { 0 }

      it { is_expected.to be true }
    end

    context 'when the foundation is empty and a non-ace is being moved' do
      let(:two_of_spades) { Freecell::Card.new(2, :spades) }
      let(:foundations) { [[]] }
      let(:cascades) { [[two_of_spades]] }
      let(:src_idx) { 0 }

      it { is_expected.to be false }
    end

    context 'when moving an increasing ranked card to a non-empty foundation' do
      let(:two_of_spades) { Freecell::Card.new(2, :spades) }
      let(:ace_of_spades) { Freecell::Card.new(1, :spades) }
      let(:foundations) { [[ace_of_spades]] }
      let(:cascades) { [[two_of_spades]] }
      let(:src_idx) { 0 }

      it { is_expected.to be true }
    end

    context 'when moving an increasing ranked card to an empty foundation' do
      let(:three_of_spades) { Freecell::Card.new(3, :spades) }
      let(:ace_of_spades) { Freecell::Card.new(1, :spades) }
      let(:foundations) { [[ace_of_spades]] }
      let(:cascades) { [[three_of_spades]] }
      let(:src_idx) { 0 }

      it { is_expected.to be false }
    end
  end

  describe '#foundation_index' do
    subject { described_class.new([], [], 0).foundation_index(suit) }

    context 'when the suit is spades' do
      let(:suit) { :spades }

      it { is_expected.to eq 0 }
    end

    context 'when the suit is hearts' do
      let(:suit) { :hearts }

      it { is_expected.to eq 1 }
    end

    context 'when the suit is clubs' do
      let(:suit) { :clubs }

      it { is_expected.to eq 2 }
    end

    context 'when the suit is diamonds' do
      let(:suit) { :diamonds }

      it { is_expected.to eq 3 }
    end
  end
end
