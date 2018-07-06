module Freecell
  # The game container
  class Game
    attr_reader :cascades

    def initialize(cascades: [])
      @cascades = cascades
      @input_handler = InputHandler.new
    end

    def handle_key(key)
      @input_handler.handle_key(key)
      return unless @input_handler.move_complete &&
                    legal_move?(@input_handler.current_move)
      @cascades[1] << @cascades[0].pop
    end

    def legal_move?(move)
      src_cascade_idx, dest_cascade_idx = move.values_at(:src_idx, :dest_idx)
      last_cascade_card(src_cascade_idx) < last_cascade_card(dest_cascade_idx)
    end

    def last_cascade_card(cascade_idx)
      @cascades[cascade_idx].last
    end
  end
end
