module Freecell
  # Handles user input, giving it semantic game meaning
  class InputHandler
    attr_reader :move_complete

    def initialize
      @move_parts = []
      @move_complete = false
    end

    def handle_key(key)
      @move_parts << key_to_cascade_idx(key)
      @move_complete = true if @move_parts.length == 2
    end

    def key_to_cascade_idx(key)
      case key
      when 'a'
        0
      when 'b'
        1
      end
    end
  end
end
