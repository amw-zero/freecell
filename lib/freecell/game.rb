module Freecell
  # The game container
  class Game
    attr_reader :cascades

    def initialize(cascades: [])
      @cascades = cascades
    end

    def handle_key(key)
      @cascades[1] << @cascades[0].pop if key == 'b'
    end
  end
end
