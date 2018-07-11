require 'curses'

module Freecell
  # Commandline UI
  class NcursesUI
    def initialize
      Curses.init_screen
      Curses.cbreak
      Curses.noecho
      Curses.nonl
      Curses.curs_set(0)
      @y_pos = 0
    ensure
      Curses.close_screen
    end

    def receive_key
      Curses.getch
    end

    def render(game)
      @y_pos = 0
      Curses.clear
      render_cascades(game)
      render_cascade_letters
    end

    def render_cascades(game)
      CardGrid.new(game.cascades)
              .row_representation
              .each(&method(:print_card_row))
    end

    def render_cascade_letters
      Curses.setpos(@y_pos + 1, 0)
      %w[a b c d e f g h].each do |letter|
        Curses.addstr(" #{letter}   ")
      end
    end

    def print_card_row(row)
      row.each do |card|
        Curses.addstr("#{card}  ")
      end
      @y_pos += 1
      Curses.setpos(@y_pos, 0)
    end
  end
end
