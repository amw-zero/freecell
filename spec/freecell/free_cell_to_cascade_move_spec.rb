RSpec.describe Freecell::FreeCellToCascadeMove do
  describe '#legal?' do
    subject do
      described_class.new(cascades, free_cells, src_idx, dest_idx).legal?
    end

    let(:five_of_spades) { Freecell::Card.new(5, :spades) }
    let(:src_idx) { 0 }
    let(:dest_idx) { 0 }
    let(:cascades) { [[five_of_spades]] }

    context 'when there is a card at the source index' do
      let(:four_of_hearts) { Freecell::Card.new(4, :hearts) }
      let(:free_cells) { [four_of_hearts] }

      it { is_expected.to be true }
    end

    context 'when there is not a card at the source index' do
      let(:free_cells) { [] }

      it { is_expected.to be false }
    end
  end
end
