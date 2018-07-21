module Freecell
  # Factory for creating moves from user input
  class Move
    # rubocop:disable Metrics/MethodLength
    def self.from(input:, cascades:, free_cells:, foundations:)
      case input
      when /^[a-h][a-h]/
        cascade_to_cascade_move(input, cascades)
      when /^[a-h] /
        cascade_to_free_cell_move(input, cascades, free_cells)
      when /^[a-h]\n/
        cascade_to_foundation_move(input, cascades, foundations)
      when /^[w-z][a-h]/
        free_cell_to_cascade_move(input, cascades, free_cells)
      when /^\d[a-h][a-h]/
        multi_card_cascade_move(input, cascades, free_cells)
      end
    end
    # rubocop:enable Metrics/MethodLength

    def self.cascade_to_cascade_move(input, cascades)
      CascadeToCascadeMove.new(
        cascades,
        *input.chars.map do |char|
          InputIndexMappings.key_to_cascade_idx(char)
        end
      )
    end

    def self.cascade_to_free_cell_move(input, cascades, free_cells)
      CascadeToFreeCellMove.new(
        cascades,
        free_cells,
        InputIndexMappings.key_to_cascade_idx(input.chars[0])
      )
    end

    def self.cascade_to_foundation_move(input, cascades, foundations)
      CascadeToFoundationMove.new(
        cascades,
        foundations,
        InputIndexMappings.key_to_cascade_idx(input.chars[0])
      )
    end

    def self.free_cell_to_cascade_move(input, cascades, free_cells)
      FreeCellToCascadeMove.new(
        cascades,
        free_cells,
        InputIndexMappings.key_to_free_cell_idx(input.chars[0]),
        InputIndexMappings.key_to_cascade_idx(input.chars[1])
      )
    end

    def self.multi_card_cascade_move(input, cascades, free_cells)
      MultiCardCascadeMove.new(
        cascades,
        free_cells,
        InputIndexMappings.key_to_cascade_idx(input.chars[1]),
        InputIndexMappings.key_to_cascade_idx(input.chars[2]),
        input.chars[0]
      )
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
      return false unless src_card
      dest_card = cascades[dest_idx].last
      return true if dest_card.nil?
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
      return true unless dest_card
      MoveLegality.tableau_move_legal?(src_card, dest_card)
    end

    def perform
      card = @free_cells[@src_idx]
      @free_cells[@src_idx] = nil
      @cascades[@dest_idx] << card
    end
  end

  # Carry out moving multiple cards between cascades
  class MultiCardCascadeMove
    def initialize(cascades, free_cells, src_idx, dest_idx, num_cards)
      @cascades = cascades
      @free_cells = free_cells
      @src_idx = src_idx.to_i
      @dest_idx = dest_idx.to_i
      @num_cards = num_cards.to_i
    end

    def legal?
      return false unless can_move_num_cards?
      return false unless all_src_cards_legal?
      return true if dest_card.nil?

      MoveLegality.tableau_move_legal?(top_src_card, dest_card)
    end

    def all_src_cards
      @cascades[@src_idx][-@num_cards, @num_cards]
    end

    def all_src_cards_legal?
      all_src_cards.each_cons(2).all? do |top_card, bottom_card|
        MoveLegality.tableau_move_legal?(bottom_card, top_card)
      end
    end

    def dest_card
      @cascades[@dest_idx].last
    end

    def top_src_card
      @cascades[@src_idx][-@num_cards]
    end

    def free_cell_capacity
      GameConstants::NUM_FREE_CELLS - @free_cells.compact.length + 1
    end

    def can_move_num_cards?
      open_cascade_multiplier = @cascades.count(&:empty?)
      total_capacity = free_cell_capacity * 2**open_cascade_multiplier
      @num_cards <= total_capacity
    end

    def perform
      @cascades[@dest_idx] +=
        @cascades[@src_idx].slice!(-@num_cards, @num_cards)
    end
  end
end
