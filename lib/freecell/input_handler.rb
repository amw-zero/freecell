module Freecell
  # Handles user input, giving it semantic game meaning
  class InputHandler
    attr_reader :move_complete, :current_move, :move_parts

    def initialize
      @move_parts = []
      @current_move = nil
      @move_complete = false
    end

    def handle_key(key)
      @current_move = nil
      @move_parts << sanitize_input(key)
      if single_card_move_complete? || multi_card_move_complete?
        @move_complete = true
        @current_move = @move_parts.join
        @move_parts = []
      else
        @move_complete = false
      end
    end

    def single_card_move_complete?
      move_parts.join =~ /^[a-z]/ && move_parts.length == 2
    end

    def multi_card_move_complete?
      move_parts.join =~ /^\d/ && move_parts.length == 3
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
