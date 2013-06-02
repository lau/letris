require 'io/wait'
SLEEP_FOR_LOOP = 0.02
LEVELS = {  0 => 0.8,
            1 => 0.7167,
            2 => 0.6333,
            3 => 0.55,
            4 => 0.4667,
            5 => 0.3833,
            6 => 0.3,
            7 => 0.2166,
            8 => 0.1333,
            9 => 0.1
   }

module Letris
  class AsciiGame
    def render_board(board)
      @renderer ||= Letris::AsciiRenderer.new
      system("clear")
      puts @renderer.render_board board, @lines_cleared
    end

    def falling_speed
      level = (@lines_cleared/10.0).floor
      level = 9 if level > 9
      LEVELS[level]
    end

    def run
      board = Letris::Board.new
      piece = Piece.new(PieceType.get_random)
      board.current_piece = piece
      @lines_cleared = 0
      render_board board

      term = `stty -g`
      `stty raw -echo cbreak`

      start = Time.now
      loop do
        if STDIN.ready?
         command = STDIN.getc
        end
        if command == 'r'
          board.rotate_piece
          render_board board
        end
        if command == 'h'
          board.move_piece_left 
          render_board board
        end
        if command == 'l'
          board.move_piece_right 
          render_board board
        end
        if command == 'f'
          board.drop_piece
          render_board board
        end
        break if command == 'q'

        if Time.now-start > falling_speed 
          board.move_piece_down
          if board.filled_row_count > 0
            @lines_cleared = @lines_cleared + board.clear_rows
          end
          start = Time.now
          render_board board
        end

        if board.is_game_over?
          puts "GAME OVER"
          break
        end
        sleep SLEEP_FOR_LOOP
      end
    end
  end
end
