module Freecell
  # Builds the starting cascades of the game
  class CascadeBuilder
    CARDS_PER_SUIT = 13
    NUM_CASCADES = 8

    attr_reader :random

    def initialize(seed: Random.new_seed)
      @random = Random.new(seed)
    end

    def ranks
      (1..CARDS_PER_SUIT).to_a
    end

    def suits
      %i[hearts diamonds spades clubs]
    end

    def build_cascades
      deck = ranks.product(suits).shuffle(random: random)
      cascades = (0...NUM_CASCADES).map { [] }
      deck.each_with_index do |card, i|
        cascades[i % NUM_CASCADES] << Card.new(*card)
      end
      cascades
    end
  end
end
