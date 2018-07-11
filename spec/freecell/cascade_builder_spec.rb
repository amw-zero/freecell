RSpec.describe Freecell::CascadeBuilder do
  describe '#build_cascades' do
    subject { described_class.new(seed: 0).build_cascades }

    let(:cascade_one) do
      [
        [8, :hearts], [7, :spades], [2, :clubs], [2, :diamonds],
        [7, :diamonds], [2, :spades], [1, :clubs]
      ]
    end

    let(:cascade_two) do
      [
        [10, :diamonds], [2, :hearts], [4, :spades], [7, :clubs],
        [5, :diamonds], [6, :clubs], [1, :hearts]
      ]
    end

    let(:cascade_three) do
      [
        [3, :clubs], [3, :spades], [9, :diamonds], [5, :hearts],
        [10, :spades], [10, :hearts], [12, :clubs]
      ]
    end

    let(:cascade_four) do
      [
        [9, :spades], [6, :spades], [13, :spades], [13, :clubs],
        [11, :diamonds], [6, :diamonds], [12, :hearts]
      ]
    end

    let(:cascade_five) do
      [
        [1, :spades], [8, :clubs], [5, :spades],
        [6, :hearts], [1, :diamonds], [5, :clubs]
      ]
    end

    let(:cascade_six) do
      [
        [8, :spades], [8, :diamonds], [13, :diamonds],
        [12, :diamonds], [4, :hearts], [3, :diamonds]
      ]
    end

    let(:cascade_seven) do
      [
        [11, :hearts], [11, :spades], [9, :clubs],
        [3, :hearts], [12, :spades], [10, :clubs]
      ]
    end

    let(:cascade_eight) do
      [
        [9, :hearts], [11, :clubs], [4, :clubs],
        [4, :diamonds], [7, :hearts], [13, :hearts]
      ]
    end

    let(:expected_cascades) do
      [
        cascade_one,
        cascade_two,
        cascade_three,
        cascade_four,
        cascade_five,
        cascade_six,
        cascade_seven,
        cascade_eight
      ].map do |cascade|
        cascade.map { |rank, suit| Freecell::Card.new(rank, suit) }
      end
    end

    def printable_cascades(cascades)
      printable_cascades = cascades.map { |cascade| cascade.map(&:to_s) }
      printable_cascades.map { |cascade| cascade.join(', ') }.join("\n")
    end

    def cascades_error_message
      "Expected cascades:\n\n" +
        printable_cascades(expected_cascades) + "\n\n" \
        "Got cascades:\n\n" +
        printable_cascades(subject)
    end

    it { is_expected.to eq(expected_cascades), cascades_error_message }
  end
end
