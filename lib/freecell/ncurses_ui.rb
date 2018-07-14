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
      render_debug_info(game)
    end

    def advance_y(by:, x_pos: 0)
      @y_pos += by
      Curses.setpos(@y_pos, x_pos)
    end

    def render_top_area(game)
      Curses.addstr('space')
      advance_y(by: 1)
      render_free_cells(game)
      render_foundations(game)
      advance_y(by: 1, x_pos: 2)
      game.free_cells.length.times { |i| Curses.addstr(free_cell_letter(i)) }
    end

    def render_free_cells(game)
      game.free_cells.each { |card| Curses.addstr("[#{card}]") }
      (4 - game.free_cells.length).times { Curses.addstr("[#{NullCard.new}]") }
    end

    def render_foundations(game)
      Curses.setpos(@y_pos, 24)
      game.foundations.each do |foundation|
        if (card = foundation.last)
          Curses.addstr("[#{card}]")
        else
          Curses.addstr("[#{NullCard.new}]")
        end
      end
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
      row.each { |card| Curses.addstr("#{card}  ") }
      advance_y(by: 1, x_pos: CASCADE_MARGIN)
    end

    def render_debug_info(game)
      should_show_debug_info = false
      return unless should_show_debug_info

      advance_y(by: 2)
      current_move = game.instance_variable_get(:@input_handler).current_move
      return unless current_move

      Curses.addstr(move)
    end
  end
end
