module Freecell
  # A playing card
  class Card
    include Comparable

    attr_reader :rank, :suit

    def initialize(rank, suit)
      @rank = rank
      @suit = suit
    end

    def <=>(other)
      @rank <=> other.rank
    end

    def ==(other)
      @rank == other.rank && @suit == other.suit
    end

    def opposite_color?(other)
      case @suit
      when :hearts, :diamonds
        %i[spades clubs].include?(other.suit)
      when :spades, :clubs
        %i[hearts diamonds].include?(other.suit)
      else
        false
      end
    end

    def to_s
      "#{@rank}#{@suit.to_s[0]}"
    end
  end
end
