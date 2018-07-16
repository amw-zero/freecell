RSpec.describe Freecell::Card do
  describe '#<=>' do
    subject { three_of_hearts <=> other_card }

    let(:three_of_hearts) { described_class.new(3, :hearts) }

    context 'when the other card is a greater rank' do
      let(:other_card) { described_class.new(4, :diamonds) }

      it { is_expected.to be(-1) }
    end

    context 'when the other card is of equal rank' do
      let(:other_card) { described_class.new(3, :clubs) }

      it { is_expected.to be 0 }
    end

    context 'when the other card is a lower rank' do
      let(:other_card) { described_class.new(2, :diamonds) }

      it { is_expected.to be 1 }
    end
  end

  describe '#opposite_color?' do
    subject { card_one.opposite_color?(card_two) }

    context 'when comparing hearts and diamonds' do
      let(:card_one) { described_class.new(1, :hearts) }
      let(:card_two) { described_class.new(1, :diamonds) }

      it { is_expected.to be false }
    end

    context 'when comparing hearts and spades' do
      let(:card_one) { described_class.new(1, :hearts) }
      let(:card_two) { described_class.new(1, :spades) }

      it { is_expected.to be true }
    end

    context 'when comparing hearts and clubs' do
      let(:card_one) { described_class.new(1, :hearts) }
      let(:card_two) { described_class.new(1, :clubs) }

      it { is_expected.to be true }
    end

    context 'when comparing clubs and diamonds' do
      let(:card_one) { described_class.new(1, :clubs) }
      let(:card_two) { described_class.new(1, :diamonds) }

      it { is_expected.to be true }
    end

    context 'when comparing clubs and spades' do
      let(:card_one) { described_class.new(1, :clubs) }
      let(:card_two) { described_class.new(1, :spades) }

      it { is_expected.to be false }
    end

    context 'when comparing spades and diamonds' do
      let(:card_one) { described_class.new(1, :spades) }
      let(:card_two) { described_class.new(1, :diamonds) }

      it { is_expected.to be true }
    end
  end

  describe '#black?' do
    subject { described_class.new(1, suit).black? }

    context 'when the suit is spades' do
      let(:suit) { :spades }

      it { is_expected.to be true }
    end

    context 'when the suit is hearts' do
      let(:suit) { :hearts }

      it { is_expected.to be false }
    end

    context 'when the suit is clubs' do
      let(:suit) { :clubs }

      it { is_expected.to be true }
    end

    context 'when the suit is diamonds' do
      let(:suit) { :diamonds }

      it { is_expected.to be false }
    end
  end
end
