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

    def black?
      %i[spades clubs].include?(suit)
    end

    def to_s
      card_string = "#{@rank}#{@suit.to_s[0]}"
      if @rank < 10
        " #{card_string}"
      else
        card_string
      end
    end

    def inspect
      to_s
    end
  end

  # A NullObject card representation
  class NullCard < Card
    def initialize
      super(-1, :empty_suit)
    end

    def black?
      false
    end

    def to_s
      '   '
    end
  end
end
