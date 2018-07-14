module Freecell
  # Factory for creating moves from user input
  class Move
    # rubocop:disable Metrics/MethodLength
    def self.from(input:, cascades:, free_cells:, foundations:)
      case input
      when /[a-h][a-h]/
        CascadeToCascadeMove.new(
          cascades,
          *input.chars.map(&method(:key_to_cascade_idx))
        )
      when /[a-h] /
        CascadeToFreeCellMove.new(
          cascades,
          free_cells,
          key_to_cascade_idx(input.chars[0])
        )
      when /[a-h]\n/
        CascadeToFoundationMove.new(
          cascades,
          foundations,
          key_to_cascade_idx(input.chars[0])
        )
      end
    end
    # rubocop:enable Metrics/MethodLength

    def self.key_to_cascade_idx(key)
      key.ord - ASCIIBytes::LOWERCASE_A
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
      src_is_one_less = src_card.rank == dest_card.rank - 1
      src_is_one_less && src_card.opposite_color?(dest_card)
    end

    def perform
      @cascades[dest_idx] << @cascades[src_idx].pop
    end
  end

  # Carry out a move between a cascade and a free cell
  class CascadeToFreeCellMove
    def initialize(cascades, free_cells, src_idx)
      @cascades = cascades
      @free_cells = free_cells
      @src_idx = src_idx.to_i
    end

    def legal?
      @free_cells.length < 4
    end

    def perform
      @free_cells << @cascades[@src_idx].pop
    end
  end

  # Carry out a move between a cascade and a foundation
  class CascadeToFoundationMove
    FOUNDATIONS = %i[spades hearts clubs diamonds].freeze

    def initialize(cascades, foundations, src_idx)
      @cascades = cascades
      @foundations = foundations
      @src_idx = src_idx.to_i
    end

    def legal?
      card = @cascades[@src_idx].last
      foundation_idx = foundation_index(card.suit)
      return card.rank == 1 if @foundations[foundation_idx].empty?

      card.rank == @foundations[foundation_idx].last.rank + 1
    end

    def perform
      card = @cascades[@src_idx].pop
      @foundations[foundation_index(card.suit)] << card
    end

    def foundation_index(card_suit)
      FOUNDATIONS.index { |suit| suit == card_suit }
    end
  end
end
