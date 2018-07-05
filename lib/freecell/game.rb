module Freecell
  # The game container
  class Game
    attr_reader :cascades

    # Says it's a game, but also handles user input
    def initialize(cascades: [])
      # Game state
      @cascades = cascades

      # Input handling
      @move_parts = []
    end

    # Says it's handling Input keys, but it also manipulates Game state
    def handle_key(key)
      # Input handling
      @move_parts << key_to_cascade_idx(key)

      # Game state
      @cascades[1] << @cascades[0].pop if legal_move?
    end

    # Says it's checking for Moves legality, but also checks Input
    def legal_move?
      # Input handling
      return false if @move_parts.length < 2
      src_cascade_idx, dest_cascade_idx = @move_parts

      # Move legality
      last_cascade_card(src_cascade_idx) < last_cascade_card(dest_cascade_idx)
    end

    # One responsibility: Map Input keys to Game state indices
    def key_to_cascade_idx(key)
      # Input handling
      case key
      when 'a'
        0
      when 'b'
        1
      end
    end

    # One responsibility: syntactic sugar for accessing Game state
    def last_cascade_card(cascade_idx)
      # Game state
      @cascades[cascade_idx].last
    end
  end
end
