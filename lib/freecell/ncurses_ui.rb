require 'curses'

module Freecell
  # Commandline UI
  class NcursesUI
    CASCADE_MARGIN = 3

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
      render_top_area(game)
      render_cascades(game)
      render_cascade_letters
    end

    def advance_y(by:, x_pos: 0)
      @y_pos += by
      Curses.setpos(@y_pos, x_pos)
    end

    def render_top_area(game)
      Curses.addstr('space')
      advance_y(by: 1)
      render_free_cells(game)
      advance_y(by: 1, x_pos: 2)
      game.free_cells.length.times { |i| Curses.addstr(free_cell_letter(i)) }
    end

    def render_free_cells(game)
      game.free_cells.each { |card| Curses.addstr("[#{card}]") }
      (4 - game.free_cells.length).times { Curses.addstr("[#{NullCard.new}]") }
    end

    def free_cell_letter(index)
      "#{%w[w x y z][index]}    "
    end

    def render_cascades(game)
      advance_y(by: 2, x_pos: CASCADE_MARGIN)
      CardGrid.new(game.cascades)
              .row_representation
              .each(&method(:print_card_row))
    end

    def render_cascade_letters
      advance_y(by: 1, x_pos: CASCADE_MARGIN)
      %w[a b c d e f g h].each do |letter|
        Curses.addstr(" #{letter}   ")
      end
    end

    def print_card_row(row)
      row.each do |card|
        Curses.addstr("#{card}  ")
      end
      advance_y(by: 1, x_pos: CASCADE_MARGIN)
    end
  end
end
