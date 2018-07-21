require 'curses'

module Freecell
  # Decorator for card rendering logic
  class RenderableCard
    attr_reader :card

    def initialize(card, selected_card)
      @card = card
      @selected = card.colorable? && card == selected_card
    end

    def render
      Curses.attrset(Curses.color_pair(color_pair_id)) if color_pair_id
      Curses.addstr(card.to_s)
      Curses.attrset(Curses::A_NORMAL)
    end

    def render_with_border
      Curses.addstr('[')
      render
      Curses.addstr(']')
    end

    def color_pair_id
      Color.color_pair_id(if card.black? && @selected
                            :black_selected_card
                          elsif card.red? && @selected
                            :red_selected_card
                          elsif card.black?
                            :black_card
                          end)
    end
  end

  # Color logic
  class Color
    COLOR_PAIR_IDS = {
      black_card: 1,
      black_selected_card: 2,
      red_selected_card: 3
    }.freeze

    def self.setup
      Curses.start_color
      init_black_color
      init_black_selected_color
      init_red_selected_color
    end

    def self.color_pair_id(id)
      COLOR_PAIR_IDS[id]
    end

    def self.init_black_color
      Curses.init_pair(
        COLOR_PAIR_IDS[:black_card],
        Curses::COLOR_CYAN,
        Curses::COLOR_BLACK
      )
    end

    def self.init_black_selected_color
      Curses.init_pair(
        COLOR_PAIR_IDS[:black_selected_card],
        Curses::COLOR_CYAN,
        Curses::COLOR_BLUE
      )
    end

    def self.init_red_selected_color
      Curses.init_pair(
        COLOR_PAIR_IDS[:red_selected_card],
        Curses::COLOR_WHITE,
        Curses::COLOR_BLUE
      )
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
      Color.setup
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
        RenderableCard.new(display_card, game.selected_card).render_with_border
      end
      (4 - game.free_cells.length).times { Curses.addstr("[#{NullCard.new}]") }
    end

    def render_foundations(game)
      Curses.setpos(@y_pos, 24)
      game.foundations.each do |foundation|
        if (card = foundation.last)
          RenderableCard.new(card, game.selected_card).render_with_border
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
              .each { |row| print_card_row(row, game) }
    end

    def render_cascade_letters
      advance_y(by: 1, x_pos: CASCADE_MARGIN)
      %w[a b c d e f g h].each do |letter|
        Curses.addstr(" #{letter}   ")
      end
    end

    def print_card_row(row, game)
      row.each do |card|
        RenderableCard.new(card, game.selected_card).render
        Curses.addstr('  ')
      end
      advance_y(by: 1, x_pos: CASCADE_MARGIN)
    end
  end
end
