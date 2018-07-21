RSpec.describe Freecell::SelectedCard do
  describe 'from' do
    subject { described_class.from(key, cascades, free_cells) }

    let(:five_of_hearts) { Freecell::Card.new(5, :hearts) }
    let(:null_card) { Freecell::NullCard.new }
    let(:cascades) { nil }
    let(:free_cells) { nil }

    context 'when selecting a cascade with cards' do
      let(:key) { 'a' }
      let(:cascades) { [[five_of_hearts]] }

      it { is_expected.to eq([five_of_hearts]) }
    end

    context 'when selecting a cascade with no cards' do
      let(:key) { 'a' }
      let(:cascades) { [[]] }

      it { is_expected.to eq([null_card]) }
    end

    context 'when the key is for a free cell that has a card' do
      let(:key) { 'w' }
      let(:free_cells) { [five_of_hearts] }

      it { is_expected.to eq([five_of_hearts]) }
    end

    context 'when the key is for a free cell that has no card' do
      let(:key) { 'w' }
      let(:free_cells) { [] }

      it { is_expected.to eq([null_card]) }
    end

    context 'when the key is not for a free cell or cascade' do
      let(:key) { 'k' }
      let(:cascades) { [[]] }
      let(:free_cells) { nil }

      it { is_expected.to eq([null_card]) }
    end

    context 'when multiple cards are selected' do
      let(:six_of_spades) { Freecell::Card.new(6, :spades) }
      let(:key) { '2a' }
      let(:cascades) { [[five_of_hearts, six_of_spades]] }

      it { is_expected.to eq([five_of_hearts, six_of_spades]) }
    end

    context 'when cards are selected past the cascade bounds' do
      let(:six_of_spades) { Freecell::Card.new(6, :spades) }
      let(:key) { '8a' }
      let(:cascades) { [[five_of_hearts, six_of_spades]] }

      it { is_expected.to eq([null_card]) }
    end
  end
end
