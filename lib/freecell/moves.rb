module Freecell
  # Factory for creating moves from user input
  class Move
    def self.from(input:, cascades:, free_cells:, foundations:)
      case input
      when /[a-h][a-h]/
        cascade_to_cascade_move(input, cascades)
      when /[a-h] /
        cascade_to_free_cell_move(input, cascades, free_cells)
      when /[a-h]\n/
        cascade_to_foundation_move(input, cascades, foundations)
      when /[w-z][a-h]/
        free_cell_to_cascade_move(input, cascades, free_cells)
      end
    end

    def self.cascade_to_cascade_move(input, cascades)
      CascadeToCascadeMove.new(
        cascades,
        *input.chars.map(&method(:key_to_cascade_idx))
      )
    end

    def self.cascade_to_free_cell_move(input, cascades, free_cells)
      CascadeToFreeCellMove.new(
        cascades,
        free_cells,
        key_to_cascade_idx(input.chars[0])
      )
    end

    def self.cascade_to_foundation_move(input, cascades, foundations)
      CascadeToFoundationMove.new(
        cascades,
        foundations,
        key_to_cascade_idx(input.chars[0])
      )
    end

    def self.free_cell_to_cascade_move(input, cascades, free_cells)
      FreeCellToCascadeMove.new(
        cascades,
        free_cells,
        key_to_free_cell_idx(input.chars[0]),
        key_to_cascade_idx(input.chars[1])
      )
    end

    def self.key_to_cascade_idx(key)
      key.ord - ASCIIBytes::LOWERCASE_A
    end

    def self.key_to_free_cell_idx(key)
      key.ord - ASCIIBytes::LOWERCASE_W
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
      MoveLegality.tableau_move_legal?(src_card, dest_card)
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
      @free_cells.compact.length < 4
    end

    def perform
      insert_idx = @free_cells.index(&:nil?)
      @free_cells[insert_idx] = @cascades[@src_idx].pop
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

  # Carry out a move between a free cell and a cascade
  class FreeCellToCascadeMove
    def initialize(cascades, free_cells, src_idx, dest_idx)
      @cascades = cascades
      @free_cells = free_cells
      @src_idx = src_idx
      @dest_idx = dest_idx
    end

    def legal?
      src_card = @free_cells[@src_idx]
      return false unless src_card
      dest_card = @cascades[@dest_idx].last
      MoveLegality.tableau_move_legal?(src_card, dest_card)
    end

    def perform
      card = @free_cells[@src_idx]
      @free_cells[@src_idx] = nil
      @cascades[@dest_idx] << card
    end
  end
end
