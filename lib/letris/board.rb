# coding: utf-8
module Letris
  class Board
    attr_accessor :current_piece
    attr_reader :current_piece_pos
    
    BOARD_WIDTH = 10
    BOARD_HEIGHT = 20
    PIECE_INITIAL_POSITION_X = 4
    PIECE_INITIAL_POSITION_Y = 19

    def initialize
      @rows = []
      BOARD_HEIGHT.times { @rows << [] }
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

    def get_next_piece
      @current_piece = Piece.new_random
      init_piece_pos
    end

    def move_piece_down
      # if y-pos is 0, we are at the bottom row
      if @current_piece_pos[1] == 0
        place_current_piece_on_board
        get_next_piece
      end
      @current_piece_pos[1] = @current_piece_pos[1]-1 
    end

    def place_current_piece_on_board
      # 4 times because 4 is the maximum width and height of a piece. TODO: don't use a hardcoded number like this 
      4.times do |y|
        4.times do |x|
          @rows[cur_piece_pos_x+x][cur_piece_pos_y+y] = "X" if @current_piece.has_tile?(x,y)
        end
      end
    end

    def move_piece_left
      @current_piece_pos[0] = @current_piece_pos[0]-1
    end

    def move_piece_right
      @current_piece_pos[0] = @current_piece_pos[0]+1
    end

    def rotate_piece
      @current_piece.change_to_next_state!
    end

    def tile_for_xy(x, y)
      return 'X' if current_piece_has_tile_at?(x, y) #x==@current_piece_pos[0] && y == @current_piece_pos[1]
      return 'B' if @rows[x][y]
      " "
    end

    def tile_for_xy_empty?(x, y)
      return true if tile_for_xy(x, y) == " "
      false
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
