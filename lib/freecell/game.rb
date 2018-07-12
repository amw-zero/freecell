module Freecell
  # The game container
  class Game
    attr_reader :cascades

    def initialize(cascades: [], free_cells: [])
      @cascades = cascades
      @free_cells = free_cells
      @input_handler = InputHandler.new
    end

    def deal_cards
      @cascades = CascadeBuilder.new.build_cascades
    end

    def handle_key(key)
      @input_handler.handle_key(key)

      # Different moves and their corresponding legality checks will
      # need to be supported here
      #
      # Need to pivot on legality check
      return unless @input_handler.move_complete &&
                    legal_move?(@input_handler.current_move)

      # Need to pivot on arguments to move
      src_idx, dest_idx = @input_handler
                          .current_move
                          .values_at(:src_idx, :dest_idx)

      # Need to pivot on state to manipulate
      @cascades[dest_idx] << @cascades[src_idx].pop
    end

    def legal_move?(move)
      src_cascade_idx, dest_cascade_idx = move.values_at(:src_idx, :dest_idx)
      src_card = last_cascade_card(src_cascade_idx)
      dest_card = last_cascade_card(dest_cascade_idx)
      (src_card < dest_card) && src_card.opposite_color?(dest_card)
    end

    def last_cascade_card(cascade_idx)
      @cascades[cascade_idx].last
    end
  end
end
