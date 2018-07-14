RSpec.describe Freecell::CascadeToFreeCellMove do
  describe '#legal?' do
    subject { described_class.new(cascades, free_cells, src_idx).legal? }

    let(:cascades) { [[5]] }
    let(:src_idx) { 0 }

    context 'when there are free cells remaining' do
      let(:free_cells) { [] }

      it { is_expected.to be true }
    end

    context 'when there are no free cells remaining' do
      let(:free_cells) { [1, 2, 3, 4] }

      it { is_expected.to be false }
    end
  end
end
