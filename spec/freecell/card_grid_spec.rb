RSpec.describe Freecell::CardGrid do
  subject { described_class.new(cascades).row_representation }

  let(:five_of_hearts) { Freecell::Card.new(5, :hearts) }
  let(:six_of_diamonds) { Freecell::Card.new(6, :diamonds) }
  let(:seven_of_spades) { Freecell::Card.new(7, :spades) }
  let(:four_of_diamonds) { Freecell::Card.new(4, :diamonds) }
  let(:null_card) { Freecell::NullCard.new }

  let(:cascade_one) { [] }
  let(:cascade_two) do
    [five_of_hearts, six_of_diamonds, seven_of_spades]
  end
  let(:cascade_three) { [four_of_diamonds] }
  let(:cascades) { [cascade_one, cascade_two, cascade_three] }

  let(:row_represented_cascades) do
    [
      [null_card, five_of_hearts, four_of_diamonds],
      [null_card, six_of_diamonds, null_card],
      [null_card, seven_of_spades, null_card]
    ]
  end

  it { is_expected.to eq row_represented_cascades }
end
