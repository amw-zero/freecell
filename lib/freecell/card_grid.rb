module Freecell
  # A grid representation of cards
  class CardGrid
    attr_reader :cascades

    def initialize(cascades)
      @cascades = cascades
    end

    def row_representation
      padded_cascades.transpose
    end

    def padded_cascades
      max_length = cascades.map(&:length).max
      cascades.map do |cascade|
        cascade + null_cards(max_length - cascade.length)
      end
    end

    def null_cards(length)
      Array.new(length) { NullCard.new }
    end
  end
end
