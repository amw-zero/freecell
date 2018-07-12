module Freecell
  # Handles user input, giving it semantic game meaning
  class InputHandler
    ASCII_LOWERCASE_A = 97

    attr_reader :move_complete, :current_move

    def initialize
      @move_parts = []
      @current_move = nil
      @move_complete = false
    end

    def handle_key(key)
      @current_move = nil
      @move_parts << key_to_cascade_idx(key)
      if @move_parts.length == 2
        @move_complete = true
        @current_move = @move_parts.join
        @move_parts = []
      else
        @move_complete = false
      end
    end

    def key_to_cascade_idx(key)
      key.ord - ASCII_LOWERCASE_A
    end
  end
end
