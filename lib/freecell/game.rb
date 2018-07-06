module Freecell
  # The game container
  class Game
    attr_reader :cascades

    def initialize(cascades: [])
      @cascades = cascades
      @move_parts = []
    end

    def handle_key(key)
      @move_parts << key_to_cascade_idx(key)
      @cascades[1] << @cascades[0].pop if legal_move?
    end

    def legal_move?
      return false if @move_parts.length < 2

      src_cascade_idx, dest_cascade_idx = @move_parts
      last_cascade_card(src_cascade_idx) < last_cascade_card(dest_cascade_idx)
    end

    def key_to_cascade_idx(key)
      case key
      when 'a'
        0
      when 'b'
        1
      end
    end

    def last_cascade_card(cascade_idx)
      @cascades[cascade_idx].last
    end
  end
end
