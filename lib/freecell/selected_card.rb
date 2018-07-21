module Freecell
  # A card that is currently selected in the UI
  class SelectedCard
    def self.from(key, cascades, free_cells)
      case key
      when /[a-h]/
        selected_cascade_card(key, cascades)
      when /[w-z]/
        selected_free_cell_card(key, free_cells)
      else
        NullCard.new
      end
    end

    def self.selected_cascade_card(key, cascades)
      selected_index = InputIndexMappings.key_to_cascade_idx(key)
      cascades[selected_index].last || NullCard.new
    end

    def self.selected_free_cell_card(key, free_cells)
      selected_index = InputIndexMappings.key_to_free_cell_idx(key)
      free_cells[selected_index] || NullCard.new
    end
  end
end
