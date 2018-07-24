module Freecell
  # A card that is currently selected in the UI
  class CardSelection
    def self.from(key, cascades, free_cells)
      case key
      when /\d[a-h]/
        selected_cascade_cards(key, cascades)
      when /[w-z]/
        selected_free_cell_card(key, free_cells)
      when /[a-h]/
        selected_cascade_card(key, cascades)
      else
        [NullCard.new]
      end
    end

    def self.selected_cascade_card(key, cascades)
      selected_index = InputIndexMappings.key_to_cascade_idx(key)
      [cascades[selected_index].last || NullCard.new]
    end

    def self.selected_free_cell_card(key, free_cells)
      selected_index = InputIndexMappings.key_to_free_cell_idx(key)
      [free_cells[selected_index] || NullCard.new]
    end

    def self.selected_cascade_cards(key, cascades)
      selected_index = InputIndexMappings.key_to_cascade_idx(key.chars[1])

      num_cards = key.chars[0].to_i
      return [NullCard.new] if num_cards > cascades[selected_index].length
      cascades[selected_index][-num_cards, num_cards]
    end
  end
end
