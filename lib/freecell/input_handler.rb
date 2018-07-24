module Freecell
  # FreeCell state
  class FreeCellMoveState
    def valid_key?(key)
      key =~ /[a-h]|\n/
    end

    def terminal?(move)
      move =~ /[a-h] /
    end

    def next_state_for(key)
      case key
      when /[a-h]/
        CascadeMoveState
      else
        InitialMoveState
      end.new
    end
  end

  # Foundation state
  class FoundationMoveState
    def terminal?(*)
      true
    end
  end

  # Multi card state
  class MultiCardMoveState
    def valid_key?(key)
      key =~ /[a-h]/
    end

    def terminal?(*)
      false
    end

    def next_state_for(*)
      CascadeMoveState.new
    end
  end

  # Cascade state
  class CascadeMoveState
    def valid_key?(key)
      case key
      when /[a-h]/, /[w-z]/, "\n", ' '
        true
      else
        false
      end
    end

    def terminal?(move)
      move =~ /[a-h]([a-h]|\n| )/ || move =~ /[w-z][a-h]/
    end

    def next_state_for(key)
      case key
      when /[a-h]/
        CascadeMoveState
      when ' '
        FreeCellMoveState
      when "\n"
        FoundationMoveState
      else
        InitialMoveState
      end.new
    end
  end

  # Initial state
  class InitialMoveState
    def valid_key?(key)
      case key
      when /\d/, /[a-h]/, /[w-z]/
        true
      else
        false
      end
    end

    def terminal?(*)
      false
    end

    def next_state_for(key)
      case key
      when /\d/
        MultiCardMoveState
      when /[a-h]/
        CascadeMoveState
      when /[w-z]/
        FreeCellMoveState
      else
        InitialMoveState
      end.new
    end
  end

  # Handles user input, giving it semantic game meaning
  class InputHandler
    attr_reader :move_complete, :move_parts

    def initialize
      reset_state
    end

    def handle_key(key)
      @current_move = nil
      sanitized_key = sanitize_input(key)
      unless @current_state.valid_key?(sanitized_key)
        reset_state
        return
      end

      @move_parts << sanitized_key
      @current_state = @current_state.next_state_for(sanitized_key)
      check_for_complete_move
    end

    def check_for_complete_move
      if @current_state.terminal?(move_parts.join)
        @move_complete = true
        @current_move = @move_parts.join
        @move_parts = []
        @current_state = InitialMoveState.new
      else
        @move_complete = false
      end
    end

    def current_move
      return @current_move if @current_move
      move_parts.join unless move_parts.empty?
    end

    def sanitize_input(key)
      case key
      when ASCIIBytes::CARRIAGE_RETURN
        "\n"
      else
        key
      end
    end

    def reset_state
      @move_parts = []
      @current_move = nil
      @move_complete = false
      @current_state = InitialMoveState.new
    end
  end
end
