module Freecell
  # Shared move legality logic
  module MoveLegality
    def self.tableau_move_legal?(src_card, dest_card)
      src_is_one_less = src_card.rank == dest_card.rank - 1
      src_is_one_less && src_card.opposite_color?(dest_card)
    end
  end
end
