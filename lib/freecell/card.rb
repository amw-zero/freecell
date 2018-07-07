module Freecell
  # A playing card
  class Card
    include Comparable

    attr_reader :rank

    def initialize(rank, suit)
      @rank = rank
      @suit = suit
    end

    def <=>(other)
      @rank <=> other.rank
    end
  end
end
