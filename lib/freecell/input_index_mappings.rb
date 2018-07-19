module Freecell
  # Mappings from input keys to game zone indices
  module InputIndexMappings
    def self.key_to_cascade_idx(key)
      key.ord - ASCIIBytes::LOWERCASE_A
    end

    def self.key_to_free_cell_idx(key)
      key.ord - ASCIIBytes::LOWERCASE_W
    end
  end
end
