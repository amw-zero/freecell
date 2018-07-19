module Freecell
  # The game container
  class Game
    attr_reader :cascades, :free_cells, :foundations, :selected_card

    def initialize(
      cascades: [],
      free_cells: Array.new(4) { nil },
      foundations: Array.new(4) { [] }
    )
      @cascades = cascades
      @free_cells = free_cells
      @foundations = foundations
      @input_handler = InputHandler.new
      @selected_card = nil
    end

    def deal_cards
      @cascades = CascadeBuilder.new.build_cascades
    end

    def handle_key(key)
      @input_handler.handle_key(key)

      if !@input_handler.move_parts.empty? && @input_handler.move_parts.first =~ /[a-h]/
        selected_index = InputIndexMappings
                        .key_to_cascade_idx(@input_handler.move_parts.first)
        @selected_card = @cascades[selected_index].last
      elsif !@input_handler.move_parts.empty? && @input_handler.move_parts.first =~ /[w-z]/
        selected_index = InputIndexMappings
                         .key_to_free_cell_idx(@input_handler.move_parts.first)
        @selected_card = @free_cells[selected_index]
      end

      return unless @input_handler.move_complete
      perform_current_move
    end

    def perform_current_move
      Move.from(
        input: @input_handler.current_move,
        cascades: cascades,
        free_cells: free_cells,
        foundations: foundations
      ).tap do |move|
        break unless move && move.legal?
        move.perform
      end
    end
  end
end
