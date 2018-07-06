module Freecell
  # Handles user input, giving it semantic game meaning
  class InputHandler
    attr_reader :move_complete, :current_move

    def initialize
      @move_parts = []
      @move_complete = false
      @curent_move = nil
    end

    def handle_key(key)
      @move_parts << key_to_cascade_idx(key)
      return unless @move_parts.length == 2

      @move_complete = true
      @current_move = { src_idx: @move_parts[0], dest_idx: @move_parts[1] }
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
