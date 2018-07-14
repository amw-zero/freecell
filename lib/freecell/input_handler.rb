module Freecell
  # Handles user input, giving it semantic game meaning
  class InputHandler
    attr_reader :move_complete, :current_move

    def initialize
      @move_parts = []
      @current_move = nil
      @move_complete = false
    end

    def handle_key(key)
      @current_move = nil
      @move_parts << sanitize_input(key)
      if @move_parts.length == 2
        @move_complete = true
        @current_move = @move_parts.join
        @move_parts = []
      else
        @move_complete = false
      end
    end

    def sanitize_input(key)
      case key
      when ASCIIBytes::CARRIAGE_RETURN
        "\n"
      else
        key
      end
    end
  end
end
