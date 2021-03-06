# coding: utf-8
module Letris
  class Board
    attr_reader :current_piece
    attr_reader :current_piece_pos

    BOARD_WIDTH = 10
    BOARD_HEIGHT = 20
    PIECE_INITIAL_POSITION_X = 4
    PIECE_INITIAL_POSITION_Y = 19
    MAX_POSSIBLE_PIECE_HEIGHT = 4
    MAX_POSSIBLE_PIECE_WIDTH = 4

    def initialize
      @rows = []
      BOARD_HEIGHT.times { @rows << [] }
      init_piece_pos
      @game_over_state = false
    end

    def is_game_over?
      @game_over_state
    end

    def filled_row_indicies
      row_indicies = []
      @rows.each_with_index { |row, row_number| row_indicies << row_number if is_row_filled?(row) }
      row_indicies
    end

    def filled_row_count
      filled_row_indicies.size
    end

    def is_row_filled?(row)
      row.compact.size == width
    end

    def clear_rows
      counter = 0
      @rows.delete_if { |row| is_row_filled?(row) }
      while @rows.size < BOARD_HEIGHT
        @rows << [] # add new empty line at top
        counter = counter + 1
      end
      counter
    end

    def current_piece=(piece)
      @current_piece = piece
      init_piece_pos
    end

    def init_piece_pos
      @current_piece_pos = [PIECE_INITIAL_POSITION_X, PIECE_INITIAL_POSITION_Y]
    end

    def cur_piece_pos_x
      @current_piece_pos[0]
    end

    def cur_piece_pos_y
      @current_piece_pos[1]
    end

    def add_new_piece_by_name(name)
      self.current_piece = Piece.new(Letris::PieceType.by_name(name))
    end

    def get_next_piece
      @current_piece = Piece.new_random
      init_piece_pos
    end

    def move_piece_down
      # if y-pos is 0, we are at the bottom row
      if @current_piece_pos[1] == 0 || would_current_piece_collide_if_moved_down?
        place_current_piece_on_board
        get_next_piece
        return false
      else
        @current_piece_pos[1] = @current_piece_pos[1]-1
        return true
      end
    end

    def drop_piece
      loop { break unless move_piece_down }
    end

    def place_current_piece_on_board
      MAX_POSSIBLE_PIECE_HEIGHT.times do |y|
        MAX_POSSIBLE_PIECE_WIDTH.times do |x|
          @rows[cur_piece_pos_y+y][cur_piece_pos_x+x] = current_piece_tile if @current_piece.has_tile?(x,y) && cur_piece_pos_y+y < BOARD_HEIGHT
        end
      end
      check_for_game_over
    end

    def current_piece_tile
      @current_piece.name.to_s.upcase
    end

    def check_for_game_over
      width.times do |x|
        @game_over_state = true if current_piece_has_tile_at?(x, BOARD_HEIGHT)
      end
    end

    def move_piece_left
      if would_piece_collide_at_position?(cur_piece_pos_x-1, cur_piece_pos_y)
        return false
      else
        move_piece_left!
        return true
      end
    end

    def move_piece_right
      if would_piece_collide_at_position?(cur_piece_pos_x+1, cur_piece_pos_y)
        return false
      else
        move_piece_right!
        return true
      end
    end

    # move piece without checking for collision!
    def move_piece_left!
      @current_piece_pos[0] = @current_piece_pos[0]-1
    end

    # move piece without checking for collision!
    def move_piece_right!
      @current_piece_pos[0] = @current_piece_pos[0]+1
    end

    def rotate_piece
      rotated = @current_piece.dup
      rotated.change_to_next_state!
      if would_piece_collide_at_position?(cur_piece_pos_x, cur_piece_pos_y, rotated)
        return false
      else
        rotate_piece!
        return true
      end
    end

    def rotate_piece!
      @current_piece.change_to_next_state!
    end

    def tile_for_xy(x, y)
      return current_piece_tile if current_piece_has_tile_at?(x, y)
      return @rows[y][x] if @rows[y][x]
      " "
    end

    def tile_for_xy_empty?(x, y)
      return true if tile_for_xy(x, y) == " "
      false
    end

    def is_out_of_bounds_at_position(p_x, p_y, piece = @current_piece)
      return true if p_x < 0
      MAX_POSSIBLE_PIECE_HEIGHT.times do |y|
        MAX_POSSIBLE_PIECE_WIDTH.times do |x|
          return true if ((x+p_x) > width-1) && piece.has_tile?(x, y)
        end
      end
      false
    end

    def would_piece_collide_at_position?(p_x, p_y, piece = @current_piece)
      return true if is_out_of_bounds_at_position(p_x, p_y, piece)
      MAX_POSSIBLE_PIECE_HEIGHT.times do |y|
        MAX_POSSIBLE_PIECE_WIDTH.times do |x|
          if p_y+y < BOARD_HEIGHT # we don't look at rows above the top of the board
            return true if piece.has_tile?(x,y) && @rows[p_y+y][p_x+x]
          end
        end
      end
      false
    end

    def would_current_piece_collide_if_moved_down?
      return true if cur_piece_pos_y == 0 # the current piece is on the bottom row and has met the floor
      would_piece_collide_at_position?(cur_piece_pos_x, cur_piece_pos_y-1)
    end

    def current_piece_has_tile_at?(x, y)
      return @current_piece.has_tile?(x-@current_piece_pos[0],y-@current_piece_pos[1])
    end

    def width
      BOARD_WIDTH
    end

    def height
      BOARD_HEIGHT
    end
  end
end
