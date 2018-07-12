module Freecell
  # Factory for creating moves from user input
  class Move
    def self.from(input:, cascades:)
      case input
      when /[0-7][0-7]/
        CascadeToCascadeMove.new(cascades, input[0], input[1])
      end
    end
  end

  # Carry out a move between two cascades
  class CascadeToCascadeMove
    attr_reader :cascades, :src_idx, :dest_idx

    def initialize(cascades, src_idx, dest_idx)
      @cascades = cascades
      @src_idx = src_idx.to_i
      @dest_idx = dest_idx.to_i
    end

    def legal?
      src_card = cascades[src_idx].last
      dest_card = cascades[dest_idx].last
      (src_card < dest_card) && src_card.opposite_color?(dest_card)
    end

    def perform
      @cascades[dest_idx] << @cascades[src_idx].pop
    end
  end
end
