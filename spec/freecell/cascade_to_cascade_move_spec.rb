RSpec.describe Freecell::CascadeToCascadeMove do
  describe '#legal?' do
    subject { described_class.new(cascades, src_idx, dest_idx).legal? }

    let(:three_of_diamonds) { Freecell::Card.new(3, :diamonds) }

    context 'when there is no card in the source cascade' do
      let(:cascades) { [[], [three_of_diamonds]] }
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }

      it { is_expected.to be false }
    end

    context 'when there is no card in the destination cascade' do
      let(:cascades) { [[three_of_diamonds], []] }
      let(:src_idx) { 0 }
      let(:dest_idx) { 1 }

      it { is_expected.to be true }
    end
  end
end
