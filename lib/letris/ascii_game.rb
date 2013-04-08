require 'io/wait'
SLEEP_FOR_LOOP = 0.02
INITIAL_FALLING_SPEED = 0.2
module Letris
  class AsciiRenderer
    def render_board(board)
      system("clear")
      buf = '' 
      buf = buf + "Keys: H: move left. L: move right. R: rotate piece. Q: quit\n"
      buf = buf + "Lines cleared: #{@lines_cleared}\n"
      y_pos = 19
      board.height.times do |y|
        buf = buf + '' 
        buf = buf + "|"
        board.width.times do |x| 
          buf = buf + "#{board.tile_for_xy(x,y_pos)}" 
        end
        buf = buf + "|"
        buf = buf + "\n"
        y_pos = y_pos - 1
      end
      buf = buf + "------------"
      puts buf
    end
  end

  class AsciiGame
    def render_board(board)
      @renderer ||= Letris::AsciiRenderer.new
      @renderer.render_board board
    end

    def run
      board = Letris::Board.new
      piece = Piece.new(PieceType.by_name :l)
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
        if command=='h'
          board.move_piece_left 
          render_board board
        end
        if command=='l'
          board.move_piece_right 
          render_board board
        end
        break if command == 'q'

        if Time.now-start > INITIAL_FALLING_SPEED 
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
