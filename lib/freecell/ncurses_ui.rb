require 'curses'

module Freecell
  COLOR_PAIR_IDS = {
    black_card: 1
  }.freeze

  # Decorator for card rendering logic
  class RenderableCard
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def render
      if card.black?
        Curses.attrset(Curses.color_pair(COLOR_PAIR_IDS[:black_card]))
      end
      Curses.addstr(card.to_s)
      Curses.attrset(Curses::A_NORMAL)
    end

    def render_with_border
      Curses.addstr('[')
      render
      Curses.addstr(']')
    end
  end

  # Commandline UI
  class NcursesUI
    CASCADE_MARGIN = 3

    def initialize
      Curses.init_screen
      Curses.cbreak
      Curses.noecho
      Curses.nonl
      Curses.curs_set(0)
      setup_color
      @y_pos = 0
    ensure
      Curses.close_screen
    end

    def setup_color
      Curses.start_color
      Curses.init_pair(
        COLOR_PAIR_IDS[:black_card],
        Curses::COLOR_CYAN,
        Curses::COLOR_BLACK
      )
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
      Curses.addstr('space                                  enter')
      advance_y(by: 1)
      render_free_cells(game)
      render_foundations(game)
      advance_y(by: 1, x_pos: 2)
      game.free_cells.each_with_index do |card, i|
        render_free_cell_letter(i) if card
      end
    end

    def render_free_cell_letter(free_cell_idx)
      Curses.setpos(@y_pos, 2 + 5 * free_cell_idx)
      Curses.addstr(free_cell_letter(free_cell_idx))
    end

    def render_free_cells(game)
      game.free_cells.each do |card|
        display_card = card || NullCard.new
        RenderableCard.new(display_card).render_with_border
      end
      (4 - game.free_cells.length).times { Curses.addstr("[#{NullCard.new}]") }
    end

    def render_foundations(game)
      Curses.setpos(@y_pos, 24)
      game.foundations.each do |foundation|
        if (card = foundation.last)
          RenderableCard.new(card).render_with_border
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
      row.each do |card|
        RenderableCard.new(card).render
        Curses.addstr('  ')
      end
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
