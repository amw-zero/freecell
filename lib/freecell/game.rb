module Freecell
  # The game container
  class Game
    attr_reader :cascades, :free_cells, :foundations

    def initialize(cascades: [], free_cells: [], foundations: [[], [], [], []])
      @cascades = cascades
      @free_cells = free_cells
      @foundations = foundations
      @input_handler = InputHandler.new
    end

    def deal_cards
      @cascades = CascadeBuilder.new.build_cascades
    end

    def handle_key(key)
      @input_handler.handle_key(key)
      return unless @input_handler.move_complete
      perform_current_move
    end

    def perform_current_move
      Move.from(
        input: @input_handler.current_move,
        cascades: cascades,
        free_cells: free_cells,
        foundations: foundations
      ).tap do |move|
        break unless move.legal?
        move.perform
      end
    end
  end
end
